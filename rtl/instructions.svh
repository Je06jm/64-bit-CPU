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

    SET,
    INC,
    DEC,
    AND,
    OR,
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

typedef enum logic[2:0] {
    BYTES_8 =   'h0,
    BYTES_16 =  'h1,
    BYTES_32 =  'h2,
    BYTES_64 =  'h3
} sizeFlags_t;


typedef logic[15:0] flags_t;


typedef struct packed {
    opcode_t opcode;
    sizeFlags_t argSize0, argSize1, argSize2, argSize3;
    flags_t flags;
    argument_t arg0, arg1, arg2, arg3;
} instruction_t;

endpackage

`endif
