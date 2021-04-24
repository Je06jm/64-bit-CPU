`ifndef CPU_INSTRUCTIONS
`define CPU_INSTRUCTIONS

`include "rtl/types.svh"
import types::*;

package instructions;

typedef enum logic[15:0] {

    NOP,
    HALT,

    LOADMCR,
    STOREMCR,
    
    SYSCALL,
    SYSRET,
    INT,
    INTRET,

    ADD,
    SUB,
    MUL,

    UDIV,
    UMOD,

    SDIV,
    SMOD,

    INC,
    DEC,

    FADD,
    FSUB,
    FMUL,
    FDIV,
    FMOD,
    FFMA,

    FEPOW, // e ^ x
    F2POW, // 2 ^ x
    F10POW, // 10 ^ x
    FEPOW1, // e ^ x - 1
    F2POW1, // 2 ^ x - 1
    F10POW1, // 10 ^ x - 1

    FLN, // ln(x)
    F2LOG, // log2(x)
    F10LOG, // log10(x)
    FLN1, // ln(x + 1)
    F2LOG1, // log2(x + 1)
    F10LOG1, // log10(x + 1)

    FDISTANCE, // sqrt(x ^ 2 + y ^ 2)

    FSQRT,

    FPOW1, // (1 + x) ^ y
    FFPOW, // x ^ (1 / y)
    FPOW, // x ^ y
    
    FSIN,
    FCOS,
    FTAN,

    FASIN, // arcsin(x)
    FACOS, // arccos(x)
    FATAN, // arctan(x)
    FATAN2, // atan2(x, y)

    FSINPI, // sin(PI * x)
    FCOSPI, // cos(PI * x)
    FTANPI, // tan(PI * x)

    FASINPI, // arcsin(x) / PI
    FACOSPI, // arccos(x) / PI
    FATANPI, // arctan(x) / PI
    FATAN2PI, // atan2(x, y) / PI

    FSINH, // sinh(x)
    FCOSH, // cosh(x)
    FTANH, // tanh(x)

    FARSINH, // arsinh(x)
    FARCOSH, // arcosh(x)
    FARTANH, // artanh(x)

    FABS,
    FNEG,
    FCOPY,
    FTEST,

    TOINT,
    TOFLOAT,

    AND,
    OR,
    XOR,
    NOT,
    ROLR,
    ROLL,
    SHIFTR,
    SHIFTL,
    FLIP,

    SWAP,
    MOVE,

    CMP,
    FCMP,

    JMP,
    BRA,
    RET,

    LOAD,
    STORE,
    STOREIF, // Only stores if value matches

    PUSH,
    POP,

    BIT,

    OUT,
    IN,

    SETF,
    CLEARF

} opcode_t;

typedef enum logic[3:0] {
    BITS_8 =   'h0,
    BITS_16 =  'h1,
    BITS_32 =  'h2,
    BITS_64 =  'h3
} sizeFlags_t;

typedef logic[7:0] flags_t;

`define NO_FLAGS 0

`define USE_ARG0_AS_IMMIDIATE (1<<0)
`define USE_ARG1_AS_IMMIDIATE (1<<1)
`define USE_ARG2_AS_IMMIDIATE (1<<2)
`define USE_ARG3_AS_IMMIDIATE (1<<3)

`define IS_FLOAT_NAN (1<<1)
`define IS_FLOAT_POS_NAN (1<<2)
`define IS_FLOAT_NEG_NAN (1<<3)
`define IS_FLOAT_INF (1<<4)
`define IS_FLOAT_POS_INF (1<<5)
`define IS_FLOAT_NEG_INF (1<<6)

`define ROUND_TO_NEAREST_EVEN (1<<2)
`define ROUND_TO_NEAREST_ZERO (1<<3)
`define ROUND_TO_ZERO (1<<4)
`define ROUND_TO_INF (1<<5)
`define ROUND_TO_NEG_INF (1<<6)

`define USE_CARRY_BIT (1<<2)

`define IS_RELATIVE (1<<4)

`define IS_ATOMIC (1<<4)

`define BIT_SET (1<<2)
`define BIT_CLEAR (1<<3)
`define BIT_TEST (1<<4)

`define SELECT_C_FLAG (1<<2)
`define SELECT_N_FLAG (1<<3)
`define SELECT_Z_FLAG (1<<4)

`define ARG0_SIGN_EXTEND (1<<4)
`define ARG1_SIGN_EXTEND (1<<5)
`define ARG2_SIGN_EXTEND (1<<6)
`define ARG3_SIGN_EXTEND (1<<7)

`define BRANCH_SIGNED (1<<0)
`define BRANCH_C (1<<1)
`define BRANCH_N (1<<2)
`define BRANCH_Z (1<<3)

`define BRANCH_NOT_C (1<<4)
`define BRANCH_NOT_N (1<<5)
`define BRANCH_NOT_z (1<<6)

typedef struct packed {
    opcode_t opcode;
    sizeFlags_t argSize0, argSize1, argSize2, argSize3;
    flags_t flags;
    ulong_t arg0, arg1, arg2, arg3;
} instruction_t;

endpackage

`endif
