.data
.align 2
board:
.byte 7
.byte 12
.half 
2 6 6 768 24 1 96 24 1536 6 0 2
1536 1 12 0 12 3 24 768 384 1 3 192
3 768 192 2 2 768 96 24 96 1 0 2
96 2 0 3 12 3 48 48 0 1 1 384
12 1 1 48 0 768 24 1 768 24 0 6
3 192 1 768 6 48 12 0 2 48 1 2
12 3 1 1 384 24 768 3 2 3 24 12

.text
.globl main
main:
la $a0, board
jal game_status

# Write your own code to print the return values.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall


move $t0, $v1
li $v0, 1 
move $a0, $t0
syscall



li $v0, 10
syscall

.include "proj3.asm"
