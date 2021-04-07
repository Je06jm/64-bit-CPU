`ifndef CPU_INSTRUCTIONS
`define CPU_INSTRUCTIONS

`include "types.svh"
import types::*

package instructions;

typedef enum logic[6:0] {

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
    DIV,
    MOD,

    SADD,
    SSUB,
    SMUL,
    SDIV,
    SMOD,

    FADD,
    FSUB,
    FMUL,
    FDIV,
    FMOD,
    FSQRT,
    FFMA,

    FABS,
    FNEG,
    FCOPY,
    FTEST,

    TOINT,
    TOFLOAT,

    INC,
    DEC,
    AND,
    OR,
    XOR,
    NOT,
    ROLR,
    ROLL,
    SHIFTR,
    SHIFTL,
    SWAP,
    FLIP,
    MOVE,

    CMP,

    JMP,
    BRA,
    RET,

    LOAD,
    STORE,
    CAFI,

    PUSH,
    POP,

    BIT,

    OUT,
    IN,

    SETF,
    CLEARF

} opcodeByte_t

typedef enum logic[14:0] {

} opcodeWord_t;

typedef union packed {
    logic usesWord;
    opcodeByte_t byte;
    opcodeWord_t word;
} opcode_t;

typedef union packed {
    byte_t byte;
    ubyte_t ubyte;
    short_t short;
    ushort_t ushort;
    int_t int;
    uint_t uint;
    long_t long;
    ulong_t ulong;
} argument_t;

typedef enum logic[3:0] {
    BYTES_8 =   'h0,
    BYTES_16 =  'h1,
    BYTES_32 =  'h2,
    BYTES_64 =  'h3
} sizeFlags_t;

typedef logic[7:0] flags_t;

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

`define SET_UNUSED_TO_ZERO (1<<4)
`define SIGN_EXTEND_UNUSED (1<<5)

`define USE_CARRY_BIT (1<<2)

`define IS_RELATIVE (1<<4)

`define IS_ATOMIC (1<<2)
`define IS_VALUE_EQU (1<<3)

`define BIT_SET (1<<2)
`define BIT_CLEAR (1<<3)
`define BIT_TEST (1<<4)

`define SELECT_C_FLAG (1<<2)
`define SELECT_N_FLAG (1<<3)
`define SELECT_Z_FLAG (1<<4)


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
    argument_t arg0, arg1, arg2, arg3;
} instruction_t;

endpackage

`endif
