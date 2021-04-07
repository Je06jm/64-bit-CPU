`include "types.svh"
`include "instructions.svh"

import types::*;
import instructions::*;

module arithmetic(
    input instruction_t instr,
    output long_t result,
    output logic carry
);

    always @* begin
        {carry, result} <= {1'b0, 64'b0};

        case (instr.argSize0)
            BYTES_8: begin
                case (instr.opcode.byte)
                    ADD: {carry, result[7:0]} <= instr.arg0.ubyte + instr.arg1.ubyte;
                    SUB: {carry, result[7:0]} <= instr.arg0.ubyte - instr.arg1.ubyte;
                    MUL: {carry, result[7:0]} <= instr.arg0.ubyte * instr.arg1.ubyte;
                    DIV: {carry, result[7:0]} <= instr.arg0.ubyte / instr.arg0.ubyte;
                    MOD: {carry, result[7:0]} <= instr.arg0.ubyte % instr.arg0.ubyte;

                    SADD: {carry, result[7:0]} <= instr.arg0.byte + instr.arg1.byte;
                    SSUB: {carry, result[7:0]} <= instr.arg0.byte - instr.arg1.byte;
                    SMUL: {carry, result[7:0]} <= instr.arg0.byte * instr.arg1.byte;
                    SDIV: {carry, result[7:0]} <= instr.arg0.byte / instr.arg0.byte;
                    SMOD: {carry, result[7:0]} <= instr.arg0.byte % instr.arg0.byte;

                    INC: {carry, result[7:0]} <= instr.arg0.ubyte + 1;
                    DEC: {carry, result[7:0]} <= instr.arg0.ubyte - 1;
                endcase
            end
            BYTES_16: begin
                case (instr.opcode.byte)
                    ADD: {carry, result[15:0]} <= instr.arg0.ushort + instr.arg1.ushort;
                    SUB: {carry, result[15:0]} <= instr.arg0.ushort - instr.arg1.ushort;
                    MUL: {carry, result[15:0]} <= instr.arg0.ushort * instr.arg1.ushort;
                    DIV: {carry, result[15:0]} <= instr.arg0.ushort / instr.arg0.ushort;
                    MOD: {carry, result[15:0]} <= instr.arg0.ushort % instr.arg0.ushort;

                    SADD: {carry, result[15:0]} <= instr.arg0.short + instr.arg1.short;
                    SSUB: {carry, result[15:0]} <= instr.arg0.short - instr.arg1.short;
                    SMUL: {carry, result[15:0]} <= instr.arg0.short * instr.arg1.short;
                    SDIV: {carry, result[15:0]} <= instr.arg0.short / instr.arg0.short;
                    SMOD: {carry, result[15:0]} <= instr.arg0.short % instr.arg0.short;

                    INC: {carry, result[15:0]} <= instr.arg0.ushort + 1;
                    DEC: {carry, result[15:0]} <= instr.arg0.ushort - 1;
                endcase
            end
            BYTES_32: begin
                case (instr.opcode.byte)
                    ADD: {carry, result[31:0]} <= instr.arg0.uint + instr.arg1.uint;
                    SUB: {carry, result[31:0]} <= instr.arg0.uint - instr.arg1.uint;
                    MUL: {carry, result[31:0]} <= instr.arg0.uint * instr.arg1.uint;
                    DIV: {carry, result[31:0]} <= instr.arg0.uint / instr.arg0.uint;
                    MOD: {carry, result[31:0]} <= instr.arg0.uint % instr.arg0.uint;

                    SADD: {carry, result[31:0]} <= instr.arg0.int + instr.arg1.int;
                    SSUB: {carry, result[31:0]} <= instr.arg0.int - instr.arg1.int;
                    SMUL: {carry, result[31:0]} <= instr.arg0.int * instr.arg1.int;
                    SDIV: {carry, result[31:0]} <= instr.arg0.int / instr.arg0.int;
                    SMOD: {carry, result[31:0]} <= instr.arg0.int % instr.arg0.int;

                    INC: {carry, result[31:0]} <= instr.arg0.uint + 1;
                    DEC: {carry, result[31:0]} <= instr.arg0.uint - 1;
                endcase
            end
            BYTES_64: begin
                case (instr.opcode.byte)
                    ADD: {carry, result} <= instr.arg0.ulong + instr.arg1.ulong;
                    SUB: {carry, result} <= instr.arg0.ulong - instr.arg1.ulong;
                    MUL: {carry, result} <= instr.arg0.ulong * instr.arg1.ulong;
                    DIV: {carry, result} <= instr.arg0.ulong / instr.arg0.ulong;
                    MOD: {carry, result} <= instr.arg0.ulong % instr.arg0.ulong;

                    SADD: {carry, result} <= instr.arg0.long + instr.arg1.long;
                    SSUB: {carry, result} <= instr.arg0.long - instr.arg1.long;
                    SMUL: {carry, result} <= instr.arg0.long * instr.arg1.long;
                    SDIV: {carry, result} <= instr.arg0.long / instr.arg0.long;
                    SMOD: {carry, result} <= instr.arg0.long % instr.arg0.long;

                    INC: {carry, result} <= instr.arg0.ulong + 1;
                    DEC: {carry, result} <= instr.arg0.ulong - 1;
                endcase
            end
        endcase
    end

endmodule
