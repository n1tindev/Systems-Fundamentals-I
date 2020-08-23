# Nitin Dev
# NDEV
# 112298641

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part 1
init_list:
  sw $zero,0($a0)		# size
  sw $zero,4($a0)		# address of head
jr $ra


# Part 2
append:
addi $sp, $sp, -4
sw $s0, 0($sp)

  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address
  
  move $s0, $a0		# copy of original a0

  blez $t0, emptyLL		# if given size =0, then Linked List is empty

  finding_Null_NODE:
    beqz $t1, null_Node_Found			# address of next intNode is 0
    beqz $t0, null_Node_Found			# keep looping size amount of times
    
    lw $t2, 0($t1)	# value of new node
    move $t3, $t1	# copy of t1 address 
    lw $t1, 4($t1)	# address of next node
    addi $t0, $t0, -1	# loop size -- 
   j finding_Null_NODE


  null_Node_Found:
    li $a0, 8 		# new space of 8 bytes in memory
    li $v0, 9 		# address of next new intNode
    syscall
    
    move $t1, $t3	
    sw $v0, 4($t1)	# setting previous intNode's next NODE address to v0
    
    sw $a1, 0($v0)	# num
    sw $zero, 4($v0) 	# null next address
j updateSize


  emptyLL:
    li $a0, 8 		# new space of 8 bytes in memory
    li $v0, 9 		# address of next new intNode
    syscall
    sw $a1, 0($v0)	# num
    sw $v0, 4($s0)	# setting previous intNode's next NODE address to v0
    sw $zero, 4($v0) 	# null next address
    

updateSize:
  move $a0, $s0 # original a0  
  
  lw $t0, 0($a0)	# size
  addi $t0, $t0, 1	# size ++
  sw $t0, 0($a0)
  move $v0,$t0		# put updated size in v0

 lw $s0, 0($sp)
 addi $sp, $sp, 4
jr $ra



# Part 3
insert:
addi $sp, $sp, -4
sw $s0, 0($sp)


  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address
   move $s0, $a0		# copy of original a0
  
  bltz $a2, invalid	# index < 0
  bgt $a2, $t0, invalid	# index > size
  
  beqz $t0, emptyLINKEDLIST		# if given size =0, then Linked List is empty
  beq $t0, $a2, last_element	# size-1 == index (LAST ELEMENT)
  beqz $a2, indexZERO		# if index is 0 and the LL is not empty

  j INDEX_IN_MIDDLE

indexZERO:
    li $a0, 8 		# new space of 8 bytes in memory
    li $v0, 9 		# address of next new intNode
    syscall
     
        move $a0, $s0 # original a0  
    lw $t2, 4($a0) # original head  
    
    sw $a1, 0($v0)	# num
    sw $t2, 4($v0) 	# next address
    move $a0, $s0 # original a0  
    
    sw $v0, 4($a0) # head
    
    lw $t0, 0($a0)	# size
    addi $t0, $t0, 1	# size ++
    sw $t0, 0($a0)
    move $v0,$t0		# put updated size in v0
   j restoring_part3



last_element:
  null_node_find:
    beqz $t1, null_Found			# address of next intNode is 0
    beqz $t0, null_Found			# keep looping size amount of times
    
    lw $t2, 0($t1)	# value of new node
    move $t3, $t1	# copy of t1 address 
    lw $t1, 4($t1)	# address of next node
    addi $t0, $t0, -1	# loop size -- 
   j null_node_find

  null_Found:
    li $a0, 8 		# new space of 8 bytes in memory
    li $v0, 9 		# address of next new intNode
    syscall
    
    move $t1, $t3	
    sw $v0, 4($t1)	# setting previous intNode's next NODE address to v0
    
    sw $a1, 0($v0)	# num
    sw $zero, 4($v0) 	# null next address
    
    move $a0, $s0 # original a0  
  
    lw $t0, 0($a0)	# size
    addi $t0, $t0, 1	# size ++
    sw $t0, 0($a0)
    move $v0,$t0		# put updated size in v0
   j restoring_part3

emptyLINKEDLIST:
    li $a0, 8 		# new space of 8 bytes in memory
    li $v0, 9 		# address of next new intNode
    syscall
    
    sw $a1, 0($v0)	# num
    sw $zero, 4($v0) 	# null next address
    move $a0, $s0 # original a0  
    
    sw $v0, 4($a0) # head
    
    lw $t0, 0($a0)	# size
    addi $t0, $t0, 1	# size ++
    sw $t0, 0($a0)
    move $v0,$t0		# put updated size in v0
   j restoring_part3


INDEX_IN_MIDDLE:
   # a2 = index
  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address
  
  move $t4, $a2		# copy of index
  #addi $t4, $t4, -1	# index - 1		.. placing space right before index 
   

   loop_until_index_reached:
     beqz $t4, at_GIVEN_Index
     lw $t2, 0($t1)	# value of new node
     move $t3, $t1	# copy of t1 address 
     lw $t1, 4($t1)	# address of next node
     addi $t4, $t4, -1	# loop size -- 
   j loop_until_index_reached
  
  
  at_GIVEN_Index:
    li $a0, 8 		# new space of 8 bytes in memory
    li $v0, 9 		# address of next new intNode
    syscall		# step 1
    
    
    sw $a1, 0($v0)	# num   step 2
    sw $t1, 4($v0) 	# step 3	
    sw $v0, 4($t3)		# step 4
  
  # t1 = next node 
  # t3 = current node
  
  
  #1. space
 # 2. place value
 # 3. copy n-1 pointer to space ptr
 # 4. set n-1 pointer to space ptr
  
  
      move $a0, $s0 # original a0  
    lw $t0, 0($a0)	# size
    addi $t0, $t0, 1	# size ++
    sw $t0, 0($a0)
    move $v0,$t0		# put updated size in v0
   j restoring_part3
  
  
invalid:
  li $v0, -1

restoring_part3:
 lw $s0, 0($sp)
 addi $sp, $sp, 4
jr $ra


# Part 4
get_value:

  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address

  blez $t0, invalid_PART4		# list is empty
  bltz $a1, invalid_PART4		# index is negative
  bge $a1, $t0, invalid_PART4		# index is greater than or equal to the list’s size


   move $t4, $a1		# copy of index

   goto_index_given:
     beqz $t4, AT_GIVEN_Index
     lw $t2, 0($t1)	# value of new node
     move $t3, $t1	# copy of t1 address 		# t3 = current node
     lw $t1, 4($t1)	# address of next node		# t1 = next node 
     addi $t4, $t4, -1	# loop size -- 
   j goto_index_given
  
  
  AT_GIVEN_Index:
    li $v0, 0
    lw $t5, 0($t1)
    move $v1, $t5
  j endPART4

invalid_PART4:
li $v0, -1
li $v1, -1

endPART4:
jr $ra

# Part 5
set_value:
  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address

  blez $t0, invalid_PART5		# list is empty
  bltz $a1, invalid_PART5		# index is negative
  bge $a1, $t0, invalid_PART5		# index is greater than or equal to the list’s size


   move $t4, $a1		# copy of index
   TELEPORT_TO_index_given:
     beqz $t4, CURRENTLY_AT_GIVEN_Index
     lw $t2, 0($t1)	# value of new node
     move $t3, $t1	# copy of t1 address 		# t3 = current node
     lw $t1, 4($t1)	# address of next node		# t1 = next node 
     addi $t4, $t4, -1	# loop size -- 
   j TELEPORT_TO_index_given
  
  
  CURRENTLY_AT_GIVEN_Index:
    li $v0, 0
    lw $t5, 0($t1)
    move $v1, $t5
    sw $a2, 0($t1)	# update the int value to the new NUM
  j endPART5



invalid_PART5:
li $v0, -1
li $v1, -1

endPART5:
jr $ra

# Part 6
index_of:
  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address
  blez $t0, invalid_PART6		# list is empty

li $t9,0 	# index counter
   FLYING_TO_index_given:
     beqz $t0, invalid_PART6					
     lw $t2, 0($t1)	# value of new node
     beq $t2, $a1, NUMFOUNDDD
     move $t3, $t1	# copy of t1 address 		# t3 = current node
     lw $t1, 4($t1)	# address of next node		# t1 = next node 
     addi $t0, $t0, -1	# loop size -- 
     addi $t9, $t9, 1	# index counter++
   j FLYING_TO_index_given

NUMFOUNDDD:
move $v0, $t9	# return value
j endPart6

invalid_PART6:
li $v0, -1
endPart6:
jr $ra




# Part 7
remove:
  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address
  blez $t0, invalid_PART7		# list is empty
  
   li $t9,0 	# index counter
   position_at_index_given:
     beqz $t0, invalid_PART7					
     lw $t2, 0($t1)	# value of new node
     move $t3, $t1	# copy of t1 address 		# t3 = current node
     lw $t1, 4($t1)	# address of next node		# t1 = next node 
     addi $t0, $t0, -1	# loop size -- 
     beq $t2, $a1, prevINIT
     addi $t9, $t9, 1	# index counter++
   j position_at_index_given

prevINIT:
beqz $t9, remove_head
move $t8, $t9		# counter copy
addi $t8, $t8, -1	# counter -1
lw $t6, 4($a0)	# head address
prev:
   beqz $t8, elementRemoved
   lw $t6, 4($t6)
   addi $t8, $t8, -1 	
 j prev 


elementRemoved:
lw $t5, 4($t3)	# t5 = removal node's next address (  c's node adress)
sw $t5, 4($t6) # node A's next address points to node C

  lw $t0, 0($a0)	# size
  addi $t0, $t0, -1	# size --
  sw $t0, 0($a0)
  li $v0, 0
  move $v1, $t9	# return value
  j endPart7


remove_head:
     lw $t1, 4($a0)	# head address
     move $t3, $t1	# copy of t1 address 		# t3 = current node
     
     lw $t1, 4($t1)	# address of next node		# t1 = next node 
     sw $t1, 4($a0)
  
  lw $t0, 0($a0)	# size
  addi $t0, $t0, -1	# size --
  sw $t0, 0($a0)
  li $v0, 0
  move $v1, $t9	# return value
  j endPart7
     
invalid_PART7:
li $v0, -1 
li $v1, -1

endPart7:
jr $ra





# Part 8
create_deck:
  addi $sp, $sp, -16
  sw $ra, 0($sp)
  sw $s0, 4($sp)		# s0 will hold the starting address of the heap
  sw $s1, 8($sp)		# s1 will have final hex address
  sw $s2, 12($sp)
  
    li $a0, 8			# allocates 8 bytes of empty space for size and head address
    li $v0, 9
    syscall
  move $s0, $v0			# save starting address to s0
  
  move $a0, $s0
  jal init_list
  

  
  
  li $t9, '9'	# ending card numb = 9
  li $t8, '2'	# starting card numb = 2 .... hex for the number 2
  
  two_to_nineCards:
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero
     li $t1, 'C'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8     
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0  
     add $s1, $s1, $zero
     li $t1, 'D'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0     
     add $s1, $s1, $zero
     li $t1, 'H'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append
     	
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero   
     li $t1, 'S'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     li $s1, 0
     li $s2, 0
     
  
   beq $t8, $t9, letter_Cards		# on card 9
   addi $t8, $t8, 1	# next card num
   j two_to_nineCards
  
  #for 2-9 inclusive (2-10?){
 #   t0 = 2
 #     club
  #    diamond 
  #    heart
  #    spade
    
  
  
letter_Cards:
li $t8,'T'
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero
     li $t1, 'C'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8     
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0  
     add $s1, $s1, $zero
     li $t1, 'D'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0     
     add $s1, $s1, $zero
     li $t1, 'H'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append
     	
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero   
     li $t1, 'S'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     li $s1, 0
     li $s2, 0
     
 ######################################################################    
 li $t8,'J'
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero
     li $t1, 'C'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8     
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0  
     add $s1, $s1, $zero
     li $t1, 'D'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0     
     add $s1, $s1, $zero
     li $t1, 'H'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append
     	
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero   
     li $t1, 'S'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     li $s1, 0
     li $s2, 0
  ######################################################################  
li $t8,'Q'
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero
     li $t1, 'C'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8     
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0  
     add $s1, $s1, $zero
     li $t1, 'D'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0     
     add $s1, $s1, $zero
     li $t1, 'H'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append
     	
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero   
     li $t1, 'S'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     li $s1, 0
     li $s2, 0
######################################################################
li $t8,'K'
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero
     li $t1, 'C'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8     
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0  
     add $s1, $s1, $zero
     li $t1, 'D'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0     
     add $s1, $s1, $zero
     li $t1, 'H'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append
     	
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero   
     li $t1, 'S'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     li $s1, 0
     li $s2, 0
  ##################################################################
li $t8,'A'
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero
     li $t1, 'C'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8     
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0  
     add $s1, $s1, $zero
     li $t1, 'D'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     
     li $s1, 0
     li $s2, 0     
     add $s1, $s1, $zero
     li $t1, 'H'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append
     	
     li $s1, 0
     li $s2, 0
     add $s1, $s1, $zero   
     li $t1, 'S'		# suite
     add $s1, $s1, $t1
     sll $s1, $s1, 8
     add $s1, $s1, $t8		# number
     sll $s1, $s1, 8
     move $s2, $s1		# faceDown, cardNum, __   copy of s1
     li $t0, 'D'			# face down letter
     add $s2, $s2, $t0
     move $a0, $s0
     move $a1, $s2
     jal append	
     li $s1, 0
     li $s2, 0

move $v0, $s0		# return value which is a pointer to the IntArrayList 

restore_part8:
 lw $ra, 0($sp)
 lw $s0, 4($sp)
 lw $s1, 8($sp)
 lw $s2, 12($sp)
  addi $sp, $sp, 16
jr $ra




# Part 9
draw_card:
  lw $t0, 0($a0)	# size
  lw $t1, 4($a0)	# head address
  blez $t0, invalid_PART9		# list is empty
  
     lw $t9, 0($t1)
     move $t3, $t1	# copy of t1 address 		# t3 = current node
     lw $t1, 4($t1)	# address of next node		# t1 = next node 
     sw $t1, 4($a0)

  lw $t0, 0($a0)	# size
  addi $t0, $t0, -1	# size --
  sw $t0, 0($a0)		# updates size

  li $v0, 0
  move $v1, $t9
  j endpart9

invalid_PART9:
  li $v0, -1
  li $v1, -1

endpart9:
jr $ra



# Part 10
deal_cards:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s3, 12($sp)
  sw $s7, 16($sp)

  move $s0, $a0		# deck
  move $s1, $a1		# players
  
    lw $t0, 0($a0)	# size
    
  blez $t0, part10_INVALID 	# deck is empty
  blez $a2, part10_INVALID      # num_players is less than or equal to 0
  li $t0, 1
  blt $a3, $t0, part10_INVALID	# cards_per_player is less than 1
 
  lw $t4, 4($s0) # get head address
  move $s3, $a3		# copy of cards_per_player
  li $t7, 0		# total cards dealt
  
  
  
giving_cards_to_people:
  beqz $s3, done_dealing		# cards_per_player == 0
  li $t8, 0	# reset to player 0
  
 per_pass_people:
##################### flips over the card ###################
  beqz $t4, done_dealing			# address of t4 is 0x00000000
    lw $t2, 0($t4)	# VALUE
    srl $t2, $t2, 8  	# face up or down
    sll $t2, $t2, 8
    addi $t2, $t2, 'U'
    sw $t2, 0($t4) 
########################################################  
  
  move $a0, $s0	# deck
  jal draw_card
  lw $t4, 4($t4)		# loading next node address as the head
  bltz $v0, done_dealing	# deck is empty. draw_card v0 return value will be -1 which means empty
  
  addi $t7, $t7, 1		# total cards dealt ++

  
  move $s7, $s1	# base address of player0 copy stored in s7
  li $t6, 4
  mul $s7, $t8, $t6		# s7 = (t8 * 4) + s1
  add $s7, $s7, $s1	#
  
  lw $s7, 0($s7)	# address of player0
  
  move $a0, $s7	# player__
  move $a1, $v1		# v1 is the return value of num from draw_card 
  jal append
  addi $t8, $t8, 1	# player++
  beq $t8, $a2, cardPerPLAYERMINUS		# player count = num_of_players
 j per_pass_people
   
   cardPerPLAYERMINUS:

  addi $s3, $s3, -1	#cards per player goes down 
  j giving_cards_to_people

 
 
done_dealing:
move $v0, $t7
j part10_Restore
  

part10_INVALID:
  li $v0, -1

part10_Restore:
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s3, 12($sp)
  lw $s7, 16($sp)
  addi $sp, $sp, 20
jr $ra










# Part 11
card_points:
move $t0, $a0		# copy of a0
sll $t0, $t0, 24       
srl $t1, $t0, 24  	# up or down

move $t0, $a0		
sll $t0, $t0, 16       
srl $t2, $t0, 24  	# card number or letter
  
move $t0, $a0		
sll $t0, $t0, 8       
srl $t3, $t0, 24  	# suite   

move $t0, $a0		# copy of a0
srl $t4, $t0, 24  	# 00        
bnez $t4, point_INVALID		# byte 3 is not 00     
     
# t1 = up or down
# t2 = card number or letter
# t3 = suite   


################################# checking if face is valid or not ############################
li $t4, 'U'			# up
beq $t1, $t4, faceIsValid
li $t4, 'D'			# down
beq $t1,$t4, faceIsValid
j point_INVALID		# the card isnt either face up or face down
###############################################################################################
  

############################## checking if the card is a heart suite ##########################
faceIsValid:
  li $t4, 'H' 				# heart suite
  beq $t4, $t3, CHECK_FOR_CARD_NUM_OR_LETTER			# card suite = heart
  li $t4, 'S' 				# spades suite
  beq $t4, $t3, spadesCard_but_is_it_Queen			# card suite = suite
  li $t4, 'D' 				# DIAMOND suite
  beq $t4, $t3, not_a_heart
  li $t4, 'C' 				# CLUBS suite
  beq $t4, $t3, not_a_heart	
  j point_INVALID			
###############################################################################################

spadesCard_but_is_it_Queen:
  li $t4, 'Q' 
  beq $t4, $t2, point_13     	# the card is a spades queen    ## 00_SPADES_t2_UP/DOWN
li $t4, '2'  
beq $t4, $t2, point_0     	
li $t4, '3' 
beq $t4, $t2, point_0     
li $t4, '4' 
beq $t4, $t2, point_0  		  
li $t4, '5' 
beq $t4, $t2, point_0  
li $t4, '6' 
beq $t4, $t2, point_0  
li $t4, '7' 
beq $t4, $t2, point_0  
li $t4, '8' 
beq $t4, $t2, point_0  
li $t4, '9' 
beq $t4, $t2, point_0  
li $t4, 'T' 
beq $t4, $t2, point_0  
li $t4, 'J' 
beq $t4, $t2, point_0                     
li $t4, 'K' 
beq $t4, $t2, point_0 
li $t4, 'A' 
beq $t4, $t2, point_0                            
j point_INVALID		# spades suite but not a valid number or letter    
  
      
############################## checking if the card is a VALID NUMB OR LETTER ##########################
CHECK_FOR_CARD_NUM_OR_LETTER:		# all these conditions say that the card is a heart
li $t4, '2' 
beq $t4, $t2, point_1     	
li $t4, '3' 
beq $t4, $t2, point_1    
li $t4, '4' 
beq $t4, $t2, point_1     		  
li $t4, '5' 
beq $t4, $t2, point_1  
li $t4, '6' 
beq $t4, $t2, point_1  
li $t4, '7' 
beq $t4, $t2, point_1  
li $t4, '8' 
beq $t4, $t2, point_1  
li $t4, '9' 
beq $t4, $t2, point_1  
li $t4, 'T' 
beq $t4, $t2, point_1  
li $t4, 'J' 
beq $t4, $t2, point_1                     
li $t4, 'Q' 
beq $t4, $t2, point_1   
li $t4, 'K' 
beq $t4, $t2, point_1 
li $t4, 'A' 
beq $t4, $t2, point_1                            
j point_INVALID		# heart suite but not a valid number or letter                                    
        
 
#####################################  suite is not a heart, now check if the number/letter is valid ######                                                                                                                                                                                             
not_a_heart:     	# check if it is a valid card or just has a value of 0
li $t4, '2' 
beq $t4, $t2, point_0    	
li $t4, '3' 
beq $t4, $t2, point_0   
li $t4, '4' 
beq $t4, $t2, point_0    		  
li $t4, '5' 
beq $t4, $t2, point_0 
li $t4, '6' 
beq $t4, $t2, point_0 
li $t4, '7' 
beq $t4, $t2, point_0 
li $t4, '8' 
beq $t4, $t2, point_0 
li $t4, '9' 
beq $t4, $t2, point_0  
li $t4, 'T' 
beq $t4, $t2, point_0  
li $t4, 'J' 
beq $t4, $t2, point_0                   
li $t4, 'Q' 
beq $t4, $t2, point_0   
li $t4, 'K' 
beq $t4, $t2, point_0 
li $t4, 'A' 
beq $t4, $t2, point_0                            
j point_INVALID		# not heart suite nor a valid number or letter 
     
     
point_13:
li $v0, 13
j endpart11

point_1:
li $v0, 1
j endpart11

point_0:
li $v0, 0
j endpart11

point_INVALID:
li $v0, -1

endpart11:
jr $ra



# Part 12
simulate_game:
  addi $sp, $sp, -36
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s4, 16($sp)	# player 0 points
  sw $s5, 20($sp)  	# player 1 points
  sw $s6, 24($sp)	# player 2 points
  sw $s7, 28($sp)	# player 3 points
  sw $s3, 32($sp)	
   
move $s0, $a0	# original deck
move $s1, $a1	# original players
move $s2, $a2 	# original num_rounds

  li $t0, 4
  
  zeroOUTPLAYERS:
    lw $t1, 0($a1)
    move $a0, $t1
    jal init_list 
    addi $t0, $t0, -1
    addi $a1, $a1, 4
    beqz $t0, dealingCard_to_everyone
  j zeroOUTPLAYERS

dealingCard_to_everyone:
  move $a0, $s0	# deck
  move $a1, $s1	# players
  li $a2, 4	# number of players
  li $a3, 13	# cards per players ... 52 cards / 4 players = 13 
  jal deal_cards

move $a0, $s0	# load original deck
move $a1, $s1	# load original players
move $a2, $s2 	# load original num_rounds


li $t5, 0		# what player we are on
  
looking_for_2_ofClubs:		# DECIMAL FOR 2 OF CLUB (FACE UP) = 4403797
  li $t9, 4
  mul $t9, $t9, $t5
  add $a1, $a1, $t9
  lw $t4, 0($a1)		# change back to 0
  
  move $a0, $t4		# Player_ address list
  li $a1, 4403797	# 2 of club face up
  jal index_of
  bgez $v0, found_and_then_removed_2ofClubs
  
  move $a1, $s1	# load original players
  addi $t5, $t5, 1	# player++
  move $s3, $t5
 j looking_for_2_ofClubs

found_and_then_removed_2ofClubs:
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
  move $a0, $t4
  li $a1, 4403797
  jal remove
 
 
 # player who has the 2 of clubs is found and the card is removed ^^^^^^
 
 ############################### ############################### ###############################
 
 # remaining 3 players have their leftmost club card found and removed. the values of each club card are stored
 # in s6 with only the value being stored in 1 byte (2 bits)
 
 
 
 
 
 # $s3 =  player number with the 2 of clubs (player who went first and the player we want to skip over) 
 li $t5, 3
 li $t8, 0		# card index ++
 li $s6, 0		# stores the card values for the first round
 li $s5, 0		# suit

     addi $s6, $s6, 0x00000032		# 2 of clubs ... value 2 !
     li $t0, 8
     mul $t0, $t0, $s3		# places the player num with the 2 of clubs
     sllv $s6, $s6, $t0
 
     addi $s5, $s5, 0x00000043		# suit
     sllv $s5, $s5, $t0 
     
     
 remaing_players_find_then_removing_leftmost_club:
   beq $s3, $t5, skiptoNextPlayer	# player with the 2 clubs has another round again
   j continueNormally
   
   skiptoNextPlayer:
    addi $t5, $t5, -1
    bltz $t5, first_roundDONE 
 
 continueNormally:  
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
 
  move $a0, $t4
  move $a1, $t8		# index of card -- incremented  
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal get_value
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
  
  
  sll $v1, $v1, 8
  srl $v1, $v1, 24
  li $t7, 0x00000043		# hex for C... clubs
  beq $v1, $t7, club_card_found		# return value from get_value with shifted  == Clubs
  bltz $v0, no_club_in_hand
  addi $t8, $t8, 1		# card index ++
 j remaing_players_find_then_removing_leftmost_club
 
 
 
 no_club_in_hand:
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
 
 
  move $a0, $t4
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal draw_card
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
  
  move $t9, $v1
  sll $t9, $t9, 16
  srl $t9, $t9, 24		# store the value
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  or $s6, $s6, $t9
  
  move $t9, $v1
  sll $t9, $t9, 8
  srl $t9, $t9, 24 		# store the suit
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  
  or $s5, $s5, $t9
  addi $t5, $t5, -1	# player --	3 - 2 - 1 - 0 
  li $t8, 0 	# reset card index to 0
  bltz $t5,first_roundDONE	# all players done
  j remaing_players_find_then_removing_leftmost_club
 
 
 
 
 
 club_card_found:
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
 
  move $a0, $t4
  move $a1, $t8		# index of card -- incremented  
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal get_value
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
 
  
  move $t9, $v1
  sll $t9, $t9, 16
  srl $t9, $t9, 24		# store the value
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  or $s6, $s6, $t9
  
  move $t9, $v1
  sll $t9, $t9, 8
  srl $t9, $t9, 24 		# store the suit
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  
  or $s5, $s5, $t9
  
    
 
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
  move $a0, $t4
  move $a1, $v1
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal remove
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
  
  addi $t5, $t5, -1	# player --	3 - 2 - 1 - 0 
  li $t8, 0 	# reset card index to 0
  bltz $t5,first_roundDONE	# all players done
  j remaing_players_find_then_removing_leftmost_club
 
 
 first_roundDONE:
   li $t0, 0	# highest card value
   li $t2, 0	# player associated with highest card
   li $t3, 0 	# the letter card values (T, J, K, Q, A)
   move $t5, $s6	# copy of all values in t5
   li $s7, 0
 
 li $t7, 0	# sum points of the round
 
################################################################## LINKING LETTER SUITS WITH ALPHABET ######
#T - "A"
#J - B
#Q - C 
#K - D 		s6 = 32 37 39 38
	 #      s5 = D C H S
		#T5 = 32 D E 38
#A - E	


#### player 0 ########################
     andi $t0, $s6, 0x000000ff	# right most 2 bits value  
     andi $t9, $s5, 0x000000ff	# right most 2 bits SUIT  
     
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)


move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0

     
     
     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_0
     j no_swap_T_0
   swap_T_with_A_0:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000041
     j round1_player1
   no_swap_T_0:
   
   
     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_0
     j no_swap_J_0
   swap_J_with_B_0:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000042
     j round1_player1
   no_swap_J_0:
   
   
     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_0
     j no_swap_Q_0
   swap_Q_with_C_0:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000043
     j round1_player1
   no_swap_Q_0:
   
   
     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_0
     j no_swap_K_0
   swap_K_with_D_0:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000044
     j round1_player1
   no_swap_K_0:

     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_0
     j no_swap_A_0
   swap_A_with_E_0:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000045
     j round1_player1
   no_swap_A_0:

round1_player1: 
#### player 1 ########################
     andi $t0, $s6, 0x0000ff00	# value
     andi $t9, $s5, 0x0000ff00		#suit
          srl $t0, $t0, 8				  # <- insert and change this
          srl $t9, $t9, 8
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)

move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0
      		  
      		   		  
      		   		   		  
      		   		   		   		   		  

     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_1
     j no_swap_T_1
   swap_T_with_A_1:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004100		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player2
   no_swap_T_1:
   
   
     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_1
     j no_swap_J_1
   swap_J_with_B_1:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004200		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player2
   no_swap_J_1:
   
   
     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_1
     j no_swap_Q_1
   swap_Q_with_C_1:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004300		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player2
   no_swap_Q_1:
   
   
     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_1
     j no_swap_K_1
   swap_K_with_D_1:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004400		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player2
   no_swap_K_1:


     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_1
     j no_swap_A_1
   swap_A_with_E_1:
    andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004500		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player2
   no_swap_A_1:
   
round1_player2:
#### player 2 ########################
     andi $t0, $s6, 0x00ff0000	
     andi $t9, $s5, 0x00ff0000	# right most 2 bits SUIT  
          srl $t0, $t0, 16				  # <- insert and change this
           srl $t9, $t9, 16
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)
   

move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0
      		   		  

     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_2
     j no_swap_T_2
   swap_T_with_A_2:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00410000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player3
   no_swap_T_2:
   
   
     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_2
     j no_swap_J_2
   swap_J_with_B_2:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00420000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player3
   no_swap_J_2:
   
   
     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_2
     j no_swap_Q_2
   swap_Q_with_C_2:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00430000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player3
   no_swap_Q_2:
   
   
     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_2
     j no_swap_K_2
   swap_K_with_D_2:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00440000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player3
   no_swap_K_2:


     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_2
     j no_swap_A_2
   swap_A_with_E_2:
    andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00450000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_player3
   no_swap_A_2:
      
   
round1_player3:
#### player 3 ########################
     andi $t0, $s6, 0xff000000
     andi $t9, $s5, 0xff000000	# right most 2 bits SUIT  
          srl $t0, $t0, 24				  # <- insert and change this
          srl $t9, $t9, 24				  # <- insert and change this
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)
   

move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0  
     	 		  
     	 		  	 		  	 		  

     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_3
     j no_swap_T_3
   swap_T_with_A_3:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x41000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_finto
   no_swap_T_3:
   
   
     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_3
     j no_swap_J_3
   swap_J_with_B_3:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x42000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_finto
   no_swap_J_3:
   
   
     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_3
     j no_swap_Q_3
   swap_Q_with_C_3:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x43000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_finto
   no_swap_Q_3:
   
   
     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_3
     j no_swap_K_3
   swap_K_with_D_3:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x44000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_finto
   no_swap_K_3:


     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_3
     j no_swap_A_3
   swap_A_with_E_3:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x45000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j round1_finto
   no_swap_A_3:
      
round1_finto:
   
 

   li $t0, 0	# highest card value
   li $t2, 0	# player associated with highest card
   
    andi $t0, $t5, 0x000000ff	# right most 2 bits
   # move $t0,$t1
    li $t2, 0
   
   
andi $t1, $t5, 0x0000ff00	# right most 4 bits 
srl $t1, $t1, 8
bgt $t1,$t0, switchHighestCardValue
j resume
switchHighestCardValue:
  move $t0,$t1
  li $t2, 1

resume:  
andi $t1, $t5, 0x00ff0000	# right most 6 bits
srl $t1, $t1, 16
bgt $t1,$t0, switchHighestCardValue1
j resume1
switchHighestCardValue1:
  move $t0,$t1
  li $t2, 2

resume1: 
andi $t1, $t5, 0xff000000	# left most 2 bits
srl $t1, $t1, 24
bgt $t1,$t0, switchHighestCardValue2
j resume2
switchHighestCardValue2:
  move $t0,$t1
  li $t2, 3

resume2: 
# t0 - HIGHEST card value
# t2 - HIGHEST player number 
# S6 - ORIGINAL VALUE
# t7 - total points from the round
# s7 - FINAL player points 

li $t4, 8
mul $t4, $t4, $t2	# 4 * highest player # = t4

sllv $t7, $t7, $t4
add $s7, $s7, $t7




############## round 1 is over  ############################
############################################################
############################################################







addi $s2, $s2, -1 # round -- (round 1 is over)


round2_to_NUM_ROUNDS:
  beqz $s2, numROUNDSDONE
li $s5, 0
li $s6, 0

looking_for_next_suit_for_round:
  move $a1, $s1			# starting address of player	
  li $t3, 4
  move $s3, $t2
  mul $t3, $t3, $t2	# 4 * player number 
  add $a1, $a1, $t3
  lw $t4, 0($a1)	
  move $a0, $t4		# Player_ address list
  jal draw_card
  
  bltz $v0, numROUNDSDONE				# cards in hand is 0
  
  move $t6, $v1
  sll $t6, $v1, 8
  srl $t6, $t6, 24	# suit of this round
  move $s4, $t6 	# suit for this round
  
  
  sll $v1, $v1, 16 	
  srl $v1, $v1, 24	# value of this card
  
  
     add $s6, $s6, $v1		# number 
     li $t0, 8
     mul $t0, $t0, $s3		# places the player num with the 2 of clubs
     sllv $s6, $s6, $t0
 
 
     add $s5, $s5, $s4		# suit
     sllv $s5, $s5, $t0 
  
  

   # $s3 =  player number with the suite (player who went first and the player we want to skip over) 
 li $t5, 3
 li $t8, 0		# card index ++

     
  remaing_players_find_then_removing_leftmost_suite:
   beq $s3, $t5, gotoNextPLayer	# player with the 2 clubs has another round again
   j resumeNormally
   
   gotoNextPLayer:
    addi $t5, $t5, -1
    bltz $t5, this_roundDONE 
 
 resumeNormally:  
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
 
  move $a0, $t4
  move $a1, $t8		# index of card -- incremented  
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal get_value
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
  
  
  sll $v1, $v1, 8
  srl $v1, $v1, 24
  move $t7, $s4		# hex for this round SUITE
  beq $v1, $t7, suit_card_found		# return value from get_value with shifted  == Clubs
  bltz $v0, no_suit_in_hand
  addi $t8, $t8, 1		# card index ++
 j remaing_players_find_then_removing_leftmost_suite
 
 
 
 no_suit_in_hand:
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
 
 
  move $a0, $t4
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal draw_card
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
  
  move $t9, $v1
  sll $t9, $t9, 16
  srl $t9, $t9, 24		# store the value
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  or $s6, $s6, $t9
  
  move $t9, $v1
  sll $t9, $t9, 8
  srl $t9, $t9, 24 		# store the suit
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  
  or $s5, $s5, $t9
  addi $t5, $t5, -1	# player --	3 - 2 - 1 - 0 
  li $t8, 0 	# reset card index to 0
  bltz $t5,this_roundDONE	# all players done
  j remaing_players_find_then_removing_leftmost_suite
 
 
 
 suit_card_found:
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
 
  move $a0, $t4
  move $a1, $t8		# index of card -- incremented  
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal get_value
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
  
  
  move $t9, $v1
  sll $t9, $t9, 16
  srl $t9, $t9, 24		# store the value
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  or $s6, $s6, $t9


  move $t9, $v1
  sll $t9, $t9, 8
  srl $t9, $t9, 24 		# store the suit
  li $t0, 8
  mul $t0, $t0, $t5
  sllv $t9, $t9, $t0
  or $s5, $s5, $t9
  
  
  
  
    
 
  move $a1, $s1		# load original players
  li $t0, 4
  mul $t0, $t5, $t0	# a1 = player # * 4		(player 2 * 4) = 8... offset of 8
  add $a1, $a1, $t0
  lw $t4, 0($a1)
  move $a0, $t4
  move $a1, $v1
  
  addi $sp, $sp, -8
  sw $t8, 0($sp)
  sw $t5, 4($sp)
  jal remove
  lw $t8, 0($sp)
  lw $t5, 4($sp)
  addi $sp, $sp, 8
 
  addi $t5, $t5, -1	# player --	3 - 2 - 1 - 0 
  li $t8, 0 	# reset card index to 0
  bltz $t5,this_roundDONE	# all players done
  j remaing_players_find_then_removing_leftmost_suite
 
 
this_roundDONE:
   li $t0, 0	# highest card value
   li $t2, 0	# player associated with highest card
   li $t3, 0 	# the letter card values (T, J, K, Q, A)
   move $t5, $s6	# copy of all values in t5
   li $t7, 0	# sum points of the round

   
   #### player 0 ########################
     andi $t0, $s6, 0x000000ff	# right most 2 bits value  
     andi $t9, $s5, 0x000000ff	# right most 2 bits SUIT  
     
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)


move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0

     
     
     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_0_
     j no_swap_T_0_
   swap_T_with_A_0_:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000041
      j player1JUMPPP
   no_swap_T_0_:
   
   
     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_0_
     j no_swap_J_0_
   swap_J_with_B_0_:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000042
      j player1JUMPPP
   no_swap_J_0_:
   
   
     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_0_
     j no_swap_Q_0_
   swap_Q_with_C_0_:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000043
      j player1JUMPPP
   no_swap_Q_0_:
   
   
     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_0_
     j no_swap_K_0_
   swap_K_with_D_0_:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000044
      j player1JUMPPP
   no_swap_K_0_:

     andi $t0, $t5, 0x000000ff	# right most 2 bits  
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_0_
     j no_swap_A_0_
   swap_A_with_E_0_:
     srl $t5, $t5, 8
     sll $t5, $t5, 8
     addi $t5, $t5, 0x00000045
     j player1JUMPPP
   no_swap_A_0_:

 player1JUMPPP:  
#### player 1 ########################
     andi $t0, $s6, 0x0000ff00	# value
     andi $t9, $s5, 0x0000ff00		#suit
          srl $t0, $t0, 8				  # <- insert and change this
          srl $t9, $t9, 8
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)

move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0
      		  
      		   		   		   		   		  

     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_1_
     j no_swap_T_1_
   swap_T_with_A_1_:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004100		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
      j player2JUMPPP
   no_swap_T_1_:
   
   
     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_1_
     j no_swap_J_1_
   swap_J_with_B_1_:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004200		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j player2JUMPPP
   no_swap_J_1_:
   
   
     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_1_
     j no_swap_Q_1_
   swap_Q_with_C_1_:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004300		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
      j player2JUMPPP     
   no_swap_Q_1_:
   
   
     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_1_
     j no_swap_K_1_
   swap_K_with_D_1_:
     andi $t0, $t5, 0x000000ff		# <- insert and change this
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004400		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
       j player2JUMPPP 
    no_swap_K_1_:


     andi $t0, $t5, 0x0000ff00	 		  
     srl $t0, $t0, 8				  # <- insert and change this
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_1_
     j no_swap_A_1_
   swap_A_with_E_1_:
    andi $t0, $t5, 0x000000ff		# <- insert and change this 
    
     srl $t5, $t5, 16			# <- insert and change this
     sll $t5, $t5, 16			# <- insert and change this
     addi $t5, $t5, 0x00004500		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
        j player2JUMPPP 
   no_swap_A_1_:
   
player2JUMPPP:
#### player 2 ########################
     andi $t0, $s6, 0x00ff0000	
     andi $t9, $s5, 0x00ff0000	# right most 2 bits SUIT  
          srl $t0, $t0, 16				  # <- insert and change this
           srl $t9, $t9, 16
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)
   

move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0
      		   		  

     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_2_
     j no_swap_T_2_
   swap_T_with_A_2_:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00410000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
           j player3JUMPPP
   no_swap_T_2_:
   
   
     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_2_
     j no_swap_J_2_
   swap_J_with_B_2_:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00420000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j player3JUMPPP
   no_swap_J_2_:
   
   
     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_2_
     j no_swap_Q_2_
   swap_Q_with_C_2_:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00430000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j player3JUMPPP
   no_swap_Q_2_:
   
   
     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_2_
     j no_swap_K_2_
   swap_K_with_D_2_:
     andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00440000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j player3JUMPPP
   no_swap_K_2_:


     andi $t0, $t5, 0x00ff0000	 		  
     srl $t0, $t0, 16				  # <- insert and change this
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_2_
     j no_swap_A_2_
   swap_A_with_E_2_:
    andi $t0, $t5, 0x0000ffff		# <- insert and change this
     srl $t5, $t5, 24			# <- insert and change this
     sll $t5, $t5, 24			# <- insert and change this
     addi $t5, $t5, 0x00450000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j player3JUMPPP
   no_swap_A_2_:
      
   
player3JUMPPP:   
#### player 3 ########################
     andi $t0, $s6, 0xff000000
     andi $t9, $s5, 0xff000000	# right most 2 bits SUIT  
          srl $t0, $t0, 24				  # <- insert and change this
          srl $t9, $t9, 24				  # <- insert and change this
   li $t8, 0 
   add $t8, $t8, $t9		# suit
   sll $t8, $t8, 8
   add $t8, $t8, $t0		# value
   sll $t8, $t8, 8
   addi $t8, $t8, 0x00000055		# face up			00 suit value face(u/d)
   

move $a0, $t8
addi $sp, $sp, -16
sw $t7, 0($sp)
sw $t0, 4($sp)
sw $t9, 8($sp)
sw $t5, 12($sp)
jal card_points
lw $t7, 0($sp)
lw $t0, 4($sp)
lw $t9, 8($sp)
lw $t5, 12($sp)
addi $sp, $sp, 16
add $t7, $t7, $v0  
     	 		  
     	 		  	 		  	 		  

     li $t3, 0x00000054	# T3 = TEN (T)
     beq $t0, $t3, swap_T_with_A_3_
     j no_swap_T_3_
   swap_T_with_A_3_:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x41000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j fintooo
   no_swap_T_3_:
   
   
     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x0000004A	# T3 = JACK (J)
     beq $t0, $t3, swap_J_with_B_3_
     j no_swap_J_3_
   swap_J_with_B_3_:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x42000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j fintooo
   no_swap_J_3_:
   
   
     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x00000051	# T3 = QUEEN (J)
     beq $t0, $t3, swap_Q_with_C_3_
     j no_swap_Q_3_
   swap_Q_with_C_3_:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x43000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j fintooo
   no_swap_Q_3_:
   
   
     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x0000004B	# T3 = KING (K)
     beq $t0, $t3, swap_K_with_D_3_
     j no_swap_K_3_
   swap_K_with_D_3_:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x44000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j fintooo
   no_swap_K_3_:


     andi $t0, $t5, 0xff000000	 		  
     srl $t0, $t0, 24				  # <- insert and change this
     li $t3, 0x00000041	# T3 = ACE (A)
     beq $t0, $t3, swap_A_with_E_3_
     j no_swap_A_3_
   swap_A_with_E_3_:
     andi $t0, $t5, 0x00ffffff		# <- insert and change this
     li $t5, 0
     addi $t5, $t5, 0x45000000		# <- insert and change this
     add $t5, $t5, $t0			# <- insert and change this
     j fintooo
   no_swap_A_3_:   
   

fintooo:
li $t0, 0	# highest card value
   li $t2, 0	# player associated with highest card
   
    andi $t0, $t5, 0x000000ff	# right most 2 bits
   # move $t0,$t1
    li $t2, 0
   
   
andi $t1, $t5, 0x0000ff00	# right most 4 bits 
srl $t1, $t1, 8
bgt $t1,$t0, switchHighestCardValue_
j resume_
switchHighestCardValue_:
  move $t0,$t1
  li $t2, 1

resume_:  
andi $t1, $t5, 0x00ff0000	# right most 6 bits
srl $t1, $t1, 16
bgt $t1,$t0, switchHighestCardValue1_
j resume1_
switchHighestCardValue1_:
  move $t0,$t1
  li $t2, 2

resume1_: 
andi $t1, $t5, 0xff000000	# left most 2 bits
srl $t1, $t1, 24
bgt $t1,$t0, switchHighestCardValue2_
j resume2_
switchHighestCardValue2_:
  move $t0,$t1
  li $t2, 3

resume2_: 
# t0 - HIGHEST card value
# t2 - HIGHEST player number 
# S6 - ORIGINAL VALUE
# t7 - total points from the round
# s7 - FINAL player points 

li $t4, 8
mul $t4, $t4, $t2	# 4 * highest player # = t4

sllv $t7, $t7, $t4
add $s7, $s7, $t7
  addi $s2, $s2, -1 # round tracker -- (round __ is over)
  
 j round2_to_NUM_ROUNDS

  
  
  
  

 numROUNDSDONE:
  move $v0, $s7
  
  

part12_Restore:
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s4, 16($sp)	
  lw $s5, 20($sp)  
  lw $s6, 24($sp)
  lw $s7, 28($sp)
  lw $s3, 32($sp)	
  addi $sp, $sp, 36
jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
