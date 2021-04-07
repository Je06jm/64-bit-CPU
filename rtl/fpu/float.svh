`ifndef CPU_FLOAT
`define CPU_FLOAT

`include "types.svh"

import types::*;

package floats

typedef struct packed {
    logic sign;
    ushort_t exponent;
    ulong_t number;
} denormalized_t;

typedef struct packed {
    logic sign;
    ushort_t exponent;
    logic[127:0] number;
} denormalizedExt_t;

endpackage

`endif
