.data
num: .word 43
index: .word 6
list:
.word 6  # list's size
.word node619 # address of list's head
node140:
.word 863
.word node940
node940:
.word 140
.word node21
node209:
.word 332
.word node147
node619:
.word 59
.word node209
node147:
.word 655
.word node140
node21:
.word 846
.word 0





.text
.globl main
main:
la $a0, list
lw $a1, num
lw $a2, index
jal insert

# Write your own code here to verify that the function is correct.




move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall 

li $v0, 10
syscall

.include "proj5.asm"
