`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module arithmetic(
    input instruction_t instr,
    output long_t result,
    output logic carry
);
    byte_t byte0 = instr.arg0[7:0];
    short_t short0 = instr.arg0[15:0];
    int_t int0 = instr.arg0[31:0];
    long_t long0 = instr.arg0;

    byte_t byte1 = instr.arg1[7:0];
    short_t short1 = instr.arg1[15:0];
    int_t int1 = instr.arg1[31:0];
    long_t long1 = instr.arg1;

    always @* begin
        {carry, result} <= {1'b0, 64'b0};

        case (instr.argSize0)
            BITS_8: begin
                case (instr.opcode)
                    ADD: {carry, result[7:0]} <= instr.arg0[7:0] + instr.arg1[7:0];
                    SUB: {carry, result[7:0]} <= instr.arg0[7:0] - instr.arg1[7:0];
                    MUL: {carry, result[7:0]} <= instr.arg0[7:0] * instr.arg1[7:0];
                    DIV: {carry, result[7:0]} <= instr.arg0[7:0] / instr.arg0[7:0];
                    MOD: {carry, result[7:0]} <= instr.arg0[7:0] % instr.arg0[7:0];

                    SADD: {carry, result[7:0]} <= byte0 + byte1;
                    SSUB: {carry, result[7:0]} <= byte0 - byte1;
                    SMUL: {carry, result[7:0]} <= byte0 * byte1;
                    SDIV: {carry, result[7:0]} <= byte0 / byte0;
                    SMOD: {carry, result[7:0]} <= byte0 % byte0;

                    INC: {carry, result[7:0]} <= instr.arg0[7:0] + 1;
                    DEC: {carry, result[7:0]} <= instr.arg0[7:0] - 1;
                endcase
            end
            BITS_16: begin
                case (instr.opcode)
                    ADD: {carry, result[15:0]} <= instr.arg0[15:0] + instr.arg1.ushort;
                    SUB: {carry, result[15:0]} <= instr.arg0[15:0] - instr.arg1.ushort;
                    MUL: {carry, result[15:0]} <= instr.arg0[15:0] * instr.arg1.ushort;
                    DIV: {carry, result[15:0]} <= instr.arg0[15:0] / instr.arg0[15:0];
                    MOD: {carry, result[15:0]} <= instr.arg0[15:0] % instr.arg0[15:0];

                    SADD: {carry, result[15:0]} <= short0 + short1;
                    SSUB: {carry, result[15:0]} <= short0 - short1;
                    SMUL: {carry, result[15:0]} <= short0 * short1;
                    SDIV: {carry, result[15:0]} <= short0 / short0;
                    SMOD: {carry, result[15:0]} <= short0 % short0;

                    INC: {carry, result[15:0]} <= instr.arg0[15:0] + 1;
                    DEC: {carry, result[15:0]} <= instr.arg0[15:0] - 1;
                endcase
            end
            BITS_32: begin
                case (instr.opcode)
                    ADD: {carry, result[31:0]} <= instr.arg0[31:0] + instr.arg1[31:0];
                    SUB: {carry, result[31:0]} <= instr.arg0[31:0] - instr.arg1[31:0];
                    MUL: {carry, result[31:0]} <= instr.arg0[31:0] * instr.arg1[31:0];
                    DIV: {carry, result[31:0]} <= instr.arg0[31:0] / instr.arg0[31:0];
                    MOD: {carry, result[31:0]} <= instr.arg0[31:0] % instr.arg0[31:0];

                    SADD: {carry, result[31:0]} <= int0 + int1;
                    SSUB: {carry, result[31:0]} <= int0 - int1;
                    SMUL: {carry, result[31:0]} <= int0 * int1;
                    SDIV: {carry, result[31:0]} <= int0 / int0;
                    SMOD: {carry, result[31:0]} <= int0 % int0;

                    INC: {carry, result[31:0]} <= instr.arg0[31:0] + 1;
                    DEC: {carry, result[31:0]} <= instr.arg0[31:0] - 1;
                endcase
            end
            BITS_64: begin
                case (instr.opcode)
                    ADD: {carry, result} <= instr.arg0 + instr.arg1;
                    SUB: {carry, result} <= instr.arg0 - instr.arg1;
                    MUL: {carry, result} <= instr.arg0 * instr.arg1;
                    DIV: {carry, result} <= instr.arg0 / instr.arg0;
                    MOD: {carry, result} <= instr.arg0 % instr.arg0;

                    SADD: {carry, result} <= long0 + long1;
                    SSUB: {carry, result} <= long0 - long1;
                    SMUL: {carry, result} <= long0 * long1;
                    SDIV: {carry, result} <= long0 / long0;
                    SMOD: {carry, result} <= long0 % long0;

                    INC: {carry, result} <= instr.arg0 + 1;
                    DEC: {carry, result} <= instr.arg0 - 1;
                endcase
            end
        endcase
    end

endmodule
