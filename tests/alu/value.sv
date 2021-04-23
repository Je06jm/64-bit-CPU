`include "tests/testing.svh"

`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module IValueTest();
    ulong_t value;
    ulong_t result;
    sizeFlags_t size;
    logic signExtend;

    IValue ivalue(
        value,
        result,
        size,
        signExtend
    );

    initial begin
        value = 0;
        size = BITS_8;
        signExtend = 0;
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();

        value = -1;
        size = BITS_8;
        signExtend = 0;
        #1
        `DO_TEST(result, 8'hff, "8 bit zero extend");

        signExtend = 1;
        #1
        `DO_TEST(result, -1, "8 bit sign extend");

        value = 1;
        #1
        `DO_TEST(result, 1, "8 bit sign extend 2");

        value = -1;
        size = BITS_16;
        signExtend = 0;
        #1
        `DO_TEST(result, 16'hffff, "16 bit zero extend");

        signExtend = 1;
        #1
        `DO_TEST(result, -1, "16 bit sign extend");

        value = 1;
        #1
        `DO_TEST(result, 1, "16 bit sign extend 2");

        value = -1;
        size = BITS_32;
        signExtend = 0;
        #1
        `DO_TEST(result, 32'hffffffff, "32 bit zero extend");

        signExtend = 1;
        #1
        `DO_TEST(result, -1, "32 bit sign extend");

        value = 1;
        #1
        `DO_TEST(result, 1, "32 bit sign extend 2");

        value = -1;
        size = BITS_64;
        signExtend = 0;
        #1
        `DO_TEST(result, -1, "64 bit zero extend");

        signExtend = 1;
        #1
        `DO_TEST(result, -1, "64 bit sign extend");

        value = 1;
        #1
        `DO_TEST(result, 1, "64 bit sign extend 2");


        $finish();
    end
endmodule
