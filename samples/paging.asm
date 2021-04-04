section .text

global _start
_start:
    ; Load PageTable pointer
    zset        PageTable, R0
    zset        0, R1
    zset        6, R2
    storemcr    R0, R1, R2

    ; Enable paging
    zset        0, R0
    zset        0, R1
    loadmcr     R0, R1, R2
    zset        5, R3
    bset        R2, R3, R2
    storemcr    R2, R0, R1

    ; Paging now enabled
    halt

section .data

#define CREATE_ENTRY(addr, RW, privaliged, size) (addr | (RW << 3) | (privaliged << 2) | (size << 1) | 1)

align 0x1000
; Holds a GB page, a MB page, and a KB page
PageTable:
.PT0:
CREATE_ENTRY(0, 1, 0, 1) ; GB page
CREATE_ENTRY(.PT1_MB, 0, 0, 0) ; MB page
CREATE_ENTRY(.PT1_KB, 0, 0, 0) ; KB page
times 512 - $ dq 0
.PT1_MB: ; MB page
CREATE_ENTRY(0x200000, 0, 0, 1) ; MB page
times 512 - $ dq 0
.PT1_KB: ; KB page
CREATE_ENTRY(.PT2, 0, 0, 0) ; KB page
times 512 - $ dq 0
.PT2:
CREATE_ENTRY(0x4000, 0, 1, 1) ; KB page
times 512 - $ dq 0

