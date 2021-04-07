`include "types.svh"
`include "fpu/float.svh"

import types::*;
import floats::*;

module normalize(
    input denormalized_t fltIn,
    input floatType_t fltType,
    output floatValue_t fltOut,
    output logic inexact
);

    integer i;

    logic found;
    always @* begin
        found = 0;

        case (fltType)

            HALF: begin

                for (i = 0; i < 64; i = i + 1) begin
                    if (!found & fltIn.number[63-i]) begin
                        
                    end
                end  

            end
            SINGLE: begin

            end
            DOUBLE: begin

            end

        endcase
    end

endmodule
