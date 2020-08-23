.data
.align 2
board:
.byte 6
.byte 4
.half
1 3 1 48
3 1 1 24
768 768 6 6
1 2 2 6
768 6 3 2
0 48 1 24
  

.text
.globl main
main:
la $a0, board
jal slide_board_up

# Write your own code to print the return value and the contents of the board.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall 

li $v0, 10
syscall

.include "proj3.asm"
