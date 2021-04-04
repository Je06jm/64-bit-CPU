`include "rtl/defines.svh"

import defines::*;

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
    uquad_t virtualAddr, physicalAddr;
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
    input uquad_t pageTableAddr,

    input cpuMemRequest_t cpu_request,
    output cpuMemResult_t cpu_result,
    output exception cpu_exception,

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
            buffer[i] <= {64'h0, 64'h0, 1'b0};
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
    end

    // TLB cached lookup (IDLE)

    logic foundEntry;

    // TODO: Double check these values!
    uquad_t GBAddr = {cpu_request.addr[63:`KB_SIZE+`MB_SIZE+`GB_SIZE], {(`KB_SIZE+`MB_SIZE+`GB_SIZE){1'b0}}};
    uquad_t MBAddr = {cpu_request.addr[63:`KB_SIZE+`MB_SIZE], {(`KB_SIZE+`MB_SIZE){1'b0}}};
    uquad_t KBAddr = {cpu_request.addr[63:`KB_SIZE], {`KB_SIZE{1'b0}}};

    uquad_t GBOffset = {{(64-`KB_SIZE-`MB_SIZE-`GB_SIZE){1'b0}}, cpu_request.addr[`KB_SIZE+`MB_SIZE+`GB_SIZE:0]};
    uquad_t MBOffset = {{(64-`KB_SIZE-`MB_SIZE){1'b0}}, cpu_request.addr[`KB_SIZE+`MB_SIZE:0]};
    uquad_t KBOffset = {{(64-`KB_SIZE){1'b0}}, cpu_request.addr[`KB_SIZE:0]};

    logic passResult;

    always @(posedge clock) begin
        foundEntry = 0;
        if (cpu_request.isValid && enabled) begin
            cpu_exception = NONE;

            if (stage == IDLE) begin
                for (i = 0; i < TLBEntries; i = i + 1) begin
                
                    if (GBAddr == buffer[i].virtualAddr && buffer[i].size == `GB && !foundEntry) begin
                        foundEntry = 1;

                        if (cpu_request.isPrivaliged != buffer[i].isPrivaliged)
                            cpu_exception <= PAGE_PRIVALIGED_ACCESS;

                        else if (cpu_request.isWrite && !buffer[i].canWrite) 
                            cpu_exception <= PAGE_READ_ONLY;

                        else begin
                            mem_request <= {
                                buffer[i].physicalAddr | GBOffset,
                                cpu_request.data,
                                cpu_request.isWrite,
                                1'b0,
                                cpu_request.isValid
                            };

                            passResult <= 1;
                        end

                    end else if (MBAddr == buffer[i].virtualAddr && buffer[i].size == `MB && !foundEntry) begin
                        foundEntry = 1;

                        if (cpu_request.isPrivaliged != buffer[i].isPrivaliged)
                            cpu_exception <= PAGE_PRIVALIGED_ACCESS;

                        else if (cpu_request.isWrite && !buffer[i].canWrite) 
                            cpu_exception <= PAGE_READ_ONLY;

                        else begin
                            mem_request <= {
                                buffer[i].physicalAddr | MBOffset,
                                cpu_request.data,
                                cpu_request.isWrite,
                                1'b0,
                                cpu_request.isValid
                            };

                            passResult <= 1;
                        end

                    end else if (MBAddr == buffer[i].virtualAddr && buffer[i].size == `KB && !foundEntry) begin
                        foundEntry = 1;

                        if (cpu_request.isPrivaliged != buffer[i].isPrivaliged)
                            cpu_exception <= PAGE_PRIVALIGED_ACCESS;
                            
                        else if (cpu_request.isWrite && !buffer[i].canWrite) 
                            cpu_exception <= PAGE_READ_ONLY;

                        else begin
                            mem_request <= {
                                buffer[i].physicalAddr | KBOffset,
                                cpu_request.data,
                                cpu_request.isWrite,
                                1'b0,
                                cpu_request.isValid
                            };

                            passResult <= 1;
                        end
                    end
                end
            end

            if (!foundEntry) begin
                passResult <= 0;

                stage <= LOOKUP_PT0;

                mem_request <= {
                    pageTableAddr | PT0Index,
                    64'b0,
                    1'b0,
                    1'b0,
                    1'b1
                };
            end

        end else if (!enabled) begin
            if (pageTableAddr[`PAGE_FLAG_SIZE:0] != 0) begin
                cpu_exception <= INVALID_ADDRESS;
                mem_request <= {64'b0, 64'b0, 1'b0, 1'b0, 1'b0};

            end else begin
                cpu_exception <= NONE;
                mem_request <= {
                    cpu_request.addr,
                    cpu_request.data,
                    cpu_request.isWrite,
                    1'b0,
                    cpu_request.isValid
                };
            end

        end else begin
            cpu_exception <= NONE;
            stage <= IDLE;

            mem_request <= {64'b0, 64'b0, 1'b0, 1'b0, 1'b0};
        end

        if (passResult)
            cpu_result <= mem_result;
        
        else
            cpu_result <= {64'b0, 1'b0};
    end

    // TODO: Double check these values!
    logic[`GB_SIZE-1:0] PT0Index = cpu_request.addr[`KB_SIZE+`MB_SIZE+`GB_SIZE+9:`KB_SIZE+`MB_SIZE+9];
    logic[`MB_SIZE-1:0] PT1Index = cpu_request.addr[`KB_SIZE+`MB_SIZE+9:`KB_SIZE+9];
    logic[`KB_SIZE-3-1:0] PT2Index = cpu_request.addr[`KB_SIZE+9:`KB_SIZE];

    // TLB lookup PT0 (LOOKUP_PT0)

    always @(posedge clock) begin
        if (cpu_request.isValid && enabled) begin
            if (stage == LOOKUP_PT0) begin
                if (mem_result.isValid) begin
                    // GB page
                    if (mem_result.data & `PAGE_FLAG_SIZE) begin
                        buffer[counter] <= {
                            mem_result.data[63:`KB_SIZE],
                            GBAddr,
                            2'h`GB,
                            (mem_result.data & `PAGE_FLAG_PRIVALIGE) != 0,
                            (mem_result.data & `PAGE_FLAG_WRITE) != 0,
                            1'b1
                        };

                        counter <= counter + 1;

                        stage <= IDLE;

                    end else begin
                        mem_request <= {
                            mem_result.data[63:`KB_SIZE] | PT1Index,
                            64'b0,
                            1'b0,
                            1'b0,
                            1'b1
                        };

                        stage <= LOOKUP_PT1;
                    end

                end else
                    cpu_exception <= NO_PAGE_MAPPED;
            end
        end
    end

    // TLB lookup PT1 (LOOKUP_PT1)

    always @(posedge clock) begin
        if (cpu_request.isValid && enabled) begin
            if (stage == LOOKUP_PT1) begin
                if (mem_result.isValid) begin
                    // MB page
                    if (mem_result.data & `PAGE_FLAG_SIZE) begin
                        buffer[counter] <= {
                            mem_result.data[63:`KB_SIZE],
                            MBAddr,
                            2'h`MB,
                            (mem_result.data & `PAGE_FLAG_PRIVALIGE) != 0,
                            (mem_result.data & `PAGE_FLAG_WRITE) != 0,
                            1'b1
                        };

                        counter <= counter + 1;

                        stage <= IDLE;

                    end else begin
                        mem_request <= {
                            mem_result.data[63:`KB_SIZE] | PT2Index,
                            64'b0,
                            1'b0,
                            1'b0,
                            1'b1
                        };

                        stage <= LOOKUP_PT2;
                    end

                end else
                    cpu_exception <= NO_PAGE_MAPPED;
            end
        end
    end

    // TLB lookup PT2 (LOOKUP_PT2)

    always @(posedge clock) begin
        if (cpu_request.isValid && enabled) begin
            if (stage == LOOKUP_PT2) begin
                if (mem_result.isValid) begin
                    // KB page
                    if (mem_result.data & `PAGE_FLAG_SIZE) begin
                        buffer[counter] <= {
                            mem_result.data[63:`KB_SIZE],
                            GBAddr,
                            2'h`KB,
                            (mem_result.data & `PAGE_FLAG_PRIVALIGE) != 0,
                            (mem_result.data & `PAGE_FLAG_WRITE) != 0,
                            1'b1
                        };

                        counter <= counter + 1;

                        stage <= IDLE;

                    end else begin
                        mem_request <= {64'b0, 64'b0, 1'b0, 1'b0, 1'b0};
                        cpu_exception <= INVALID_PAGE_ENTRY;

                        stage <= IDLE;
                    end

                end else
                    cpu_exception <= NO_PAGE_MAPPED;
            end
        end
    end

endmodule
