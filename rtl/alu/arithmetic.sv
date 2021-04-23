`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module Arithmetic(
    input opcode_t op,
    
    input logic carryIn,

    input ulong_t a, b,
    output ulong_t result,

    output logic divByZero,

    output logic zero, carry, negitive
);

    long_t sa, sb;

    always @* begin
        sa <= a;
        sb <= b;

        zero <= result == 0;
        negitive <= result[63];

        divByZero <=
            ((op == SDIV) || (op == UDIV) || (op == SMOD) || (op == UMOD)) &&
            b == 0;

        case (op)
            ADD: {carry, result} <= a + b + carryIn;
            SUB: {carry, result} <= a - b - carryIn;
            MUL: {carry, result} <= a * b;

            UDIV: {carry, result} <= a / b;
            UMOD: {carry, result} <= a % b;

            SDIV: {carry, result} <= sa / sb;
            SMOD: {carry, result} <= sa % sb;

            INC: {carry, result} <= a + 1;
            DEC: {carry, result} <= a - 1;
        endcase
    end

endmodule
