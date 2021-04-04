`include "rtl/defines.svh"

import defines::*;

module arithmetic(
    input opcode_t op,
    input quad_t in_a, in_b,
    output bquad_t result
);

    always @* begin
        case (op)
            ADD: result <= in_a + in_b;
            SUB: result <= in_a - in_b;
            MUL: result <= in_a * in_b;
            DIV: result <= in_a / in_b;
            MOD: result <= in_a % in_b;

            AADD: result <= in_a + in_b;
            ASUB: result <= in_a - in_b;
            AMUL: result <= in_a * in_b;
            ADIV: result <= in_a / in_b;
            AMOD: result <= in_a % in_b;

            CMP: result <= in_a - in_b;

            default: result <= 0;
        endcase
    end

endmodule

