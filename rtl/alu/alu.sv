`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module ALU(
    input opcode_t op,
    input sizeFlags_t aSize, bSize,
    input logic aSignExtend, bSignExtend,
    input ulong_t a, b,
    input logic useCarry, carryIn,

    input sizeFlags_t resultSize,

    output ulong_t result,

    output logic divByZero,

    output logic zero, carry, negitive
);

    ulong_t aValue, bValue;

    IValue iValue0(a, aValue, aSize, aSignExtend);
    IValue iValue1(b, bValue, bSize, bSignExtend);

    ulong_t arithmeticResult;
    logic arithmeticDivByZero;
    logic arithmeticCarry;

    opcode_t arithmeticOp;
    logic arithmeticCarryIn;

    always @* begin
        // Convert CMP to SUB
        if (op == CMP)
            arithmeticOp <= SUB;
        else
            arithmeticOp <= op;

        if (useCarry)
            arithmeticCarryIn <= carryIn;
        else
            arithmeticCarryIn <= 0;
    end

    Arithmetic arithmetic(
        arithmeticOp,
        arithmeticCarryIn,
        aValue, bValue,
        arithmeticResult,
        arithmeticDivByZero,
        arithmeticCarry
    );

    ulong_t bitwiseResult;
    logic bitwiseCarry;

    Bitwise bitwise(
        op,
        resultSize,
        carryIn,
        useCarry,
        aValue, bValue,
        bitwiseResult,
        bitwiseCarry
    );

    ulong_t immResult;

    always @* begin
        case (resultSize)
            BITS_8: begin
                result <= {56'b0, immResult[7:0]};
                zero <= result[7:0] == 0;
                negitive <= result[7];
            end
            BITS_16: begin
                result <= {56'b0, immResult[15:0]};
                zero <= result[15:0] == 0;
                negitive <= result[15];
            end
            BITS_32: begin
                result <= {56'b0, immResult[31:0]};
                zero <= result[31:0] == 0;
                negitive <= result[31];
            end
            BITS_64: begin
                result <= immResult;
                zero <= result == 0;
                negitive <= result[63];
            end
        endcase
    end

    always @* begin
        if ((op <= DEC) || (op == CMP)) begin
            immResult <= arithmeticResult;
            divByZero <= arithmeticDivByZero;
            carry <= arithmeticCarry;

        end else if (op <= FLIP) begin
            immResult <= bitwiseResult;
            divByZero <= 0;
            carry <= bitwiseCarry;

        end else begin
            immResult <= 0;
            divByZero <= 0;
            carry <= 0;
            
        end
    end

endmodule
