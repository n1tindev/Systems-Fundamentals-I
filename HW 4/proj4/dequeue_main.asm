.data
queue:
.align 2
.half 0  # size
.half 5  # max_size
# index 0
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 1
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 2
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 3
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 4
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
dequeued_customer:  # garbage
.word 346  # id number
.half 568  # fame
.half 12  # wait_time





.text
.globl main
main:
la $a0, queue
la $a1, dequeued_customer
jal dequeue

# We are late enough in the semester that you can take care of printing
# the results of the function call.
move $t0, $v0
li $v0, 1 
move $a0, $t0
syscall 

li $v0, 10
syscall

.include "proj4.asm"
