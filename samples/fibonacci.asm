section .text

global _start
_start:
    bra         fib
    halt

fib:
    ; Setup variables
    zset        byte 1, R0 ; A
    zset        byte 1, R1 ; B

    ; Address to store
    zset        byte data, R3

    ; Numbers calculated
    zset        byte 2, R4
    ; Maximum numbers to calculate
    zset        short 512, R5
    
    ; Next number offset
    zset        byte 8, R6

    ; Pre-store 1, 1
    store       quad R0, R3
    add         R3, R6, R3
    store       quad R1, R3
    add         R3, R6, R3

.loop:
    ; Have we reached our limit?
    cmp         R4, R5
    ret         nl ; Could also do ret  g,e
    
    ; Calculate next number
    add         R0, R1, R2
    inc         R4, R4

    move        R1, R0
    move        R2, R1

    ; Store and repeat

    store       R2, R3
    add         R3, R6, R3

    jmp         .loop

section .bss

data:
    resq        512
