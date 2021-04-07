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
            HALF: fltOut <= {{1'b1, fltIn.value.half.fraction, 53'b0}, fltIn};
            SINGLE: fltOut <= {{1'b1, fltIn.value.single.fraction, 41'b0}, fltIn};
            DOUBLE: fltOut <= {{1'b1, fltIn.value.double.fraction, 11'b0}, fltIn};
        endcase
    end

endmodule
