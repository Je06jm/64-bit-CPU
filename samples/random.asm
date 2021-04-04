#define PRIME0 769961
#define PRIME1 1118653

section .text

; In R0 - Seed
SetSeed:
    push R1
    set randSeed, R1
    store R0, R1
    pop R1

    ret

; Out R0 - Random quad
RandInt:
    push R1
    push R2
    push R3

    set randSeed, R1
    load R1, R0

    set PRIME0, R2
    set PRIME1, R3

    mul R0, R2, R2
    mul R0, R3, R3

    xor R2, R3, R0
    rolr R2, R0, R2

    xor R2, R3, R0
    store R0, R1

    pop R3
    pop R2
    pop R1

    ret

section .bss
randSeed:
    resq        1
