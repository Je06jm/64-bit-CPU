`include "rtl/types.svh"
`include "rtl/requests.svh"
`include "rtl/exceptions.svh"

import types::*;
import requests::*;
import exceptions::*;

`define PAGE_FLAG_PRESENT   12'b000000000001
`define PAGE_FLAG_SIZE      12'b000000000010
`define PAGE_FLAG_PRIVALIGE 12'b000000000100
`define PAGE_FLAG_WRITE     12'b000000001000

`define KB_SIZE     12
`define MB_SIZE     9
`define GB_SIZE     9
`define ENTRIES     512

`define KB 0
`define MB 1
`define GB 2
`define UNUSED 3

typedef logic[1:0] PageSize;

typedef struct packed {
    ulong_t virtualAddr, physicalAddr;
    PageSize size;
    logic isPrivaliged;
    logic canWrite;
    logic isValid;
} TLEntry;

typedef enum logic[1:0] {
    IDLE,
    LOOKUP_PT0,
    LOOKUP_PT1,
    LOOKUP_PT2
} MMUStage;

module MMU #(
    parameter TLBEntries = 8
) (
    input logic clock, reset,

    input logic enabled,
    input ulong_t pageTableAddr,

    input cpuMemRequest_t cpu_request,
    output cpuMemResult_t cpu_result,
    output exception_t cpu_exception,

    output cpuMemRequest_t mem_request,
    input cpuMemResult_t mem_result
);

    TLEntry[TLBEntries - 1:0] buffer;
    logic[$clog2(TLBEntries)-1:0] counter;
    MMUStage stage;

    integer i;

    // TLB entrys reset

    always @(posedge reset) begin
        for (i = 0; i < TLBEntries; i = i + 1) begin
            buffer[i] <= {64'h0, 64'h0, 1'b0, 1'b0, 1'b0};
        end

        counter <= 0;
    end

    // Other reset

    always @(posedge reset) begin
        stage <= IDLE;

        cpu_result.isValid <= 0;
        cpu_exception <= NONE;
        mem_request.isValid <= 0;

        passResult <= 0;
        foundEntry <= 0;
    end
    
    ulong_t GBAddr;
    ulong_t MBAddr;
    ulong_t KBAddr;

    // TODO: Double check these values!
    always @* begin
        GBAddr <= {cpu_request.addr[63:`KB_SIZE+`MB_SIZE+`GB_SIZE], {(`KB_SIZE+`MB_SIZE+`GB_SIZE){1'b0}}};
        MBAddr <= {cpu_request.addr[63:`KB_SIZE+`MB_SIZE], {(`KB_SIZE+`MB_SIZE){1'b0}}};
        KBAddr <= {cpu_request.addr[63:`KB_SIZE], {`KB_SIZE{1'b0}}};
    end

    ulong_t GBOffset;
    ulong_t MBOffset;
    ulong_t KBOffset;

    // TODO: Double check these values!
    always @* begin
        GBOffset <= {{(64-`KB_SIZE-`MB_SIZE-`GB_SIZE){1'b0}}, cpu_request.addr[`KB_SIZE+`MB_SIZE+`GB_SIZE-1:0]};
        MBOffset <= {{(64-`KB_SIZE-`MB_SIZE){1'b0}}, cpu_request.addr[`KB_SIZE+`MB_SIZE-1:0]};
        KBOffset <= {{(64-`KB_SIZE){1'b0}}, cpu_request.addr[`KB_SIZE-1:0]};
    end

    logic unsigned[8:0] TB1Entry;
    logic unsigned[8:0] TB0Entry;

    // TODO: Double check these values!
    always @* begin
        TB1Entry <= GBAddr >> (`KB_SIZE+`MB_SIZE+`GB_SIZE);
        TB0Entry <= MBAddr >> (`KB_SIZE+`MB_SIZE);
    end

    logic passResult;

    // Pass through memory
    always @* begin
        if (!enabled) begin
            cpu_exception <= NONE;

            mem_request <= cpu_request;
            passResult <= 1;
            stage <= IDLE;
        end

        if (passResult)
            cpu_result <= mem_result;
        else
            cpu_result <= {64'b0, 1'b0};
    end

    // Don't pass if cpu_exception is not NONE
    always @* begin
        if (cpu_exception != NONE)
            cpu_result <= {64'b0, 1'b0};
    end

    logic foundEntry;

    // IDLE
    always @(posedge clock) begin
        foundEntry = 0;

        if (
            enabled &&
            cpu_request.isValid &&
            (stage == IDLE)
        ) begin
            cpu_exception = NONE;

            for (i = 0; i < TLBEntries; i = i + 1) begin
                // GB entry lookup
                if (
                    (buffer[i].virtualAddr == GBAddr) &&
                    (buffer[i].size == `GB) &&
                    buffer[i].isValid
                ) begin
                    foundEntry = 1;
                    
                    if (buffer[i].isPrivaliged && !cpu_request.isPrivaliged)
                        cpu_exception <= PAGE_PRIVALIGED_ACCESS;

                    else if (!buffer[i].canWrite && cpu_request.isWrite)
                        cpu_exception <= PAGE_READ_ONLY;
                    
                    else begin
                        mem_request <= {
                            buffer[i].physicalAddr | GBOffset,
                            cpu_request.data,
                            cpu_request.isWrite,
                            1'b0,
                            1'b1
                        };

                        passResult <= 1;
                    end

                // MB entry lookup
                end else if (
                    (buffer[i].virtualAddr == MBAddr) &&
                    (buffer[i].size == `MB) &&
                    buffer[i].isValid
                ) begin
                    foundEntry = 1;

                    if (buffer[i].isPrivaliged && !cpu_request.isPrivaliged)
                        cpu_exception <= PAGE_PRIVALIGED_ACCESS;

                    else if (!buffer[i].canWrite && cpu_request.isWrite)
                        cpu_exception <= PAGE_READ_ONLY;
                    
                    else begin
                        mem_request <= {
                            buffer[i].physicalAddr | MBOffset,
                            cpu_request.data,
                            cpu_request.isWrite,
                            1'b0,
                            1'b1
                        };

                        passResult <= 1;
                    end
                
                // KB entry lookup
                end else if (
                    (buffer[i].virtualAddr == KBAddr) &&
                    (buffer[i].size == `KB) &&
                    buffer[i].isValid
                ) begin
                    foundEntry = 1;

                    if (buffer[i].isPrivaliged && !cpu_request.isPrivaliged)
                        cpu_exception <= PAGE_PRIVALIGED_ACCESS;

                    else if (!buffer[i].canWrite && cpu_request.isWrite)
                        cpu_exception <= PAGE_READ_ONLY;
                    
                    else begin
                        mem_request <= {
                            buffer[i].physicalAddr | KBOffset,
                            cpu_request.data,
                            cpu_request.isWrite,
                            1'b0,
                            1'b1
                        };

                        passResult <= 1;
                    end
                end
            end

            // Page Table lookup
            if (!foundEntry) begin
                mem_request <= {
                    pageTableAddr | {TB1Entry, 3'b0},
                    64'b0,
                    1'b0,
                    1'b0,
                    1'b1
                };

                passResult <= 0;
                stage <= LOOKUP_PT0;
            end
        end
    end

    // Lookup PT0
    always @(posedge clock) begin
        if (
            enabled &&
            (stage == LOOKUP_PT0) &&
            (mem_result.isValid)
        ) begin
            if (mem_result.data & `PAGE_FLAG_PRESENT) begin
                if (mem_result.data & `PAGE_FLAG_SIZE) begin
                    // GB page
                    buffer[counter] <= {
                        GBAddr,
                        {mem_result.data[63:`KB_SIZE], {(`KB_SIZE){1'b0}}},
                        2'h`GB,
                        (mem_result.data & `PAGE_FLAG_PRIVALIGE) ? 1'b1 : 1'b0,
                        (mem_result.data & `PAGE_FLAG_WRITE) ? 1'b1 : 1'b0,
                        1'b1
                    };

                    counter <= counter + 1;
                    stage <= IDLE;

                end else begin
                    mem_request <= {
                        {mem_result.data[63:`KB_SIZE], {(`KB_SIZE){1'b0}}} | {TB0Entry, 3'b0},
                        64'b0,
                        1'b0,
                        1'b0,
                        1'b1
                    };

                    stage <= LOOKUP_PT1;
                end

            end else begin
                stage <= IDLE;
                cpu_exception <= NO_PAGE_MAPPED;

            end
        end
    end

    // Lookup PT1
    always @(posedge clock) begin
        if (
            enabled &&
            (stage == LOOKUP_PT1) &&
            (mem_result.isValid)
        ) begin
            if (mem_result.data & `PAGE_FLAG_PRESENT) begin
                if (mem_result.data & `PAGE_FLAG_SIZE) begin
                    // MB page
                    buffer[counter] <= {
                        MBAddr,
                        {mem_result.data[63:`KB_SIZE], {(`KB_SIZE){1'b0}}},
                        2'h`MB,
                        (mem_result.data & `PAGE_FLAG_PRIVALIGE) != 0,
                        (mem_result.data & `PAGE_FLAG_WRITE) != 0,
                        1'b1
                    };

                    counter <= counter + 1;
                    stage <= IDLE;

                end else begin
                    mem_request <= {
                        {mem_result.data[63:`KB_SIZE], {(`KB_SIZE){1'b0}}} | {TB0Entry, 3'b0},
                        64'b0,
                        1'b0,
                        1'b0,
                        1'b1
                    };

                    stage <= LOOKUP_PT2;
                end

            end else begin
                stage <= IDLE;
                cpu_exception <= NO_PAGE_MAPPED;

            end
        end
    end

    // Lookup PT2
    always @(posedge clock) begin
        if (
            enabled &&
            (stage == LOOKUP_PT2) &&
            (mem_result.isValid)
        ) begin
            if (mem_result.data & `PAGE_FLAG_PRESENT) begin
                if (mem_result.data & `PAGE_FLAG_SIZE) begin
                    // KB page
                    buffer[counter] <= {
                        KBAddr,
                        {mem_result.data[63:`KB_SIZE], {(`KB_SIZE){1'b0}}},
                        2'h`KB,
                        (mem_result.data & `PAGE_FLAG_PRIVALIGE) != 0,
                        (mem_result.data & `PAGE_FLAG_WRITE) != 0,
                        1'b1
                    };

                    counter <= counter + 1;
                    stage <= IDLE;

                end else begin
                    stage <= IDLE;
                    cpu_exception <= NO_PAGE_MAPPED;
                end

            end else begin
                stage <= IDLE;
                cpu_exception <= NO_PAGE_MAPPED;

            end
        end
    end
    
    ulong_t addr, phys;
    PageSize psize;
    logic isPri, canWri, isVal;

    always @* begin
        addr <= buffer[3].virtualAddr;
        phys <= buffer[3].physicalAddr;
        psize <= buffer[3].size;
        isPri <= buffer[3].isPrivaliged;
        canWri <= buffer[3].canWrite;
        isVal <= buffer[3].isValid;
    end

endmodule
