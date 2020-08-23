.data
num_admitted: .word 12
budget: .word 40
admitted:
.word 329  # id number
.half 959  # fame
.half 22  # wait_time
.word 908  # id number
.half 934  # fame
.half 15  # wait_time
.word 954  # id number
.half 782  # fame
.half 19  # wait_time
.word 815  # id number
.half 857  # fame
.half 4  # wait_time
.word 588  # id number
.half 696  # fame
.half 9  # wait_time
.word 530  # id number
.half 705  # fame
.half 0  # wait_time
.word 190  # id number
.half 562  # fame
.half 13  # wait_time
.word 227  # id number
.half 306  # fame
.half 26  # wait_time
.word 812  # id number
.half 352  # fame
.half 18  # wait_time
.word 231  # id number
.half 387  # fame
.half 13  # wait_time
.word 543  # id number
.half 187  # fame
.half 7  # wait_time
.word 632  # id number
.half 92  # fame
.half 12  # wait_time

.text
.globl main
main:
la $a0, admitted
lw $a1, num_admitted
lw $a2, budget
jal seat_customers

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
