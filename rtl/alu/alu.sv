`include "rtl/defines.svh"

import defines::*;

module alu(
    input opcode_t op,
    input logic in_carry,
    input quad_t in_a, in_b,
    output quad_t result,
    output logic out_carry, out_zero, out_negitive,
    output logic cpu_exception
);

    bquad_t arith_result;

    arithmetic arith(
        op,
        in_a, in_b,
        arith_result
    );

    bquad_t bit_result;

    bitwise bits(
        op,
        in_carry,
        in_a, in_b,
        bit_result
    );

    bquad_t temp_result = arith_result | bit_result;

    assign out_carry = temp_result[64];
    assign out_zero = temp_result[63:0] == 0;
    assign out_negitive = temp_result[63];

    assign div_0 = (op == DIV || op == ADIV || op == MOD || op == AMOD) && (in_b == 0);

    assign cpu_exception = div_0 ? DIVIDE_BY_ZERO : NONE;

    assign result = div_0 ? 64'b0 : temp_result[63:0];

endmodule
