.data
index: .word 2
num: .word 26
list:
.word 7  # list's size
.word node414 # address of list's head
node66:
.word 120
.word node153
node599:
.word 684
.word node66
node414:
.word 622
.word node599
node116:
.word 624
.word 0
node136:
.word 56
.word node143
node153:
.word 520
.word node136
node143:
.word 496
.word node116



.text
.globl main
main:
la $a0, list
lw $a1, index
lw $a2, num
jal set_value

# Write your own code here to verify that the function is correct.



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

.include "proj5.asm"
