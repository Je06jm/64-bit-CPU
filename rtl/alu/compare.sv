`include "rtl/types.svh"
`include "rtl/instructions.svh"

import types::*;
import instructions::*;

module compare(
    input instruction_t instr,
    output logic n, z,
    output logic sn
);
    ulong_t ulong0, ulong1;
    long_t long0, long1;

    always @* begin
        long0 <= ulong0;
        long1 <= ulong1;

        case (instr.argSize0)
            BITS_8: ulong0 <= {{56{instr.arg0[7]}}, instr.arg0[7:0]};
            BITS_16: ulong0 <= {{48{instr.arg0[15]}}, instr.arg0[15:0]};
            BITS_32: ulong0 <= {{32{instr.arg0[31]}}, instr.arg0[31:0]};
            BITS_64: ulong0 <= instr.arg0;
        endcase

        case (instr.argSize1)
            BITS_8: ulong1 <= {{56{instr.arg1[7]}}, instr.arg1[7:0]};
            BITS_16: ulong1 <= {{48{instr.arg1[15]}}, instr.arg1[15:0]};
            BITS_32: ulong1 <= {{32{instr.arg1[31]}}, instr.arg1[31:0]};
            BITS_64: ulong1 <= instr.arg1;
        endcase

        n <= 0;
        z <= 0;

        sn <= 0;
        case (instr.opcode)
            CMP: begin
                n <= ulong0 < ulong1;
                z <= ulong0 == ulong1;

                sn <= long0 < long1;
            end
        endcase
    end

endmodule
