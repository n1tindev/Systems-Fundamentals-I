# Nitin Dev
# NDEV
# 112298641

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part 1
compare_to:
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

move $s0, $a0
move $s1, $a1

lhu $t0, 4($a0)		# t0 has the c1's fame 
lhu $t1, 4($a1)		# t1 has the c2's fame 

lhu $t2, 6($a0)		# t2 has the c1's wait time 
lhu $t3, 6($a1)		# t3 has the c2's wait time


### c1 priority math ###		priority = fame + (10 × wait time)
li $t4, 10
mult $t4, $t2		# 10 * c1 wait time
mflo $t5		# product 
add $t9, $t5, $t0	# t9 = t5 + t0	.... 	sum = product + c1 fame 

### c2 priority math ###		priority = fame + (10 × wait time)
li $t4, 10
mul $t5, $t4, $t3		# 10 * c2 wait time = product 
add $t8, $t5, $t1	# t9 = t5 + t1	.... 	sum = product + c2 fame 


### t9 - c1 priority
### t8 - c2 priority


blt $t9, $t8, c1_LESS_priority 		# c1 priority < c2 priority
bgt $t9, $t8, c1_GREATER_priority 	# c1 priority > c2 priority
#beq $t9, $t8, c1_c2_EQUAL		# c1 priority == c2 priority 

blt $t0, $t1, c1_LESS_priority		# c1 fame < c2 fame
bgt $t0, $t1, c1_GREATER_priority 	# c1 fame > c2 fame
j c1_c2_EQUAL				# c1 fame == c2 fame

c1_LESS_priority:
  li $v0, -1
  j finishedPart1

c1_GREATER_priority:
  li $v0, 1
  j finishedPart1
  
c1_c2_EQUAL:
  li $v0, 0
  j finishedPart1

finishedPart1:
move $a0, $s0
move $a1, $s1

lw $s0, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8
jr $ra



# Part 2
init_queue:
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

move $s0, $a0
move $s1, $a1

blez $a1, size_less_than_ZERO	# max size ≤ 0
		
sh $zero, 0($a0)	# {size} field of the struct to 0.... saves 0 to the SIZE
sh $a1, 2($a0)		# {max size} field to the value of the argument max size.... saves MAX SIZE to the MAX SIZE
move $t0, $a0		# copy of a0 starting address
addi $a0, $a0, 4	# offset the queue by 4 to ignore the size and max size 

li $t9, 8
mul $t9, $a1, $t9	# max * 8 = t9


zeroOUT_QUEUE:
  lbu $t1, 0($a0)			# gets the number
  beqz $t9, settingV0_VALEUE		# everything is zeroed out.... current number is 0
  sb $zero, 0($a0)			# override the value in queue to be 0
  addi $a0, $a0, 1			# next number
  addi $t9, $t9, -1			# keeps looping until the product is zero... iteration 2*max_size times
j zeroOUT_QUEUE


settingV0_VALEUE:
move $a0, $t0			# return the starting address of a0
bgtz $a1, valid_size 		# max size > 0

size_less_than_ZERO: 
  li $v0, -1
  j finishedPart2
  
valid_size:
move $v0, $a1			# set return value to max_size

finishedPart2:
move $a0, $s0
move $a1, $s1

lw $s0, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8
jr $ra


# Part 3
memcpy:
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2

blez $a2, n_less_than_ZERO	# n ≤ 0
move $t0, $a2    		# copy of n 

REPLACE_dest_Letter:
  beqz $t0, REPLACE_dest_Letter_DONE		# copy of n == 0 
  lb $t1, 0($a0)				# loads the src letter
  sb $t1, 0($a1)				# saves the loaded src letter into dest
  addi $a0, $a0, 1				# src ++
  addi $a1, $a1, 1				# dest ++
  addi $t0, $t0, -1				# copy of n --
j REPLACE_dest_Letter
 
 
REPLACE_dest_Letter_DONE:
  bgtz $a2, valid_n 		# n > 0

n_less_than_ZERO: 
  li $v0, -1
  j finishedPart3
  
valid_n :
   move $v0, $a2			# set return value to n

finishedPart3:
move $a0, $s0
move $a1, $s1

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
addi $sp, $sp, 12
jr $ra




# Part 4
contains:
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

move $s0, $a0
move $s1, $a1

li $t0, 0		# the person number in the whole queue	000, 001, 002, 003....
li $t1, 1		# level in the tree ...	starts from 1

lhu $t9, 0($a0)		# actual size of people in the queue

findingID:
  lhu $t4, 4($a0)			# t4 has the current person's id	
  beq $t4, $a1, parent_division		# found the person
  beq $t9, $t0, noIDFOUND		# person isnt found
  addi $a0, $a0, 8			# next person's ID number .. increment by 8 for new person's id
  addi $t0,$t0, 1			# person number ++
  j findingID

parent_division:
addi $t0, $t0, -1		# t0 - 1
li $t8, 3
div $t0, $t8			# (t0 - 1) / 3
mflo $t0			# set index to the quoient 
addi $t1, $t1, 1		# level ++
beqz $t0, IDFOUND		# break if no more parent
j parent_division


IDFOUND:
  move $v0, $t1			# load the level in the tree
  j finishedPart4

noIDFOUND:
  li $v0, -1
  j finishedPart4
  
finishedPart4:
move $a0, $s0
move $a1, $s1

lw $s0, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8
jr $ra



# Part 5
enqueue:
addi $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $ra, 8($sp)
sw $s2, 12($sp)

sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)

move $s0, $a0		# queue
move $s1, $a1		# customer

##############################  condition checks   ###########################    

lhu $t9, 0($a0)			# actual size of people in the queue
lhu $t8, 2($a0)			# max size
beq $t9, $t8, CANNOT_ENQUEUE	# full queue.

lhu $t5, 0($a1)		# new customer's ID number

move $a1, $t5		# new customer ID
jal contains
move $a1, $s1
bltz $v0, uniqueID 	# if the return value from contain is -1 then the person wasnt found == can be enque
j CANNOT_ENQUEUE	# return value is greater than 0, then the person was found


CANNOT_ENQUEUE:
  li $v0, -1		# -1 to v0
  move $v1, $t9		# size to v1
  j finishedPart5
###########################    check finished #################################

uniqueID: 									#size ++
  li $t0, 8
  mul $t1, $t0, $t9		# 8 * size 
  add $a0, $a0, $t1		# queue += 8 * size
  addi $a0, $a0, 4
  move $t9, $a0			# copy of updated queue address where there is a free spot
  move $s2, $t9
  
  ####################    moving new customer's data values into the first open spot #######################
  li $t0, 8
  move $a0, $s1			# src -> new cust
  move $a1, $t9			# dest -> adress queue
  move $a2, $t0			# n = 8
  move $s6, $t9			# copy of address the customer was put
  jal memcpy

  ######################################################################
  ######################################################################
  


fixQueue:  

################  get the index of where the new customer is in the queue  ########
  sub $t2, $s2, $s0		# [(t9) - (original queue adress)] 
  li $t0, 8
  div $t2, $t0			# difference/8 ....  (t2 / 8) = current person's index
  mflo $t3			# quotient 	(current person's index)
  
  beqz $t3, doneSwapping	# the index of the new customer is 0 ... which is root
  
######################################################################


  ################ find the new customer's parent, then getting the address where parent data is ###########
  addi $t3, $t3, -1
  li $t0, 3			# parent 
  div $t3, $t0		# (t3 - 1) /3
  mflo $t3		# index of parent 
  
  li $t0, 8
  mul $t3, $t3, $t0	# parent index * 8
  add $t9, $t3, $s0	# parent's memory address
  move $s2, $t9		# copy of parent's memory adress
  
  addi $s2, $s2, 4						# ?????? offset by 4 bc it was replacing size 	
######################################################################

  move $a0, $s6			# original new customer location 
  move $a1, $s2			# adrdess of parent
  jal compare_to
  blez $v0, doneSwapping  		# return value < 0, new customer priorrity <= parent priority

  
 # li $t0, 8
 # move $a0, $s2			# src -> parent's value
 # move $a1, $s1			# dest -> new customer (outside the paramater)
 # move $a2, $t0			# n = 8							temp store parent
 # jal memcpy

  addi $sp, $sp, -8

  
  move $a0, $s2 		# src			largest address
  move $a1, $sp			# dest			stack
  li $a2, 8
  jal memcpy			# saves the largest address' contents temp
  

  move $a0, $s6			# src -> new cust (current address of new customer)
  move $a1, $s2			# dest -> parent's memory address 
  li $a2, 8
  jal memcpy
  
  li $t0, 8
  move $a0, $sp			# src -> temp parent's value
  move $a1, $s6			# dest -> new customer's child 
  li $a2, 8
  jal memcpy
  
    addi $sp, $sp, 8
  
  
j fixQueue


doneSwapping:
  li $v0, 1			# 1 to v0 ... successful 
  lhu $t9, 0($s0)		# actual size of people in the queue
  addi $t9, $t9, 1		# size + 1 to v1
  sh $t9, 0($s0)
  move $v1, $t9			# v1 = new size
  

finishedPart5:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 28($sp)
addi $sp, $sp, 32
jr $ra



# Part 6
heapify_down:
  addi $sp, $sp, -32
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $ra, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  sw $s4, 20($sp)
  sw $s5, 24($sp)
  sw $s6, 28($sp)

  move $s0, $a0				# copy of original starting queue address
  move $s1, $a1				# copy of index
  
  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]

  bltz $a1, invalidIndex		# index < 0
  bge $a1, $t0, invalidIndex		# index ≥ queue.size
  j maxHeapINIT				# conditions met then start 
  
invalidIndex:
  li $v0, -1
  j finishedPart6
  
################################################################################
maxHeapINIT:
  li $s2, 0		# number of swaps done COUNTER


maxHeap:
    move $s0, $a0			# copy of original starting queue address
    lhu $t0, 0($a0)			# line repeat for safety [  queue.size() ]
    
    bge $s1, $t0, doneCounterSwaps	# index ≥ queue.size 
    
    li $t1, 3 				# number 3 
  #####  left = 3*index + 1  #####  
    mul $t2, $t1, $s1			# t2 = t1 * s1 .... t2 = 3 * index (index will change)
    addi $s4, $t2, 1			# s4 = $t2 + 1 
  ##### mid = 3*index + 2  #####  
    mul $t3, $t1, $s1			# t3 = t1 * s1 .... t3 = 3 * index (index will change)
    addi $s5, $t3, 2			# s5 = $t3 + 2
  ##### right = 3*index + 3  #####  
    mul $t4, $t1, $s1			# t4 = t1 * s1 .... t4 = 3 * index (index will change)
    addi $s6, $t4, 3			# s6 = $t4 + 3    
   
    move $s3, $s1			# largest = index 
   
   lhu $t0, 0($a0)			# line repeat for safety [  queue.size() ]
    
   bge $s4, $t0, middle_SWAP_CHECK		# if left >= queue.size
  
############################################################################################################ 
# left_SWAP_CHECK:								
  li $t1, 8
  mul $t1, $t1, $s4		# t1 = 8 * index of left
  add $s0, $s0, $t1		# queue += 8 * index
  addi $s0, $s0, 4		# offset queue
  move $t7, $s0			# address of left customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress

  li $t1, 8
  mul $t1, $t1, $s3		# t1 = 8 * largest // root
  add $s0, $s0, $t1		# queue += 8 * largest
  addi $s0, $s0, 4		# offset queue
  move $t6, $s0			# address of largest customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
  
  move $a0, $t7			# address of left 	(c1)
  move $a1, $t6			# address of root 	(c2)
  jal compare_to		# A[left] > A[largest] 	
  move $a0, $s0			# reset s0 to original a0 starting queue adress
  
  blez $v0, middle_SWAP_CHECK		# c2 >= c1		.. 0 or -1
    
    move $s3, $s4		# largest gets the left index .... left is largest
  
  middle_SWAP_CHECK:
  lhu $t0, 0($a0)			# line repeat for safety [  queue.size() ]
  bge $s5, $t0, right_SWAP_CHECK
  
  li $t1, 8
  mul $t1, $t1, $s5		# t1 = 8 * index of middle
  add $s0, $s0, $t1		# queue += 8 * index
  addi $s0, $s0, 4		# offset queue
  move $t7, $s0			# address of middle customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress

  li $t1, 8
  mul $t1, $t1, $s3		# t1 = 8 * largest 
  add $s0, $s0, $t1		# queue += 8 * largest
  addi $s0, $s0, 4		# offset queue
  move $t6, $s0			# address of largest customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
  
  move $a0, $t7			# address of middle 	(c1)
  move $a1, $t6			# address of largest 	(c2)
  jal compare_to		# A[middle] > A[largest] 	
  move $a0, $s0			# reset s0 to original a0 starting queue adress
  
  blez $v0, right_SWAP_CHECK		# c2 >= c1		.. 0 or -1
    
    move $s3, $s5		# largest gets the middle index .... middle is largest
  
  
  
  right_SWAP_CHECK:
  lhu $t0, 0($a0)			# line repeat for safety [  queue.size() ]
  bge $s6, $t0, largest_not_equal_index
  
  li $t1, 8
  mul $t1, $t1, $s6		# t1 = 8 * index of right
  add $s0, $s0, $t1		# queue += 8 * index
  addi $s0, $s0, 4		# offset queue
  move $t7, $s0			# address of middle customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress

  li $t1, 8
  mul $t1, $t1, $s3		# t1 = 8 * largest 
  add $s0, $s0, $t1		# queue += 8 * largest
  addi $s0, $s0, 4		# offset queue
  move $t6, $s0			# address of largest customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
  
  move $a0, $t7			# address of middle 	(c1)
  move $a1, $t6			# address of largest 	(c2)
  jal compare_to		# A[right] > A[largest] 	
  move $a0, $s0			# reset s0 to original a0 starting queue adress
  
  blez $v0, largest_not_equal_index		# c2 >= c1		.. 0 or -1
    
    move $s3, $s6		# largest gets the right index .... right is largest
  
  
  largest_not_equal_index:
  
  beq $s1, $s3, doneCounterSwaps
  
  addi $sp, $sp, -8

  li $t1, 8
  mul $t1, $t1, $s1		# t1 = 8 * original parent 
  add $s0, $s0, $t1		# queue += 8 * largest
  addi $s0, $s0, 4		# offset queue
  move $t6, $s0			# address of parent customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
  
  move $a0, $t6 		# src			largest address
  move $a1, $sp			# dest			stack
  li $a2, 8
  jal memcpy			# saves the largest address' contents temp
  move $a0, $s0			# load back the original starting address
  move $a1, $s1			# load back the index
   
  
  li $t1, 8
  mul $t1, $t1, $s3		# t1 = 8 * largest 
  add $s0, $s0, $t1		# queue += 8 * largest
  addi $s0, $s0, 4		# offset queue
  move $t7, $s0			# address of largest customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
   
 
  move $a0, $t7			# src			copy t7 into t6 
  move $a1, $t6			# dest			contents of left/middle/right is put into largest
  li $a2, 8
  jal memcpy
  move $a0, $s0			# load back the original starting address
   
  li $t1, 8
  mul $t1, $t1, $s3		# t1 = 8 * largest 
  add $s0, $s0, $t1		# queue += 8 * largest
  addi $s0, $s0, 4		# offset queue
  move $t7, $s0			# address of largest customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
   
  move $a0, $sp			# src			copy t7 into t6 
  move $a1, $t7			# dest			contents of left/middle/right is put into largest
  li $a2, 8
  jal memcpy
  move $a0, $s0			# reset s0 to original a0 starting queue adress
   
   
   
    move $s1, $s3		# index = largest index
    addi $s2, $s2, 1		# counter ++
   
     addi $sp, $sp, 8
 j maxHeap		# ((left <-> root) <-> middle) <-> right


doneCounterSwaps:
  move $v0, $s2	# load the number of swaps counter into the v0 ... return value

finishedPart6:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $ra, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  lw $s4, 20($sp)
  lw $s5, 24($sp)
  lw $s6, 28($sp)
  addi $sp, $sp, 32
jr $ra




# Part 7
dequeue:
  addi $sp, $sp, -16
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $ra, 8($sp)
  sw $s2, 12($sp)

  move $s0, $a0				# copy of original starting queue address
  move $s1, $a1				# copy of dequed customer
  
  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]
  blez $t0, queueIsEmpty		# size < 0
  j dequeProcess			# size is valid then do deque
  
  queueIsEmpty:
  li $v0, -1
  j finishedPart7

  dequeProcess:
  
  addi $s0, $s0, 4		# offset queue
  move $s2, $s0			# address of root customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
  move $a0, $s2 		# src			root
  move $a1, $a1			# dest			deq cust
  li $a2, 8
  jal memcpy			# saves the largest address' contents temp
  move $a0, $s0			# load back the original starting address


  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]
  addi $t0, $t0, -1		# queue.size() - 1 node 
  
  li $t1, 8
  mul $t1, $t1, $t0		# t1 = 8 * last node 
  add $s0, $s0, $t1		# queue += ( t1)
  addi $s0, $s0, 4		# offset queue
  move $t7, $s0			# address of last customer
  move $s0, $a0			# reset s0 to original a0 starting queue adress
  
  move $a0, $t7 		# src			last node
  move $a1, $s2			# dest			root address 
  li $a2, 8
  jal memcpy			# saves the largest address' contents temp
  move $a0, $s0			# load back the original starting address
  
  
  lhu $t0, 0($a0)		# actual size of people in the queue [  queue.size() ]
  addi $t0, $t0, -1		# queue.size() - 1 
  
  sh $t0, 0($a0)		# updating size on the queue address
  
move $a0, $s0
li $a1, 0
jal heapify_down
  
  

doneDequeue:
  lhu $t0, 0($a0)		# actual size of people in the queue [  queue.size() ]
  move $v0, $t0			# load the number of size into the v0 ... return value

finishedPart7:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $ra, 8($sp)
  lw $s2, 12($sp)
  addi $sp, $sp, 16
jr $ra





# Part 8
build_heap:
  addi $sp, $sp, -24
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $ra, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  sw $s4, 20($sp)

  move $s0, $a0				# copy of original starting queue address
  lhu $s2, 0($a0)			# actual size of people in the queue [  queue.size() ]
  li $s1, 0 				# sum for the retun value  ....    res = 0

  beqz $s2, SIZEISEMPTY

  addi $s3, $s2, -1	# queue.size - 1 = s3
  li $t0, 3
  div $s3, $t0		# (queue.size - 1) / 3
  mflo $s3 		# put quotient in s3 ... integer division      s3 = index
  
  move $s4, $s3		# s4 is "i" and has the same value as index 

creatingHeap_ALGORITHM:
  bltz $s4, buildingHeapDONE		# i = 0 
  move $a0, $s0		# queue
  move $a1, $s4		# i 
  jal heapify_down 
  add $s1, $s1, $v0		# sum = sum + return value from v0
  addi $s4, $s4, -1		# i --
 j creatingHeap_ALGORITHM

SIZEISEMPTY:
li $v0, 0
j finishedPart8

buildingHeapDONE:
  move $v0, $s1		# return the sum from heapfiy down to v0 		return res

finishedPart8:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $ra, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  lw $s4, 20($sp)
  addi $sp, $sp, 24
jr $ra


# Part 9
increment_time:
  addi $sp, $sp, -20
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $ra, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  
  move $s0, $a0				# copy of original starting queue address
  move $s1, $a1				# copy of original delta_mins
  move $s2, $a2				# copy of original fame_level
  
  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]
  
  beqz $t0, incorrectINPUTS		# size is 0
  blez $s1, incorrectINPUTS		# delta mins ≤ 0
  blez $s2, incorrectINPUTS		# fame level ≤ 0

   addi $a0, $a0, 4		# offset by 4 to skip max and size
   
  increasingEveryone_WAIT_TIME:
    beqz $t0, doneIncreasingWAIT_TIME	
    lhu $t1, 6($a0)		# t1 has the customer's wait time 
    add $t1, $t1, $s1		# t1 = (current wait time) + (delta mins)
    sh $t1, 6($a0)
    addi $a0, $a0, 8		# next customer
    addi $t0, $t0, -1
    j increasingEveryone_WAIT_TIME


doneIncreasingWAIT_TIME:
  move $a0, $s0		# reset a0 back to original starting queue address
  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]

   addi $a0, $a0, 4		# offset by 4 to skip max and size


finding_People_Whose_FAME_WILL_CHANGE:
    beqz $t0, FIXING_CHANGED_HEAP	
    lhu $t1, 4($a0)		# t1 has the  fame 
    
    bge $t1, $s2, nofameUpdated		# current customer's fame level is EQUAL OR GREATER than the FAME_LEVEL ARGUMENT
    
    add $t1, $t1, $s1		# t1 = (current fame level) + (delta mins)
    sh $t1, 4($a0)
    
    nofameUpdated:
      addi $a0, $a0, 8		# next customer
      addi $t0, $t0, -1
   j finding_People_Whose_FAME_WILL_CHANGE
   

FIXING_CHANGED_HEAP:
  move $a0, $s0		# reset a0 back to original starting queue address
  jal build_heap
  
  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]
  
   addi $a0, $a0, 4		# offset by 4 to skip max and size
   li $s3, 0 		# total wait time --> avg --> return value

   findingAVGwaitTime:
    beqz $t0, doneADDING_Time	
    lhu $t1, 6($a0)		# t1 has the customer's wait time 
    add $s3, $s3, $t1		# total wait time = total wait time + current customer's wait time 
    addi $a0, $a0, 8		# next customer
    addi $t0, $t0, -1
    j findingAVGwaitTime


  incorrectINPUTS:
    li $v0, -1			# return -1 in v0
    j finishedPart9

doneADDING_Time:
  move $a0, $s0		# reset a0 back to original starting queue address
  lhu $t0, 0($a0)			# actual size of people in the queue [  queue.size() ]
  div $s3, $t0		# total wait time / size
  mflo $s3		# integer division... quoient
  move $v0, $s3		# return the avg wait time

finishedPart9:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $ra, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
jr $ra



# Part 10
admit_customers:
  addi $sp, $sp, -24
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $ra, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  sw $s4, 20($sp)

  move $s0, $a0			# queue starting address copy
  move $s1, $a1			# max_admits copy
  move $s2, $a2			# admitted
  
  li $s3, 0			# how many admitted 
  
  lhu $t0, 0($a0)		# actual size of people in the queue [  queue.size() ]
  move $s4, $t0
  
  
  beqz $t0, part10Error		# queue is empty
  blez $s1, part10Error		# max_admits ≤ 0

  deque_MAX_ADMITS_times:
    beqz $s1, maxADMITS_REACHED		# max admits = 0 
    beqz $s4, maxADMITS_REACHED		# copy of size = 0
    
    move $a0, $s0		# customer queue 
    move $a1, $s2		# dequeued_customer gets saved in ADMITTED ARRAY
    jal dequeue
    addi $s2, $s2, 8
    addi $s3, $s3, 1		# admitted ++
    addi $s1, $s1, -1		# max admits --
    addi $s4, $s4, -1		# copy of size --
  j deque_MAX_ADMITS_times


maxADMITS_REACHED:
  move $v0, $s3		# admitted counter into v0
  j finishedPart10

part10Error:
  li $v0, -1
  
finishedPart10:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $ra, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  lw $s4, 20($sp)
  addi $sp, $sp, 24
jr $ra



# Part 11
seat_customers:
  addi $sp, $sp, -32
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $ra, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  sw $s4, 20($sp)
  sw $s5, 24($sp)
  sw $s6, 28($sp)

	
   move $s0, $a0	# Customer structs ... ( admitted )
   move $s1, $a1   	# length of the admitted array a0 ... ( num_admitted )
   move $s2, $a2	# maximum total wait time ... ( budget )
   
   blez $s1, part11Error	# num_admitted ≤ 0 
   blez $s2, part11Error	# budget ≤ 0
   
 
li $t0, 0		#  ... bitstring
li $t1, 1		# 2 ^n instantiate
sllv $t1, $t1, $s1
addi $t1, $t1, -1	# 2^(n) -1			0 to 2^(n) -1   
      
li $s7, 0 		# MAX FAME
li $s6, 0		# bitstring that corresponds to the max fame value... convert to decimal       

knapsack:  # looping through combos

  beq $t0, $t1, combosDONE
  li $t2, 1		# bit mask 		
  li $t3, 0		# counter        

   li $s4, 0 	# total wait time of bit string 
   li $s5, 0    # total fame
   
  bitstring_loop:  # looping through a bitstring
    move $a0, $s0		# original adress of admitted array
    li $t4, 32
    beq $t3,$t4, bitstring_loopDONE		# 0 to 31
    and $s3, $t0, $t2		# mask t0 AND T2 and save result into s3
    sll $t2, $t2, 1	# shift mask by 1 
    
    addi $t3, $t3, 1		# coutner ++
    beqz $s3, bitstring_loop	# move to next bit in the bitstring
    addi $t3, $t3, -1		# coutner --
     
     li $t9, 8
     mul $t9, $t9, $t3
     add $a0, $a0, $t9		# a0 = s0 + t9
     lh $t9, 6($a0)			# load wait time into t9
     addi $t3, $t3, 1			# coutner ++
     bgt $t9, $s2, bitstring_loop	# is current customer's wait time > budget
     add $s4, $s4, $t9			# total wait time += customer wait time 
     
     lh $t9, 4($a0)			# load fame into t9
     add $s5, $s5, $t9			# total fame += customer fame
     move $a0, $s0		# original adress of admitted array
   j bitstring_loop
  
  bitstring_loopDONE:
  move $a0, $s0		# original adress of admitted array

  addi $t0, $t0, 1
  bgt $s4, $s2, knapsack		# TOTAL wait time > budget
  ble $s5, $s7,	knapsack			# TOTAL FAME <= MAX FAME 
  
  addi $t0, $t0, -1
  move $s7, $s5				# set max fame (s7) to total fame (s5)
  move $s6, $t0				# set the new bitstring to t0
  
  addi $t0, $t0, 1
 j knapsack


combosDONE:
  move $v0, $s6		# bitstring (integer) which encodes which customers were seated
  move $v1, $s7		# total fame of the people who are seated
  j finishedPart11

part11Error:
  li $v0, -1
  li $v1, -1
j finishedPart11

finishedPart11:
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $ra, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  lw $s4, 20($sp)
  lw $s5, 24($sp)
  lw $s6, 28($sp)
  addi $sp, $sp, 32
jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
