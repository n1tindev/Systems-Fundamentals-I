.data
num: .word 790
list:
.word 7  # list's size
.word node534 # address of list's head
node361:
.word 779
.word 0
node675:
.word 814
.word node986
node534:
.word 303
.word node675
node986:
.word 717
.word node726
node256:
.word 842
.word node361
node726:
.word 790
.word node294
node294:
.word 595
.word node256



.text
.globl main
main:
la $a0, list
lw $a1, num
jal remove

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
