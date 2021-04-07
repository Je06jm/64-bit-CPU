`ifndef CPU_FLOAT
`define CPU_FLOAT

`include "types.svh"

import types::*;

package floats

typedef struct packed {
    ulong_t number;
    float_t float;
} denormalized_t;

endpackage

`endif
