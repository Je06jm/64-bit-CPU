`include "tests/testing.svh"

`include "rtl/types.svh"
`include "rtl/instructions.svh"
`include "rtl/exceptions.svh"

import types::*;
import instructions::*;
import exceptions::*;

module ALUTest();
    instruction_t instr;
    logic carry;
    long_t result;
    logic z, n, c, sn;

    ALU alu(
        instr,
        carry,
        result,
        z, n, c, sn
    );

    initial begin
        carry = 0;

        instr.opcode = NOP;
        instr.argSize0 = BITS_8;
        instr.argSize1 = BITS_8;
        instr.argSize2 = BITS_8;
        instr.argSize3 = BITS_8;
        instr.flags = `NO_FLAGS;
        instr.arg0 = 0;
        instr.arg1 = 0;
        instr.arg2 = 0;
        instr.arg3 = 0;

    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars();

        #1
        `DO_TEST({result, z, n, c, sn}, {64'b0, 1'b0, 1'b0, 1'b0, 1'b0}, "NOP");

        #1
        instr.opcode = ADD;
        instr.arg0 = 1;
        instr.arg1 = 2;

        #1
        `DO_TEST(result, 64'h3, "(Result) ADD 8.8");
        `DO_TEST(z, 1'b0, "(Zero) ADD 8.8");
        `DO_TEST(n, 1'b0, "(Carry) ADD 8.8");
        `DO_TEST(sn, 1'b0, "(Signed Carry) ADD 8.8");

        #1
        instr.opcode = SUB;

        #1
        `DO_TEST(result, 64'hff, "(Result) SUB 8.8");
        `DO_TEST(z, 1'b0, "(Zero) SUB 8.8");
        `DO_TEST(n, 1'b0, "(Carry) SUB 8.8");
        `DO_TEST(sn, 1'b0, "(Signed Carry) SUB 8.8");

        #1
        instr.opcode = MUL;
        instr.arg0 = 3;

        #1
        `DO_TEST(result, 64'h6, "(Result) MUL 8.8");
        `DO_TEST(z, 1'b0, "(Zero) MUL 8.8");
        `DO_TEST(n, 1'b0, "(Carry) MUL 8.8");
        `DO_TEST(sn, 1'b0, "(Signed Carry) MUL 8.8");

        #1
        $finish();
    end

endmodule
