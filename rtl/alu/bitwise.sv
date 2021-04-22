`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module bitwise(
    input instruction_t instr,
    input logic i_carry,
    output long_t result,
    output logic o_carry
);

    logic[8:0] byteBitsInCarry = {i_carry, instr.arg0[7:0]};
    logic[16:0] shortBitsInCarry = {i_carry, instr.arg0[15:0]};
    logic[32:0] intBitsInCarry = {i_carry, instr.arg0[31:0]};
    logic[64:0] longBitsInCarry = {i_carry, instr.arg0};

    integer i;
    always @* begin
        {o_carry, result} <= {1'b0, 64'b0};
        case (instr.opcode)
            AND: result <= instr.arg0 & instr.arg1;
            OR: result <= instr.arg0 & instr.arg1;
            XOR: result <= instr.arg0 ^ instr.arg1;
            NOT: result <= ~instr.arg0;

            ROLR: begin
                if (instr.flags & `USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BITS_8:
                            {o_carry, result[7:0]} <=
                                byteBitsInCarry >> (instr.arg1 % 8) |
                                byteBitsInCarry << (8 - (instr.arg1 % 8));
                        BITS_16:
                            {o_carry, result[15:0]} <=
                                shortBitsInCarry >> (instr.arg1 % 16) |
                                shortBitsInCarry << (16 - (instr.arg1 % 16));
                        BITS_32:
                            {o_carry, result[31:0]} <=
                                intBitsInCarry >> (instr.arg1 % 32) |
                                intBitsInCarry << (32 - (instr.arg1 % 32));
                        BITS_64:
                            {o_carry, result} <=
                                longBitsInCarry >> (instr.arg1 % 64) |
                                longBitsInCarry << (64 - (instr.arg1 % 64));
                    endcase
                end else begin
                    case (instr.argSize0)
                        BITS_8:
                            result[7:0] <=
                                instr.arg0[7:0] >> (instr.arg1 % 8) |
                                instr.arg0[7:0] << (8 - (instr.arg1 % 8));
                        BITS_16:
                            result[15:0] <=
                                instr.arg0[15:0] >> (instr.arg1 % 16) |
                                instr.arg0[15:0] << (16 - (instr.arg1 % 16));
                        BITS_32:
                            result[31:0] <=
                                instr.arg0[31:0] >> (instr.arg1 % 32) |
                                instr.arg0[31:0] << (32 - (instr.arg1 % 32));
                        BITS_64:
                            result <=
                                instr.arg0 >> (instr.arg1 % 64) |
                                instr.arg0 << (64 - (instr.arg1 % 64));
                    endcase
                end
            end
            ROLL: begin
                if (instr.flags & `USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BITS_8:
                            {o_carry, result[7:0]} <=
                                byteBitsInCarry << (instr.arg1 % 8) |
                                byteBitsInCarry >> (8 - (instr.arg1 % 8));
                        BITS_16:
                            {o_carry, result[15:0]} <=
                                shortBitsInCarry << (instr.arg1 % 16) |
                                shortBitsInCarry >> (16 - (instr.arg1 % 16));
                        BITS_32:
                            {o_carry, result[31:0]} <=
                                intBitsInCarry << (instr.arg1 % 32) |
                                intBitsInCarry >> (32 - (instr.arg1 % 32));
                        BITS_64:
                            {o_carry, result} <=
                                longBitsInCarry << (instr.arg1 % 64) |
                                longBitsInCarry >> (64 - (instr.arg1 % 64));
                    endcase
                end else begin
                    case (instr.argSize0)
                        BITS_8:
                            result[7:0] <=
                                instr.arg0[7:0] << (instr.arg1 % 8) |
                                instr.arg0[7:0] >> (8 - (instr.arg1 % 8));
                        BITS_16:
                            result[15:0] <=
                                instr.arg0[15:0] << (instr.arg1 % 16) |
                                instr.arg0[15:0] >> (16 - (instr.arg1 % 16));
                        BITS_32:
                            result[31:0] <=
                                instr.arg0[31:0] << (instr.arg1 % 32) |
                                instr.arg0[31:0] >> (32 - (instr.arg1 % 32));
                        BITS_64:
                            result <=
                                instr.arg0 << (instr.arg1 % 64) |
                                instr.arg0 >> (64 - (instr.arg1 % 64));
                    endcase
                end
            end
            SHIFTR: begin
                if (instr.flags & `USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BITS_8:
                            {o_carry, result} <= byteBitsInCarry >> instr.arg1;
                        BITS_16:
                            {o_carry, result} <= shortBitsInCarry >> instr.arg1;
                        BITS_32:
                            {o_carry, result} <= intBitsInCarry >> instr.arg1;
                        BITS_64:
                            {o_carry, result} <= longBitsInCarry >> instr.arg1;
                    endcase
                end else begin
                    case (instr.argSize0)
                        BITS_8:
                            result <= instr.arg0[7:0] >> instr.arg1;
                        BITS_16:
                            result <= instr.arg0[15:0] >> instr.arg1;
                        BITS_32:
                            result <= instr.arg0[31:0] >> instr.arg1;
                        BITS_64:
                            result <= instr.arg0 >> instr.arg1;
                    endcase
                end
            end
            SHIFTL: begin
                if (instr.flags & `USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BITS_8:
                            {o_carry, result[7:0]} <= byteBitsInCarry << instr.arg1;
                        BITS_16:
                            {o_carry, result[15:0]} <= shortBitsInCarry << instr.arg1;
                        BITS_32:
                            {o_carry, result[31:0]} <= intBitsInCarry << instr.arg1;
                        BITS_64:
                            {o_carry, result} <= longBitsInCarry << instr.arg1;
                    endcase
                end else begin
                    case (instr.argSize0)
                        BITS_8:
                            result[7:0] <= instr.arg0[7:0] << instr.arg1;
                        BITS_16:
                            result[15:0] <= instr.arg0[15:0] << instr.arg1;
                        BITS_32:
                            result[31:0] <= instr.arg0[31:0] << instr.arg1;
                        BITS_64:
                            result <= instr.arg0 << instr.arg1;
                    endcase
                end
            end
            FLIP: begin
                case (instr.argSize0)
                    BITS_8: begin
                        result <= {
                            instr.arg0[7],
                            instr.arg0[6],
                            instr.arg0[5],
                            instr.arg0[4],
                            instr.arg0[3],
                            instr.arg0[2],
                            instr.arg0[1],
                            instr.arg0[0]
                        };
                    end
                    BITS_16: begin
                        result <= {
                            instr.arg0[15],
                            instr.arg0[14],
                            instr.arg0[13],
                            instr.arg0[12],
                            instr.arg0[11],
                            instr.arg0[10],
                            instr.arg0[9],
                            instr.arg0[8],
                            instr.arg0[7],
                            instr.arg0[6],
                            instr.arg0[5],
                            instr.arg0[4],
                            instr.arg0[3],
                            instr.arg0[2],
                            instr.arg0[1],
                            instr.arg0[0]
                        };
                    end
                    BITS_32: begin
                        result <= {
                            instr.arg0[31],
                            instr.arg0[30],
                            instr.arg0[29],
                            instr.arg0[28],
                            instr.arg0[27],
                            instr.arg0[26],
                            instr.arg0[25],
                            instr.arg0[24],
                            instr.arg0[23],
                            instr.arg0[22],
                            instr.arg0[21],
                            instr.arg0[20],
                            instr.arg0[19],
                            instr.arg0[18],
                            instr.arg0[17],
                            instr.arg0[16],
                            instr.arg0[15],
                            instr.arg0[14],
                            instr.arg0[13],
                            instr.arg0[12],
                            instr.arg0[11],
                            instr.arg0[10],
                            instr.arg0[9],
                            instr.arg0[8],
                            instr.arg0[7],
                            instr.arg0[6],
                            instr.arg0[5],
                            instr.arg0[4],
                            instr.arg0[3],
                            instr.arg0[2],
                            instr.arg0[1],
                            instr.arg0[0]
                        };
                    end
                    BITS_64: begin
                        result <= {
                            instr.arg0[63],
                            instr.arg0[62],
                            instr.arg0[61],
                            instr.arg0[60],
                            instr.arg0[59],
                            instr.arg0[58],
                            instr.arg0[57],
                            instr.arg0[56],
                            instr.arg0[55],
                            instr.arg0[54],
                            instr.arg0[53],
                            instr.arg0[52],
                            instr.arg0[51],
                            instr.arg0[50],
                            instr.arg0[49],
                            instr.arg0[48],
                            instr.arg0[47],
                            instr.arg0[46],
                            instr.arg0[45],
                            instr.arg0[44],
                            instr.arg0[43],
                            instr.arg0[42],
                            instr.arg0[41],
                            instr.arg0[40],
                            instr.arg0[39],
                            instr.arg0[38],
                            instr.arg0[37],
                            instr.arg0[36],
                            instr.arg0[35],
                            instr.arg0[34],
                            instr.arg0[33],
                            instr.arg0[32],
                            instr.arg0[31],
                            instr.arg0[30],
                            instr.arg0[29],
                            instr.arg0[28],
                            instr.arg0[27],
                            instr.arg0[26],
                            instr.arg0[25],
                            instr.arg0[24],
                            instr.arg0[23],
                            instr.arg0[22],
                            instr.arg0[21],
                            instr.arg0[20],
                            instr.arg0[19],
                            instr.arg0[18],
                            instr.arg0[17],
                            instr.arg0[16],
                            instr.arg0[15],
                            instr.arg0[14],
                            instr.arg0[13],
                            instr.arg0[12],
                            instr.arg0[11],
                            instr.arg0[10],
                            instr.arg0[9],
                            instr.arg0[8],
                            instr.arg0[7],
                            instr.arg0[6],
                            instr.arg0[5],
                            instr.arg0[4],
                            instr.arg0[3],
                            instr.arg0[2],
                            instr.arg0[1],
                            instr.arg0[0]
                        };
                    end
                endcase
            end
        endcase
    end
    

endmodule
