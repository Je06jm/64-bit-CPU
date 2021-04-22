`include "rtl/types.svh"
`include "rtl/instructions.svh"
`include "rtl/exceptions.svh"

import types::*;
import instructions::*;
import exceptions::*;

module ALU(
    input instruction_t instr,
    input logic i_carry,
    output long_t result,
    output logic z, n, c, sn
);

    long_t arithResult;
    logic arithCarry;

    arithmetic arith(
        instr,
        arithResult,
        arithCarry
    );

    long_t bitwResult;
    logic bitwCarry;

    bitwise bitw(
        instr,
        i_carry,
        bitwResult,
        bitwCarry
    );

    logic compN, compZ, compSN;

    compare comp(
        instr,
        compN, compZ, compSN
    );

    always @* begin
        result <= arithResult | bitwResult;
        z <= compZ;
        n <= compN;
        c <= arithCarry | bitwCarry;
        sn <= compSN;
    end

endmodule
