`ifndef CPU_EXCEPTIONS
`define CPU_EXCEPTIONS

package exceptions;

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
    TRIPLE_FAULT,

    INVALID_FLOAT_SIZE,

    TIMER

} exception_t;
    
endpackage

`endif
