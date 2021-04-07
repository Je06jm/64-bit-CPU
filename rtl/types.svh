`ifndef CPU_TYPES
`define CPU_TYPES

package types;

typedef logic signed[7:0] byte_t;
typedef logic signed[15:0] short_t;
typedef logic signed[31:0] int_t;
typedef logic signed[63:0] long_t;

typedef logic unsigned[7:0] ubyte_t;
typedef logic unsigned[15:0] ushort_t;
typedef logic unsigned[31:0] uint_t;
typedef logic unsigned[63:0] ulong_t;

typedef struct packed {
    logic sign;
    logic[4:0] exponent;
    logic[9:0] fraction;
} half_t;

typedef struct packed {
    logic sign;
    logic[7:0] exponent;
    logic[22:0] fraction;
} single_t;

typedef struct packed {
    logic sign;
    logic[10:0] exponent;
    logic[51:0] fraction;
} double_t;

typedef enum logic[1:0] {
    HALF,
    SINGLE,
    DOUBLE
} floatType_t;

typedef union {
    half_t half;
    single_t single;
    double_t double;
} floatValue_t;

typedef struct packed {
    floatType_t type;
    floatValue_t value;
} float_t;

endpackage

`endif
