`include "types.svh"
`include "instructions.svh"

import types::*;
import instructions::*;

module compare(
    input instruction_t instr,
    output logic n, z,
    output logic sn
);

    always @* begin
        n <= 0;
        z <= 0;

        sn <= 0;
        case (instr.opcode.byte)
            CMP: begin
                n <= instr.arg0.ulong < instr.arg1.ulong;
                z <= instr.arg0.ulong == instr.arg1.ulong;

                sn <= instr.arg0.long < instr.arg1.long;
            end
        endcase
    end

endmodule
