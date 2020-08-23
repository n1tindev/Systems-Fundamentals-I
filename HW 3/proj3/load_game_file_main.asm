.data
filename: .asciiz "board2.txt"
v0: .asciiz "$v0: "
.align 2
board: .space 2000  # WARNING: During grading, this buffer will be the
                    # smallest possible size to accommodate
                    # the needs of the GameBoard data structure.

.text
.globl main
main:
la $a0, board
la $a1, filename
jal load_game_file



move $t0, $v0
# print function's return value
li $v0, 4
la $a0, v0
syscall
li $v0, 1 
move $a0, $t0
syscall 



li $v0, 10
syscall

.include "proj3.asm"
