section .text

global _start
_start:
    zset        Stack.bottom, SP
    move        SP, BP

    halt

section .bss

align 16
Stack:
.top:
resb 2048 ; 2 KB
.bottom:
