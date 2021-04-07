`include "types.svh"
`include "fpu/float.svh"

import types::*;
import floats::*;

module match(
    input denormalized_t fltA, fltB,
    output denormalized_t outA, outB,
    output logic inexact
);

    logic aGreater = fltA.exponent > fltB.exponent;
    logic difference = aGreater ?
        fltA.exponent - fltB.exponent :
        fltB.exponent - fltA.exponent
    ;
    ulong_t number = aGreater ?
        fltB.number :
        fltA.number
    ;

    integer i;
    always @* begin
        inexact <= 0;

        for (i = 0; i < 64; i++) begin
            if (i >= 1)
                inexact <= inexact |
                    (((i - 1) > difference) &
                    number[63-i])
                ;
        end

        if (aGreater) begin
            fltA.exponent <= fltB.exponent;
            fltA.number <= fltA.number >> difference;

        end else begin
            fltB.exponent <= fltA.exponent;
            fltB.number <= fltB.number >> difference;

        end
    end

endmodule
