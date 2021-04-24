`include "tests/testing.svh"

`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

`define RESULT_FLAG_CHECK(r, z, c, n, m) \
    #1 \
    `DO_TEST(result, r, {m, "; resolves correctly"}); \
    `DO_TEST(zero, z, {m, "; zero flag is correct"}); \
    `DO_TEST(carry, c, {m, "; carry flag is correct"}); \
    `DO_TEST(negitive, n, {m, "; negitive flag is correct"});

module ALUTest();

    opcode_t op;
    sizeFlags_t aSize, bSize;
    logic aSignExtend, bSignExtend;
    ulong_t a, b;
    logic useCarry, carryIn;
    sizeFlags_t resultSize;
    ulong_t result;
    logic divByZero;
    logic zero, carry, negitive;

    ALU alu(
        op,
        aSize, bSize,
        aSignExtend, bSignExtend,
        a, b,
        useCarry, carryIn,
        resultSize,
        result,
        divByZero,
        zero, carry, negitive
    );

    initial begin
        op = NOP;
        aSize = BITS_8;
        bSize = BITS_8;
        aSignExtend = 0;
        bSignExtend = 0;
        a = 0;
        b = 0;
        useCarry = 0;
        carryIn = 0;
        resultSize = BITS_8;
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();

        op = ADD;
        aSize = BITS_8;
        resultSize = BITS_64;

        a = 'hff;
        b = 0;

        aSignExtend = 1;
        
        `RESULT_FLAG_CHECK(-1, 0, 0, 1, "A IValue connection");

        bSize = BITS_16;
        bSignExtend = 1;

        a = 0;
        b = 'hffff;

        `RESULT_FLAG_CHECK(-1, 0, 0, 1, "B IValue connection");


        a = 'h1;
        b = 'h2;

        `RESULT_FLAG_CHECK(3, 0, 0, 0, "ALU Arithmetic connection");

        op = OR;
        a = 'b10;
        b = 'b01;

        `RESULT_FLAG_CHECK(3, 0, 0, 0, "ALU Bitwise connection");

        op = CMP;
        a = 3;
        b = 2;
        resultSize = BITS_64;

        `RESULT_FLAG_CHECK(1, 0, 0, 0, "CMP 3 > 2");

        b = 3;

        `RESULT_FLAG_CHECK(0, 1, 0, 0, "CMP 3 == 3");

        b = 4;
        `RESULT_FLAG_CHECK(-1, 0, 1, 1, "CMP 3 < 4");

        a = -2;
        b = -1;

        `RESULT_FLAG_CHECK(-1, 0, 1, 1, "CMP -2 < -1");

        b = -2;

        `RESULT_FLAG_CHECK(0, 1, 0, 0, "CMP -2 == -2");

        b = -3;

        `RESULT_FLAG_CHECK(1, 0, 0, 0, "CMP -2 > -3");

        $finish();
    end

endmodule
