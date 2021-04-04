`ifndef CPU_DEFINES
`define CPU_DEFINES

package defines;

typedef logic signed[7:0] byte_t;
typedef logic signed[15:0] short_t;
typedef logic signed[31:0] int_t;
typedef logic signed[63:0] quad_t;
typedef logic signed[64:0] bquad_t;

typedef logic unsigned[7:0] ubyte_t;
typedef logic unsigned[15:0] ushort_t;
typedef logic unsigned[31:0] uint_t;
typedef logic unsigned[63:0] uquad_t;
typedef logic unsigned[64:0] buquad_t;

typedef struct packed {
    uquad_t addr;
    uquad_t data;
    logic isWrite;
    logic isPrivaliged;
    logic isValid;
} cpuMemRequest_t;

typedef struct packed {
    uquad_t data;
    logic isValid;
} cpuMemResult_t;

// TODO: Turn this into a flag array???
typedef enum logic[7:0] {
    NONE,
    PAGE_PRIVALIGED_ACCESS,
    PAGE_READ_ONLY,
    NO_PAGE_MAPPED,
    INVALID_PAGE_ENTRY,

    DIVIDE_BY_ZERO,
    INVALID_ADDRESS,

    DOUBLE_FAULT,
    TRIPLE_FAULT, // Resets the CPU

    TIMER
} exception;

typedef enum logic[7:0] {
    NOP,
    HALT,

    LOADMSR,
    STOREMSR,

    SYSCALL,
    SYSRET,
    INT,
    INTRET,

    MOV,
    SET,

    ADD,
    SUB,
    MUL,
    DIV,
    MOD,

    // TODO: Add signed instructions

    AND,
    OR,
    XOR,
    NOT,
    SHIFTR,
    SHIFTL,
    SHIFTRC,
    SHIFTLC,

    AADD, // TODO: Remove atomic instructions
    ASUB,
    AMUL,
    ADIV,

    AAND,
    AOR,
    AXOR,
    ANOT,
    AMOD,
    ASHIFTR,
    ASHIFTL,
    ASHIFTRC,
    ASHIFTLC,

    CMP,

    JMP,
    BRA,
    RET,

    PUSH,
    POP,

    LOAD,
    STORE,

    ALOAD,
    ASTORE, // TODO: Add atomic store if equals instruction

    TBIT,
    SBIT,
    CBIT,

    OUT,
    IN
} opcode_t;

typedef enum logic[2:0] {
    BYTES_1 =   'h0,
    BYTES_2 =   'h1,
    BYTES_4 =   'h2,
    BYTES_8 =   'h3
} instructionSize_t;

typedef logic[6:0] instructionFlags_t;
`define INSTRUCTION_OP0_USE_IMMIDIATE (1<<0)
`define INSTRUCTION_OP1_USE_IMMIDIATE (1<<1)
`define INSTRUCTION_OP2_USE_IMMIDIATE (1<<2)
`define INSTRUCTION_OP3_USE_IMMIDIATE (1<<3)

typedef ushort_t branchFlags_t;
`define BRANCH_ZERO (1<<0)
`define BRANCH_EQUALS (1<<0)
`define BRANCH_LESS (1<<1)
`define BRANCH_MORE (1<<2)
`define BRANCH_ABOVE (1<<3)
`define BRANCH_BELOW (1<<4)
`define BRANCH_NEGITIVE (1<<5)
`define BRANCH_CARRY (1<<5)

`define BRANCH_NOT_ZERO (1<<8)
`define BRANCH_NOT_EQUALS (1<<8)
`define BRANCH_NOT_LESS (1<<9)
`define BRANCH_NOT_MORE (1<<10)
`define BRANCH_NOT_ABOVE (1<<11)
`define BRANCH_NOT_NEGITIVE (1<<12)
`define BRANCH_NOT_BELOW (1<<12)
`define BRANCH_NOT_CARRY (1<<13)

typedef uint_t processorFlags_t;
`define ZERO (1<<0)
`define NEGITIVE (1<<1)
`define CARRY (1<<2)

`define RUNNING (1<<8)
`define PAGING (1<<9)
`define SUPERVISER (1<<10)

typedef enum logic[7:0] {
    R0 =    'h00,
    R1 =    'h01,
    R2 =    'h02,
    R3 =    'h03,
    R4 =    'h04,
    R5 =    'h05,
    R6 =    'h06,
    R7 =    'h07,
    R8 =    'h08,
    R9 =    'h09,
    R10 =   'h0a,
    R11 =   'h0b,
    R12 =   'h0c,
    R13 =   'h0d,
    R14 =   'h0e,
    R15 =   'h0f,

    IC =    'hfc,
    SP =    'hfd,
    BP =    'hfe,
    FLAGS = 'hff
} register_t;

endpackage

`endif