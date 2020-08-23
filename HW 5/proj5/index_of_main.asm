.data
num: .word 887
list:
.word 8  # list's size
.word node970 # address of list's head
node622:
.word 887
.word node123
node273:
.word 34
.word node300
node347:
.word 887
.word node273
node285:
.word 493
.word node762
node300:
.word 232
.word 0
node970:
.word 887
.word node622
node762:
.word 232
.word node347
node123:
.word 232
.word node285





.text
.globl main
main:
la $a0, list
lw $a1, num
jal index_of

# Write your own code here to verify that the function is correct.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj5.asm"
