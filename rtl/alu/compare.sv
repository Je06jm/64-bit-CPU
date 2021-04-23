`include "rtl/types.svh"

import types::*;

module ICompare(
    input ulong_t a, b,

    output logic zero, negitive
);
    ulong_t result;

    // Sign extend / Zero extend
    always @* begin
        result <= a - b;

        zero <= result == 0;
        negitive <= result[63];
    end

endmodule
