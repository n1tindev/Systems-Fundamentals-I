.data
.align 2
queue:
.align 2
.half 5  # size
.half 5  # max_size
# index 0
.word 14  # id number
.half 918  # fame
.half 11  # wait_time
# index 1
.word 514  # id number
.half 742  # fame
.half 26  # wait_time
# index 2
.word 852  # id number
.half 644  # fame
.half 11  # wait_time
# index 3
.word 235  # id number
.half 416  # fame
.half 17  # wait_time
# index 4
.word 194  # id number
.half 601  # fame
.half 2  # wait_time
customer:
.word 931  # id number
.half 62  # fame
.half 20  # wait_time



.text
.globl main
main:
la $a0, queue		#s0
la $a1, customer	#s1
jal enqueue

# We are late enough in the semester that you can take care of printing
# the results of the function call.
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

.include "proj4.asm"
