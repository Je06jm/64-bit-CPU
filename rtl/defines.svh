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
    INVALID_OPCODE,

    DOUBLE_FAULT,
    TRIPLE_FAULT, // Resets the CPU

    INVALID_FLOAT_SIZE,

    TIMER
} exception;

typedef enum logic[7:0] {
    NOP =       'h00,
    HALT =      'h01,

    LOADMCR =   'h02,
    STOREMCR =  'h03,

    SYSCALL =   'h04,
    SYSRET =    'h05,
    INT =       'h06,
    INTRET =    'h07,

    ADD =       'h10,
    SUB =       'h11,
    MUL =       'h12,
    DIV =       'h13,
    MOD =       'h14,

    SADD =      'h18,
    SSUB =      'h19,
    SMUL =      'h1a,
    SDIV =      'h1b,
    SMOD =      'h1c,

    // Does not support byte floats!
    FADD =      'h20,
    FSUB =      'h21,
    FMUL =      'h22,
    FDIV =      'h23,
    FMOD =      'h24,

    SET =       'h30,
    ESET =      'h31,
    ZSET =      'h32,

    INC =       'h33,
    DEC =       'h34,
    AND =       'h35,
    OR =        'h36,
    XOR =       'h37,
    NOT =       'h38,
    ROLR =      'h39,
    ROLL =      'h3a,
    SHIFTRC =   'h3b,
    SHIFTLC =   'h3c,
    SWAP =      'h3d,
    FLIP =      'h3e,
    MOVE =      'h3f,

    CMP =       'h40,
    FCMP =      'h41,

    JMP =       'h42,
    BRA =       'h43,
    IJMP =      'h44,
    IBRA =      'h45,
    AJMP =      'h46,
    ABRA =      'h47,
    JMPI =      'h48,
    BRAI =      'h49,
    IJMPI =     'h4a,
    IBRAI =     'h4b,
    AJMPI =     'h4c,
    ABRAI =     'h4d,
    RET =       'h4e,

    LOAD =      'h50,
    STORE =     'h51,

    ILOAD =     'h52,
    ISTORE =    'h53,

    ASTOREIF =  'h54,

    SISTOREIF = 'h55,

    LOADI =     'h56,
    STOREI =    'h57,

    ILOADI =    'h56,
    ISTOREI =   'h57,

    STOREIFI =  'h58,

    ISTOREIFI = 'h59,

    CAFI =      'h5a,

    PUSH =      'h60,
    POP =       'h61,

    TBIT =      'h62,
    SBIT =      'h63,
    CBIT =      'h64,
    EBIT =      'h65,

    OUT =       'h66,
    IN =        'h67,

    SETC =      'h68,
    CLEARC =    'h69,

    SETZ =      'h6a,
    CLEARZ =    'h6b,

    SETN =      'h6c,
    CLEARN =    'h6d
} opcode_t;

typedef enum logic[1:0] {
    BYTES_1 =   'h0,
    BYTES_2 =   'h1,
    BYTES_4 =   'h2,
    BYTES_8 =   'h3
} instructionDataSize_t;

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
    R16 =   'h10,
    R17 =   'h11,
    R18 =   'h12,
    R19 =   'h13,
    R20 =   'h14,
    R21 =   'h15,
    R22 =   'h16,
    R23 =   'h17,
    R24 =   'h18,
    R25 =   'h19,
    R26 =   'h1a,
    R27 =   'h1b,
    R28 =   'h1c,
    R29 =   'h1d,
    R30 =   'h1e,
    R31 =   'h1f,
    R32 =   'h20,
    R33 =   'h21,
    R34 =   'h22,
    R35 =   'h23,
    R36 =   'h24,
    R37 =   'h25,
    R38 =   'h26,
    R39 =   'h27,
    R40 =   'h28,
    R41 =   'h29,
    R42 =   'h2a,
    R43 =   'h2b,
    R44 =   'h2c,
    R45 =   'h2d,
    R46 =   'h2e,
    R47 =   'h2f,
    R48 =   'h30,
    R49 =   'h31,
    R50 =   'h32,
    R51 =   'h33,
    R52 =   'h34,
    R53 =   'h35,
    R54 =   'h36,
    R55 =   'h37,
    R56 =   'h38,
    R57 =   'h39,
    R58 =   'h3a,
    R59 =   'h3b,
    R60 =   'h3c,
    R61 =   'h3d,
    R62 =   'h3e,
    R63 =   'h3f,

    BASE0 = 'hf9,
    BASE1 = 'hfa,
    INDEX0 ='hfb,
    INDEX1 ='hfc,
    
    SP =    'hfd,
    BP =    'hfe,
    IC =    'hff
} register_t;

typedef struct packed {
    opcode_t opcode;
} instructionOps0_t;

typedef struct packed {
    
} instructionOps1_t;

endpackage

`endif