.data

num: .word 37
list:
.word 5  # list's size
.word node761 # address of list's head
node168:
.word 402
.word 0
node814:
.word 978
.word node248
node761:
.word 962
.word node112
node248:
.word 526
.word node168
node112:
.word 762
.word node814

.text
.globl main
main:
la $a0, list
lw $a1, num
jal append

# Write your own code here to verify that the function is correct.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall 


li $v0, 10
syscall

.include "proj5.asm"
