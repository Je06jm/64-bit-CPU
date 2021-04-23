`include "tests/testing.svh"

`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

`define RESULT_FLAG_CHECK(r, er, cr, c, ec, cc, m) \
    useCarry = 0; \
    carryIn = 0; \
    #1 \
    `DO_TEST(result, r, {m, " (carryIn = 0, useCarry = 0); resolves correctly"}); \
    `DO_TEST(carry, c, {m, " (carryIn = 0, useCarry = 0); carry flag is correct"}); \
    carryIn = 1; \
    #1 \
    `DO_TEST(result, r, {m, " (carryIn = 1, useCarry = 0); resolves correctly"}); \
    `DO_TEST(carry, c, {m, " (carryIn = 1, useCarry = 0); carry flag is correct"}); \
    carryIn = 0; \
    useCarry = 1; \
    #1 \
    `DO_TEST(result, er, {m, " (carryIn = 0, useCarry = 1); resolves correctly"}); \
    `DO_TEST(carry, ec, {m, " (carryIn = 0, useCarry = 1); carry flag is correct"}); \
    carryIn = 1; \
    #1 \
    `DO_TEST(result, cr, {m, " (carryIn = 1, useCarry = 1); resolves correctly"}); \
    `DO_TEST(carry, cc, {m, " (carryIn = 1, useCarry = 1); carry flag is correct"});

module BitwiseTest();

    opcode_t op;

    sizeFlags_t size;
    logic carryIn;
    logic useCarry;

    ulong_t a, b;
    ulong_t result;

    logic carry;

    Bitwise bitwise(
        op,
        size,
        carryIn,
        useCarry,
        a, b,
        result,
        carry
    );

    initial begin
        op = NOP;
        size = BITS_8;
        carryIn = 0;
        useCarry = 0;
        a = 0;
        b = 0;
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();
 
        op = AND;
        a = 3;
        b = 1;
        
        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 0, "3 & 1");

        op = OR;
        b = 4;

        `RESULT_FLAG_CHECK(7, 7, 7, 0, 0, 0, "3 | 4");

        op = XOR;
        a = 3;
        b = 6;

        `RESULT_FLAG_CHECK(5, 5, 5, 0, 0, 0, "3 ^ 6");

        op = NOT;
        a = 1;

        `RESULT_FLAG_CHECK(-2, -2, -2, 0, 0, 0, "!1");

        op = ROLR;
        a = 1;
        b = 1;

        `RESULT_FLAG_CHECK('h80, 0, 'h80, 0, 1, 1, "1 ROLR 1 (8 BITS)");

        size = BITS_16;
        
        `RESULT_FLAG_CHECK('h8000, 0, 'h8000, 0, 1, 1, "1 ROLR 1 (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK('h80000000, 0, 'h80000000, 0, 1, 1, "1 ROLR 1 (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK('h8000000000000000, 0, 'h8000000000000000, 0, 1, 1, "1 ROLR 1 (64 BITS)");

        size = BITS_8;
        b = 0;
        
        `RESULT_FLAG_CHECK(1, 1, 1, 1, 0, 1, "1 ROLR 0 (8 BITS)");

        size = BITS_16;

        `RESULT_FLAG_CHECK(1, 1, 1, 1, 0, 1, "1 ROLR 0 (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK(1, 1, 1, 1, 0, 1, "1 ROLR 0 (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK(1, 1, 1, 1, 0, 1, "1 ROLR 0 (64 BITS)");

        op = ROLL;
        size = BITS_8;
        a = 'h80;
        b = 1;

        `RESULT_FLAG_CHECK(1, 0, 1, 0, 1, 1, "1 ROLL 1 (8 BITS)");

        size = BITS_16;
        a = 'h8000;

        `RESULT_FLAG_CHECK(1, 0, 1, 0, 1, 1, "1 ROLL 1 (16 BITS)");

        size = BITS_32;
        a = 'h80000000;

        `RESULT_FLAG_CHECK(1, 0, 1, 0, 1, 1, "1 ROLL 1 (32 BITS)");

        size = BITS_64;
        a = 'h8000000000000000;

        `RESULT_FLAG_CHECK(1, 0, 1, 0, 1, 1, "1 ROLL 1 (64 BITS)");

        size = BITS_8;
        a = 1;
        b = 0;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 1, "1 ROLL 0 (8 BITS)");

        size = BITS_16;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 1, "1 ROLL 0 (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 1, "1 ROLL 0 (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 1, "1 ROLL 0 (64 BITS)");

        size = BITS_8;
        op = SHIFTR;
        a = 3;
        b = 1;

        `RESULT_FLAG_CHECK(1, 1, 'h81, 0, 0, 0, "3 SHIFTR 1 (8 BITS)");

        size = BITS_16;

        `RESULT_FLAG_CHECK(1, 1, 'h8001, 0, 0, 0, "3 SHIFTR 1 (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK(1, 1, 'h80000001, 0, 0, 0, "3 SHIFTR 1 (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK(1, 1, 'h8000000000000001, 0, 0, 0, "3 SHIFTR 1 (64 BITS)");

        size = BITS_8;
        b = 0;

        `RESULT_FLAG_CHECK(3, 3, 3, 0, 0, 1, "3 SHIFTR 0 (8 BITS)");

        size = BITS_16;

        `RESULT_FLAG_CHECK(3, 3, 3, 0, 0, 1, "3 SHIFTR 0 (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK(3, 3, 3, 0, 0, 1, "3 SHIFTR 0 (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK(3, 3, 3, 0, 0, 1, "3 SHIFTR 0 (64 BITS)");

        op = SHIFTL;
        size = BITS_8;
        a = 'hc0;
        b = 1;

        `RESULT_FLAG_CHECK('h80, 'h80, 'h81, 1, 1, 1, "0xc0 SHIFTL 1 (8 BITS)");

        size = BITS_16;
        a = 'hc000;

        `RESULT_FLAG_CHECK('h8000, 'h8000, 'h8001, 1, 1, 1, "0xc000 SHIFTL 1 (16 BITS)");

        size = BITS_32;
        a = 'hc0000000;

        `RESULT_FLAG_CHECK('h80000000, 'h80000000, 'h80000001, 1, 1, 1, "0xc0000000 SHIFTL 1 (32 BITS)");

        size = BITS_64;
        a = 'hc000000000000000;

        `RESULT_FLAG_CHECK('h8000000000000000, 'h8000000000000000, 'h8000000000000001, 1, 1, 1, "0xc000000000000000 SHIFTL 1 (64 BITS)");

        size = BITS_8;
        a = 1;
        b = 0;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 0, "1 SHIFTL 0 (8 BITS)");

        size = BITS_16;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 0, "1 SHIFTL 0 (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 0, "1 SHIFTL 0 (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK(1, 1, 1, 0, 0, 0, "1 SHIFTL 0 (64 BITS)");

        op = FLIP;
        size = BITS_8;
        a = 'haaaaaaaaaaaaaaaa;

        `RESULT_FLAG_CHECK('h55, 'h55, 'h55, 0, 0, 0, "FLIP 0xaa (8 BITS)");

        size = BITS_16;

        `RESULT_FLAG_CHECK('h5555, 'h5555, 'h5555, 0, 0, 0, "FLIP 0xaaaa (16 BITS)");

        size = BITS_32;

        `RESULT_FLAG_CHECK('h55555555, 'h55555555, 'h55555555, 0, 0, 0, "FLIP 0xaaaaaaaa (32 BITS)");

        size = BITS_64;

        `RESULT_FLAG_CHECK('h5555555555555555, 'h5555555555555555, 'h5555555555555555, 0, 0, 0, "FLIP 0xaaaaaaaaaaaaaaaa (64 BITS)");

        $finish();
    end

endmodule
