`include "tests/testing.svh"

`include "rtl/types.svh"

import types::*;

module ICompareTest();

    ulong_t a, b;
    logic zero, negitive;

    ICompare cmp(
        a, b,
        zero, negitive
    );

    initial begin
        a = 0;
        b = 0;
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();

        a = 3;
        b = 1;
        #1
        `DO_TEST(zero, 'b0, "3 does not equals 1");
        `DO_TEST(negitive, 'b0, "3 is not less then 1");

        a = 2;
        b = 2;
        #1
        `DO_TEST(zero, 'b1, "2 equals 2");
        `DO_TEST(negitive, 'b0, "2 is not less then 2");

        a = 4;
        b = 5;
        #1
        `DO_TEST(zero, 'b0, "4 does not equals 5");
        `DO_TEST(negitive, 'b1, "4 is less then 5");

        $finish();
    end

endmodule
