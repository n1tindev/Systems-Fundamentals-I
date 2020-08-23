.text
.globl main
main:
jal create_deck

# Write your own code here to verify that the function is correct.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj5.asm"
