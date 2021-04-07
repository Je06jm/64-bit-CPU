`include "types.svh"
`include "fpu/float.svh"

import types::*;
import floats::*;

module denormalize(
    input float_t fltIn,
    output denormalized_t fltOut
);

    always @* begin
        fltOut <= 64'b0;

        case (fltInt.type)
            HALF: fltOut <= {
                flt.sign,
                {11'b0, flt.exponent},
                {1'b0, 1'b1, fltIn.value.half.fraction, 52'b0}
            };
            SINGLE: fltOut <= {
                flt.sign,
                {8'b0, flt.exponent},
                {1'b0, 1'b1, fltIn.value.single.fraction, 40'b0}
            };
            DOUBLE: fltOut <= {
                flt.sign,
                {5'b0, flt.exponent}
                {1'b0, 1'b1, fltIn.value.double.fraction, 10'b0}
            };
        endcase
    end

endmodule
