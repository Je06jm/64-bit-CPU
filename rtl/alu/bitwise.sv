`include "types.svh"
`include "instructions.svh"

import types::*;
import instructions::*;

module bitwise(
    input instruction_t instr,
    input logic i_carry,
    output long_t result,
    output logic o_carry
);

    logic[8:0] byteBitsInCarry = {i_carry, instr.arg0.ubyte};
    logic[16:0] shortBitsInCarry = {i_carry, instr.arg0.ushort};
    logic[32:0] intBitsInCarry = {i_carry, instr.arg0.uint};
    logic[64:0] longBitsInCarry = {i_carry, instr.arg0.ulong};

    integer i;
    always @* begin
        {o_carry, result} <= {1'b0, 64'b0};
        case (instr.opcode.byte)
            AND: result <= instr.arg0.ulong & instr.arg1.ulong;
            OR: result <= instr.arg0.ulong & instr.arg1.ulong;
            XOR: result <= instr.arg0.ulong ^ instr.arg1.ulong;
            NOT: result <= ~instr.arg0.ulong;

            ROLR: begin
                if (instr.flags & USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BYTES_8:
                            {o_carry, result[7:0]} <=
                                byteBitsInCarry >> (instr.arg1.ulong % 8) |
                                byteBitsInCarry << (8 - (instr.arg1.ulong % 8));
                        BYTES_16:
                            {o_carry, result[15:0]} <=
                                shortBitsInCarry >> (instr.arg1.ulong % 16) |
                                shortBitsInCarry << (16 - (instr.arg1.ulong % 16));
                        BYTES_32:
                            {o_carry, result[31:0]} <=
                                intBitsInCarry >> (instr.arg1.ulong % 32) |
                                intBitsInCarry << (32 - (instr.arg1.ulong % 32));
                        BYTES_64:
                            {o_carry, result} <=
                                longBitsInCarry >> (instr.arg1.ulong % 64) |
                                longBitsInCarry << (64 - (instr.arg1.ulong % 64));
                    endcase
                end else begin
                    case (instr.argSize0)
                        BYTES_8:
                            result[7:0] <=
                                instr.arg0.ubyte >> (instr.arg1.ulong % 8) |
                                instr.arg0.ubyte << (8 - (instr.arg1.ulong % 8));
                        BYTES_16:
                            result[15:0] <=
                                instr.arg0.ushort >> (instr.arg1.ulong % 16) |
                                instr.arg0.ushort << (16 - (instr.arg1.ulong % 16));
                        BYTES_32:
                            result[31:0] <=
                                instr.arg0.uint >> (instr.arg1.ulong % 32) |
                                instr.arg0.uint << (32 - (instr.arg1.ulong % 32));
                        BYTES_64:
                            result <=
                                instr.arg0.ulong >> (instr.arg1.ulong % 64) |
                                instr.arg0.ulong << (64 - (instr.arg1.ulong % 64));
                    endcase
                end
            end
            ROLL: begin
                if (instr.flags & USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BYTES_8:
                            {o_carry, result[7:0]} <=
                                byteBitsInCarry << (instr.arg1.ulong % 8) |
                                byteBitsInCarry >> (8 - (instr.arg1.ulong % 8));
                        BYTES_16:
                            {o_carry, result[15:0]} <=
                                shortBitsInCarry << (instr.arg1.ulong % 16) |
                                shortBitsInCarry >> (16 - (instr.arg1.ulong % 16));
                        BYTES_32:
                            {o_carry, result[31:0]} <=
                                intBitsInCarry << (instr.arg1.ulong % 32) |
                                intBitsInCarry >> (32 - (instr.arg1.ulong % 32));
                        BYTES_64:
                            {o_carry, result} <=
                                longBitsInCarry << (instr.arg1.ulong % 64) |
                                longBitsInCarry >> (64 - (instr.arg1.ulong % 64));
                    endcase
                end else begin
                    case (instr.argSize0)
                        BYTES_8:
                            result[7:0] <=
                                instr.arg0.ubyte << (instr.arg1.ulong % 8) |
                                instr.arg0.ubyte >> (8 - (instr.arg1.ulong % 8));
                        BYTES_16:
                            result[15:0] <=
                                instr.arg0.ushort << (instr.arg1.ulong % 16) |
                                instr.arg0.ushort >> (16 - (instr.arg1.ulong % 16));
                        BYTES_32:
                            result[31:0] <=
                                instr.arg0.uint << (instr.arg1.ulong % 32) |
                                instr.arg0.uint >> (32 - (instr.arg1.ulong % 32));
                        BYTES_64:
                            result <=
                                instr.arg0.ulong << (instr.arg1.ulong % 64) |
                                instr.arg0.ulong >> (64 - (instr.arg1.ulong % 64));
                    endcase
                end
            end
            SHIFTR: begin
                if (instr.flags & USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BYTES_8:
                            {o_carry, result} <= byteBitsInCarry >> instr.arg1.ulong;
                        BYTES_16:
                            {o_carry, result} <= shortBitsInCarry >> instr.arg1.ulong;
                        BYTES_32:
                            {o_carry, result} <= intBitsInCarry >> instr.arg1.ulong;
                        BYTES_64:
                            {o_carry, result} <= longBitsInCarry >> instr.arg1.ulong;
                    endcase
                end else begin
                    case (instr.argSize0)
                        BYTES_8:
                            result <= instr.arg0.ubyte >> instr.arg1.ulong;
                        BYTES_16:
                            result <= instr.arg0.ushort >> instr.arg1.ulong;
                        BYTES_32:
                            result <= instr.arg0.uint >> instr.arg1.ulong;
                        BYTES_64:
                            result <= instr.arg0.ulong >> instr.arg1.ulong;
                    endcase
                end
            end
            SHIFTL: begin
                if (instr.flags & USE_CARRY_BIT) begin
                    case (instr.argSize0)
                        BYTES_8:
                            {o_carry, result[7:0]} <= byteBitsInCarry << instr.arg1.ulong;
                        BYTES_16:
                            {o_carry, result[15:0]} <= shortBitsInCarry << instr.arg1.ulong;
                        BYTES_32:
                            {o_carry, result[31:0]} <= intBitsInCarry << instr.arg1.ulong;
                        BYTES_64:
                            {o_carry, result} <= longBitsInCarry << instr.arg1.ulong;
                    endcase
                end else begin
                    case (instr.argSize0)
                        BYTES_8:
                            result[7:0] <= instr.arg0.ubyte << instr.arg1.ulong;
                        BYTES_16:
                            result[15:0] <= instr.arg0.ushort << instr.arg1.ulong;
                        BYTES_32:
                            result[31:0] <= instr.arg0.uint << instr.arg1.ulong;
                        BYTES_64:
                            result <= instr.arg0.ulong << instr.arg1.ulong;
                    endcase
                end
            end
            FLIP: begin
                case (instr.argSize0)
                    BYTES_8: begin
                        result <= 0;

                        for (i = 0; i < 8; i = i + 1)
                            result[i] <= instr.arg0.ulong[7-i];
                    end
                    BYTES_16: begin
                        result <= 0;

                        for (i = 0; i < 16; i = i + 1)
                            result[i] <= instr.arg0.ulong[15-i];
                    end
                    BYTES_32: begin
                        result <= 0;

                        for (i = 0; i < 32; i = i + 1)
                            result[i] <= instr.arg0.ulong[31-i];
                    end
                    BYTES_64: begin
                        result <= 0;

                        for (i = 0; i < 64; i = i + 1)
                            result[i] <= instr.arg0.ulong[63-i];
                    end
                endcase
            end
        endcase
    end
    

endmodule
