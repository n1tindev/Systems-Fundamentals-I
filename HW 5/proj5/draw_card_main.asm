.data
list:
.word 5  # list's size
.word node276 # address of list's head
node21:
.word 4739396
.word node519
node86:
.word 4740164
.word 0
node507:
.word 5452868
.word node21
node519:
.word 5452356
.word node86
node276:
.word 4733269
.word node507


.text
.globl main
main:
la $a0, list
jal draw_card



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
