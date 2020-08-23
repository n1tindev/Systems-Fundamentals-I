.data
.align 2
row: .word 6
col: .word 4
board:
.byte 8	# row
.byte 7	# col
.half 6 1 6 2 3 3 6 0 1 2 0 0 0 0 0 2 0 1 2 3 6 6 48 12 1 24 3 3 2 12 3 0 1 3 0 3 6 3 6 3 6 3 12 12 12 12 12 12 12 24 3 2 6 1 0 3 

.text
.globl main
main:
la $a0, board
lw $a1, row
lw $a2, col
jal get_tile

# Write your own code to print the return value.

move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall 


li $v0, 10
syscall

.include "proj3.asm"
