`include "rtl/defines.svh"

import defines::*;

module bitwise(
    input opcode_t op,
    input logic carry,
    input quad_t in_a, in_b,
    output bquad_t result
);

    always @* begin
        case (op)
            AND: result <= in_a & in_b;
            OR: result <= in_a | in_b;
            XOR: result <= in_a ^ in_b;
            NOT: result <= ~in_a;
            SHIFTR: result <= in_a >> in_b;
            SHIFTL: result <= in_a << in_b;
            SHIFTRC: result <= {carry, in_a >> in_b};
            SHIFTLC: result <= {in_a << in_b, carry};

            AAND: result <= in_a & in_b;
            AOR: result <= in_a | in_b;
            AXOR: result <= in_a ^ in_b;
            ANOT: result <= ~in_a;
            ASHIFTR: result <= in_a >> in_b;
            ASHIFTL: result <= in_a << in_b;
            ASHIFTRC: result <= {carry, in_a >> in_b};
            ASHIFTLC: result <= {in_a << in_b, carry};

            default: result <= 0;
        endcase
    end

endmodule
