`ifndef CPU_REQUEST
`define CPU_REQUEST

`include "rtl/types.svh"

import types::*;

package requests;

typedef struct packed {
    ulong_t addr;
    ulong_t data;
    logic isWrite;
    logic isPrivaliged;
    logic isValid;
} cpuMemRequest_t;

typedef struct packed {
    ulong_t data;
    logic isValid;
} cpuMemResult_t;

endpackage

`endif
