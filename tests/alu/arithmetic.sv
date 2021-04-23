`include "tests/testing.svh"

`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

`define RESULT_FLAG_CHECK(r, c, d, msg) \
    `DO_TEST(result, r, {msg, "; resolves correctly"}); \
    `DO_TEST(carry, c, {msg, "; carry flag is correct"}); \
    `DO_TEST(divByZero, d, {msg, "; divide by zero is correct"});

module ArithmeticTest();

    opcode_t op;
    logic carryIn;
    ulong_t a, b;
    ulong_t result;
    logic divByZero;
    logic carry;

    Arithmetic arith(
        op,
        carryIn,
        a, b,
        result,
        divByZero,
        carry
    );

    initial begin
        op = NOP;
        carryIn = 0;
        a = 0;
        b = 0;
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();

        op = ADD;
        a = 1;
        b = 2;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "1 + 2");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(4, 0, 0, "1 + 2 + carry");

        b = -2;
        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(-1, 0, 0, "1 + -2");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(0, 1, 0, "1 + -2 + carry");

        a = -1;
        b = 0;
        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(-1, 0, 0, "-1 + 0");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(0, 1, 0, "-1 + 0 + carry");

        b = 1;
        #1
        `RESULT_FLAG_CHECK(1, 1, 0, "-1 + 1 + carry");

        op = SUB;
        a = 3;
        b = 1;
        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(2, 0, 0, "3 - 1");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "3 - 1 - carry");

        b = 3;
        #1
        `RESULT_FLAG_CHECK(-1, 1, 0, "3 - 3 - carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(0, 0, 0, "3 - 3");

        a = -2;
        b = 1;
        #1
        `RESULT_FLAG_CHECK(-3, 0, 0, "-2 - 1");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(-4, 0, 0, "-2 - 1 - carry");

        b = -2;
        #1
        `RESULT_FLAG_CHECK(-1, 1, 0, "-2 - -2 - carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(0, 0, 0, "-2 - -2");

        op = MUL;
        a = 2;
        b = 3;
        #1
        `RESULT_FLAG_CHECK(6, 0, 0, "2 * 3");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(6, 0, 0, "2 * 3 carry");

        b = -1;
        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(-2, 1, 0, "2 * -1");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(-2, 1, 0, "2 * -1 carry");

        op = UDIV;
        a = 6;
        b = 2;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "unsigned 6 / 2");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "unsigned 6 / 3 carry");

        a = -2;
        b = 2;
        #1
        `RESULT_FLAG_CHECK(9223372036854775807, 0, 0, "unsigned -2 / 2");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(9223372036854775807, 0, 0, "unsigned -2 / 2 carry");

        b = -2;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "unsigned -2 / -2 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "unsigned -2 / -2");

        b = 0;
        #1
        `DO_TEST(divByZero, 1, "unsigned 0 / 0; divide by zero is correct");

        carryIn = 1;
        #1
        `DO_TEST(divByZero, 1, "unsigned 0 / 0 carry; divide by zero is correct");

        op = SDIV;
        a = 6;
        b = 2;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "signed 6 / 2 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "signed 6 / 2");

        b = -2;
        #1
        `RESULT_FLAG_CHECK(-3, 1, 0, "signed 6 / -2");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(-3, 1, 0, "signed 6 / -2 carry");

        b = 0;
        #1
        `DO_TEST(divByZero, 1, "signed 0 / 0 carry; divide by zero is correct");

        carryIn = 0;
        #1
        `DO_TEST(divByZero, 1, "signed 0 / 0; divide by zero is correct");

        op = UMOD;
        a = 2;
        b = 3;
        #1
        `RESULT_FLAG_CHECK(2, 0, 0, "unsigned 2 % 3");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(2, 0, 0, "unsigned 2 % 3 carry");

        a = 4;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "unsigned 4 % 3 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "unsigned 4 % 3");

        b = -3;
        #1
        `RESULT_FLAG_CHECK(4, 0, 0, "unsigned 4 % -3");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(4, 0, 0, "unsigned 4 % -3 carry");

        a = -5;
        b = 2;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "unsigned -5 % 2 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "unsigned -5 % 2");

        b = 0;
        #1
        `DO_TEST(divByZero, 1, "unsigned 0 % 0; divide by zero is correct");

        carryIn = 1;
        #1
        `DO_TEST(divByZero, 1, "unsigned 0 % 0 carry; divide by zero is correct");

        op = SMOD;
        a = 2;
        b = 3;
        #1
        `RESULT_FLAG_CHECK(2, 0, 0, "signed 2 % 3");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(2, 0, 0, "signed 2 % 3 carry");

        a = 4;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "signed 4 % 3 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "signed 4 % 3");

        b = -3;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "signed 4 % -3");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "signed 4 % -3 carry");

        a = -5;
        b = 2;
        #1
        `RESULT_FLAG_CHECK(-1, 1, 0, "signed -5 % 2 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(-1, 1, 0, "signed -5 % 2");

        b = 0;
        #1
        `DO_TEST(divByZero, 1, "signed 0 % 0; divide by zero is correct");

        carryIn = 1;
        #1
        `DO_TEST(divByZero, 1, "signed 0 % 0 carry; divide by zero is correct");

        op = INC;
        a = 2;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "inc 2 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "inc 2");

        b = 5;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "inc 2 b = 5");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(3, 0, 0, "inc 2 carry b = 5");

        op = DEC;
        a = 2;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "dec 2 carry");

        carryIn = 0;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "dec 2");

        b = 8;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "dec 2 b = 8");

        carryIn = 1;
        #1
        `RESULT_FLAG_CHECK(1, 0, 0, "dec 2 carry b = 8");

        $finish();
    end

endmodule
