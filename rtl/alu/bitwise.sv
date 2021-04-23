`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module RollRight(
    input sizeFlags_t size,
    input logic carryIn,
    input logic useCarry,
    input logic storeLSB,

    input ulong_t a,
    input ubyte_t b,
    output ulong_t result,

    output logic carry
);

    ubyte_t rol8 = b % 8;
    ubyte_t rol8c = b % 9;
    ubyte_t rol16 = b % 16;
    ubyte_t rol16c = b % 17;
    ubyte_t rol32 = b % 32;
    ubyte_t rol32c = b % 33;
    ubyte_t rol64 = b % 64;
    ubyte_t rol64c = b % 65;

    always @* begin
        if (storeLSB && !useCarry)
            carry <= result[0];

        case (size)
            BITS_8: begin
                if (useCarry)
                    {carry, result} <=
                        {carryIn, a[7:0]} >> rol8c |
                        {carryIn, a[7:0]} << (9 - rol8c);
                    
                else begin
                    result <=
                        a[7:0] >> rol8 |
                        a[7:0] << (8 - rol8);

                    if (!storeLSB)
                        carry <= result[7];

                end
            end
            BITS_16: begin
                if (useCarry)
                    {carry, result} <=
                        {carryIn, a[15:0]} >> rol16c |
                        {carryIn, a[15:0]} << (17 - rol16c);
                
                else begin
                    result <=
                        a[15:0] >> rol16 |
                        a[15:0] << (16 - rol16);
                    
                    if (!storeLSB)
                        carry <= result[15];
                
                end
            end
            BITS_32: begin
                if (useCarry)
                    {carry, result} <=
                        {carryIn, a[31:0]} >> rol32c |
                        {carryIn, a[31:0]} << (33 - rol32c);
                
                else begin
                    result <=
                        a[31:0] >> rol32 |
                        a[31:0] << (32 - rol32c);

                    if (!storeLSB)
                        carry <= result[31];

                end
            end
            BITS_64: begin
                if (useCarry)
                    {carry, result} <=
                        {carryIn, a} >> rol64c |
                        {carryIn, a} << (65 - rol64c);

                else begin
                    result <=
                        a >> rol64 |
                        a << (64 - rol64);
                    
                    if (!storeLSB)
                        carry <= result[63];

                end
            end
            default: {carry, result} <= {1'b0, 64'b0};
        endcase
    end

endmodule

// 1000 -> 0100 ROLL RIGHT 1
// 1000 -> 0100 ROLL LEFT 3

// (1) 1000 -> (0) 1100 ROLLC RIGHT 1
// (1) 1000 -> (0) 1100 ROLLC LEFT 4


module Bitwise(
    input opcode_t op,

    input sizeFlags_t size,
    input logic carryIn,
    input logic useCarry,

    input ulong_t a, b,
    output ulong_t result,

    output logic zero, carry, negitive
);

    ubyte_t rol8 = 8 - b;
    ubyte_t rol8c = 9 - b;
    ubyte_t rol16 = 16 - b;
    ubyte_t rol16c = 17 - b;
    ubyte_t rol32 = 32 - b;
    ubyte_t rol32c = 33 - b;
    ubyte_t rol64 = 64 - b;
    ubyte_t rol64c = 65 - b;

    logic storeLSB;
    ulong_t rollrResult;
    logic rollrCarry;
    ubyte_t roll;

    RollRight rollr(
        size,
        carryIn,
        useCarry,
        storeLSB,
        a,
        roll,
        rollrResult,
        rollrCarry
    );

    always @* begin
        case (op)
            AND: {carry, result} <= {1'b0, a & b};
            OR: {carry, result} <= {1'b0, a | b};
            XOR: {carry, result} <= {1'b0, a ^ b};
            NOT: {carry, result} <= {1'b0, ~a};
            ROLR: begin
                storeLSB <= 1;
                roll <= b;
                {carry, result} <= {rollrCarry, rollrResult};
            end
            ROLL: begin
                storeLSB <= 0;
                case (size)
                    BITS_8: begin
                        if (useCarry)
                            roll <= rol8c;
                        else 
                            roll <= rol8;
                    end
                    BITS_16: begin
                        if (useCarry)
                            roll <= rol16c;
                        else
                            roll <= rol16;
                    end
                    BITS_32: begin
                        if (useCarry)
                            roll <= rol32c;
                        else
                            roll <= rol32;
                    end
                    BITS_64: begin
                        if (useCarry)
                            roll <= rol64c;
                        else
                            roll <= rol64;
                    end
                endcase
                {carry, result} <= {rollrCarry, rollrResult};
            end
            SHIFTR: begin
                if (useCarry)
                    {carry, result} <= {carryIn, a} >> b;
                else
                    {carry, result} <= a >> b;
            end
            SHIFTL: begin
                if (useCarry)
                    {carry, result} <= {carryIn, a} << b;
                else
                    {carry, result} <= a << b;
            end
            FLIP: begin
                case (size)
                    BITS_8: {carry, result} <= {
                        1'b0,
                        56'b0,
                        a[0],
                        a[1],
                        a[2],
                        a[3],
                        a[4],
                        a[5],
                        a[6],
                        a[7]
                    };
                    BITS_16: {carry, result} <= {
                        1'b0,
                        48'b0,
                        a[0],
                        a[1],
                        a[2],
                        a[3],
                        a[4],
                        a[5],
                        a[6],
                        a[7],
                        a[8],
                        a[9],
                        a[10],
                        a[11],
                        a[12],
                        a[13],
                        a[14],
                        a[15]
                    };
                    BITS_32: {carry, result} <= {
                        1'b0,
                        32'b0,
                        a[0],
                        a[1],
                        a[2],
                        a[3],
                        a[4],
                        a[5],
                        a[6],
                        a[7],
                        a[8],
                        a[9],
                        a[10],
                        a[11],
                        a[12],
                        a[13],
                        a[14],
                        a[15],
                        a[16],
                        a[17],
                        a[18],
                        a[19],
                        a[20],
                        a[21],
                        a[22],
                        a[23],
                        a[24],
                        a[25],
                        a[26],
                        a[27],
                        a[28],
                        a[29],
                        a[30],
                        a[31]
                    };
                    BITS_64: {carry, result} <= {
                        1'b0,
                        a[0],
                        a[1],
                        a[2],
                        a[3],
                        a[4],
                        a[5],
                        a[6],
                        a[7],
                        a[8],
                        a[9],
                        a[10],
                        a[11],
                        a[12],
                        a[13],
                        a[14],
                        a[15],
                        a[16],
                        a[17],
                        a[18],
                        a[19],
                        a[20],
                        a[21],
                        a[22],
                        a[23],
                        a[24],
                        a[25],
                        a[26],
                        a[27],
                        a[28],
                        a[29],
                        a[30],
                        a[31],
                        a[32],
                        a[33],
                        a[34],
                        a[35],
                        a[36],
                        a[37],
                        a[38],
                        a[39],
                        a[40],
                        a[41],
                        a[42],
                        a[43],
                        a[44],
                        a[45],
                        a[46],
                        a[47],
                        a[48],
                        a[49],
                        a[50],
                        a[51],
                        a[52],
                        a[53],
                        a[54],
                        a[55],
                        a[56],
                        a[57],
                        a[58],
                        a[59],
                        a[60],
                        a[61],
                        a[62],
                        a[63]
                    };
                endcase
            end

        endcase
    end

endmodule
