section .text

global _start
_start:
    ; The number of numbers to calculate
    move        512, R0
    ; Where to store them
    move        data, R1

    bra         fib
    ret

fib:
    ; See if R0 is zero
    or          R0, R0, ZERO
    ; Return if it is zero
    ret         z

    ; Move data around
    move        R0, R3
    move        R1, R4

    ; Intial values
    move        1, R0
    move        1, R1

    ; Zero out a register to use
    ; for our indexing
    xor         R5, R5

    ; Store the first few numbers
    ; manualy
    store       R0, [R4+R5*8]
    inc         R5

    ; Test number requested
    dec         R3
    ret         z

    ; More number storing
    store       R0, [R4+R5*8]
    inc         R5

    ; Do one last manuel check on the
    ; number of requested numbers
    dec         R3
    ret         z

.loop:
    ; Calculate the next number in the
    ; sequence
    add         R0, R1, R2
    move        R1, R0
    move        R2, R1

    ; Store it in the requested buffer
    store       R2, [R4+R5*8]
    inc         R5

    ; See if we have generated the requested
    ; number of numbers
    dec         R3
    ; Return if so
    ret         z

    ; Do this all over again
    jmp         .loop

section .bss

data:
    resq        512
