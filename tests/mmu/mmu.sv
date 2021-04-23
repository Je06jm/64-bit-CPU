`include "tests/testing.svh"

`include "rtl/types.svh"
`include "rtl/requests.svh"
`include "rtl/exceptions.svh"

import types::*;
import requests::*;
import exceptions::*;


module MMUTest();
    parameter MMUTLBEntries = 16;
    parameter RAMSize = 16;

    logic clock, reset;
    logic enabled;

    ulong_t pageTableAddr;

    cpuMemRequest_t cpu_request;
    cpuMemResult_t cpu_result;
    exception_t cpu_exception;

    cpuMemRequest_t mem_request;
    cpuMemResult_t mem_result;

    ubyte_t RAM[RAMSize*'h1000-1:0];

    MMU mmu(
        clock, reset,
        enabled,
        pageTableAddr,
        cpu_request,
        cpu_result,
        cpu_exception,
        mem_request,
        mem_result
    );

    defparam mmu.TLBEntries = MMUTLBEntries;

    int i;

    initial begin
        clock = 0;
        reset = 1;

        enabled = 0;

        pageTableAddr = 64'h0;

        cpu_request = {64'h0, 64'h0, 1'b0, 1'b0, 1'b0};
        mem_result = {64'h0, 1'b0};

        $readmemh({`PATH, "memory.hex"}, RAM);
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();
        #1
        reset = 0;

        #3

        
        `DO_TEST(cpu_result, {64'h0, 1'b0}, "Paging disabled; Idle");
        `DO_TEST(cpu_exception, NONE, "Pagine disabled; Idle - exception");

        enabled = 1;

        #2
        `DO_TEST(cpu_request, {64'h0, 1'b0}, "Paging enabled; Idle");
        `DO_TEST(cpu_exception, NONE, "Pagine enabled; Idle - exception");

        enabled = 0;

        cpu_request = {64'h50, 64'habcd, 1'b1, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'h0, 1'b1}, "Paging disabled; Write");
        `DO_TEST(cpu_exception, NONE, "Pagine disabled; Write - exception");

        cpu_request = {64'h50, 64'h0, 1'b0, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'habcd, 1'b1}, "Paging disabled; Read");
        `DO_TEST(cpu_exception, NONE, "Pagine disabled; Read - exception");

        cpu_request = {64'h50, 64'habcd, 1'b1, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'h0, 1'b1}, "Paging disabled; Write privaliged");
        `DO_TEST(cpu_exception, NONE, "Pagine disabled; Write privaliged - exception");

        cpu_request = {64'h50, 64'h0, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'habcd, 1'b1}, "Paging disabled; Read privaliged");
        `DO_TEST(cpu_exception, NONE, "Pagine disabled; Read privaliged - exception");

        cpu_request = {64'h0, 64'b0, 1'b0, 1'b0, 1'b0};

        pageTableAddr = 64'h1000;

        #2
        `DO_TEST(cpu_exception, NONE, "Paging disabled; Page table addr - exception");

        enabled = 1;
        
        #2
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Page table addr - exception");

        #2
        pageTableAddr = 0;

        cpu_request = {64'h50, 64'h0, 1'b0, 1'b0, 1'b1};

        #12
        `DO_TEST(cpu_result, {64'habcd, 1'b1}, "Paging enabled; Page read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; - exception");

        cpu_request = {64'h50, 64'h1, 1'b1, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Write to R/O");
        `DO_TEST(cpu_exception, PAGE_READ_ONLY, "Paging enabled; Write to R/O - exception");

        cpu_request = {64'h50, 64'h1, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'habcd, 1'b1}, "Paging enabled; Privileged read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged read - exception");

        cpu_request = {64'h50, 64'h1, 1'b1, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Privileged write to R/O");
        `DO_TEST(cpu_exception, PAGE_READ_ONLY, "Paging enabled; Privileged write to R/O - exception");

        cpu_request = {64'h40000080, 64'b0, 1'b0, 1'b0, 1'b1};

        #12
        `DO_TEST(cpu_result, {64'b0, 1'b1}, "Paging enabled; GB page read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; GB page read - exception");

        cpu_request = {64'h40000080, 64'b1, 1'b1, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; GB page write");
        `DO_TEST(cpu_exception, PAGE_READ_ONLY, "Paging enabled; GB page write - exception");

        cpu_request = {64'h40000080, 64'b0, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b1}, "Paging enabled; Privileged GB page read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged GB page read - exception");

        cpu_request = {64'h40000080, 64'b1, 1'b1, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Privileged GB page write");
        `DO_TEST(cpu_exception, PAGE_READ_ONLY, "Paging enabled; Privileged GB page write - exception");

        cpu_request = {64'h80000060, 64'b0, 1'b0, 1'b0, 1'b1};

        #12
        `DO_TEST(cpu_result, {64'b0, 1'b1}, "Paging enabled; Write-enabled page read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Write-enabled page read - exception");

        cpu_request = {64'h80000060, 64'b1, 1'b1, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b1}, "Paging enabled; Write-enable page write");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Write-enable page write - exception");

        cpu_request = {64'h80000060, 64'b0, 1'b0, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b1, 1'b1}, "Paging enabled; Write-enable page read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Write-enable page read - exception");
        
        cpu_request = {64'h80000060, 64'h2, 1'b1, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b1}, "Paging enabled; Privileged write-enable page write");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged write-enable page write - exception");

        cpu_request = {64'h80000060, 64'b0, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'h2, 1'b1}, "Paging enabled; Privileged write-enable page read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged write-enable page read - exception");

        cpu_request = {64'hc0000060, 64'b0, 1'b0, 1'b0, 1'b1};

        #12
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Privileged-Page R/O read");
        `DO_TEST(cpu_exception, PAGE_PRIVALIGED_ACCESS, "Paging enabled; Privileged-Page R/O read - exception")

        cpu_request = {64'hc0000060, 64'h3, 1'b1, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Privileged-Page R/O write");
        `DO_TEST(cpu_exception, PAGE_PRIVALIGED_ACCESS, "Paging enabled; Privileged-Page R/O write - exception");


        cpu_request = {64'hc0000060, 64'b0, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'h2, 1'b1}, "Paging enabled; Privileged Privileged-Page R/O read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged Privileged-Page R/O read - exception")

        cpu_request = {64'hc0000060, 64'h3, 1'b1, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Privileged Privileged-Page R/O write");
        `DO_TEST(cpu_exception, PAGE_READ_ONLY, "Paging enabled; Privileged Privileged-Page R/O write - exception");

        cpu_request = {64'h100000060, 64'h0, 1'b0, 1'b0, 1'b1};

        #12
        `DO_TEST(cpu_result, {64'h0, 1'b0}, "Paging enabled; Privileged-Page write-enabled read");
        `DO_TEST(cpu_exception, PAGE_PRIVALIGED_ACCESS, "Paging enabled; Privileged-Page write-enabled read - exception")

        cpu_request = {64'h100000060, 64'h3, 1'b1, 1'b0, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b0}, "Paging enabled; Privileged-Page write-enabled write");
        `DO_TEST(cpu_exception, PAGE_PRIVALIGED_ACCESS, "Paging enabled; Privileged-Page write-enabled write - exception");

        cpu_request = {64'h100000060, 64'h0, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'h2, 1'b1}, "Paging enabled; Privileged Privileged-Page write-enabled read");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged Privileged-Page write-enabled read - exception")

        cpu_request = {64'h100000060, 64'h3, 1'b1, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'b0, 1'b1}, "Paging enabled; Privileged Privileged-Page write-enabled write");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged Privileged-Page write-enabled write - exception");

        cpu_request = {64'h100000060, 64'h0, 1'b0, 1'b1, 1'b1};

        #6
        `DO_TEST(cpu_result, {64'h3, 1'b1}, "Paging enabled; Privileged Privileged-Page write-enabled write test");
        `DO_TEST(cpu_exception, NONE, "Paging enabled; Privileged Privileged-Page write-enabled read test - exception")

        #16
        $finish();
    end

    always begin
        #1 clock = !clock;

        if (clock) begin
            if (mem_request.isValid) begin
                if (mem_request.isWrite) begin
                    {
                        RAM[mem_request.addr],
                        RAM[mem_request.addr+1],
                        RAM[mem_request.addr+2],
                        RAM[mem_request.addr+3],
                        RAM[mem_request.addr+4],
                        RAM[mem_request.addr+5],
                        RAM[mem_request.addr+6],
                        RAM[mem_request.addr+7]
                    } = mem_request.data;

                    mem_result = {64'h0, 1'b1};

                    $display("[%0d] Writing to %0h: %h", $realtime, mem_request.addr, mem_request.data);
                end else begin
                    mem_result = {
                        {
                            RAM[mem_request.addr],
                            RAM[mem_request.addr+1],
                            RAM[mem_request.addr+2],
                            RAM[mem_request.addr+3],
                            RAM[mem_request.addr+4],
                            RAM[mem_request.addr+5],
                            RAM[mem_request.addr+6],
                            RAM[mem_request.addr+7]
                        },
                        1'b1
                    };

                    $display("[%0d] Reading from %0h: %h", $realtime, mem_request.addr, mem_result.data);
                end
            end
        end
    end

endmodule
