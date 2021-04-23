`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module IValue(
    input ulong_t in,
    output ulong_t out,

    input sizeFlags_t size,
    input logic signExtend
);

    always @* begin
        case (size)
            BITS_8: begin
                if (signExtend)
                    out <= {{56{in[7]}}, in[7:0]};
                else
                    out <= {56'b0, in[7:0]};
            end
            BITS_16: begin
                if (signExtend)
                    out <= {{48{in[15]}}, in[15:0]};
                else
                    out <= {48'b0, in[15:0]};
            end
            BITS_32: begin
                if (signExtend)
                    out <= {{32{in[31]}}, in[31:0]};
                else
                    out <= {32'b0, in[31:0]};
            end
            BITS_64:
                out <= in;
        endcase
    end

endmodule
