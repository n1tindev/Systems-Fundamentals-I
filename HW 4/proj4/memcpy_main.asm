.data
.align 2
n: .word 0
src: .asciiz "ABCDEFGHIJ"
dest: .asciiz "XXXXXXX"

.text
.globl main
main:
la $a0, src
la $a1, dest
lw $a2, n
jal memcpy

# We are late enough in the semester that you can take care of printing
# the results of the function call.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall 

li $v0, 10
syscall

.include "proj4.asm"
