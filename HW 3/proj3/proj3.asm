# Nitin Dev
# NDEV
# 112298641

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part 1
load_game_file:
  addi $sp, $sp, -16
  sw $ra, 0($sp)
  sw $s0, 4($sp)		# gameboard address... input buffer
  sw $s1, 8($sp)		# filename address
  sw $s7, 12($sp)
  move $s0, $a0
  move $t0, $a0		# temp a0 adress
  move $s1, $a1

  li $v0, 13	# open file 
  move $a0, $a1   # file name string adress
  li $a1, 0	# flag = 0 
  li $a2, 0	# mode = 0 (ignore)
  syscall

  bltz $v0, openingError # error if file DNE or cant be opened 


  move $s7, $v0		# file descriptor copy into s7
  move $a0, $v0		# file descriptor into a0
  
  addi $sp, $sp, -4	# stack pointer temp
  sw $0, 0($sp)

  li $t6, 0 # sum = 0
  li $t5, 10 # multitply by 10 for additional place
  li $t9, 0

ROW:
  li $t8, ' '
  li $t7, 0x0a			# new line
  
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 14		# read file 
  syscall 		# reads 1 char and places into gamebaord
  
  bltz $v0, errorFile	
  li $t9, 0
  lb $t9, 0($a1)	# content read 
  
  beq $t9, $t8, ignoreNULL
  beq $t9, $t7, ignoreNULL

  addi $t9, $t9, -48 	# to get int value
  mul $t6, $t6, $t5		# sum = (sum * 10)
  add $t6, $t6, $t9       # (if character then sum = sum + t9)
  j ROW
  
 ignoreNULL:
  sb $t6, 0($s0)
  addi $s0, $s0, 1    # board address + 1  (addi s0 s0 1
  li $t6, 0 #sum = 0 # reset sum to 0


COL:
  li $t6, 0 # sum = 0
  li $t5, 10 # multitply by 10 for additional place
  li $t9, 0

COLBEGIN:
  li $t8, ' '
  li $t7, 0x0a			# new line
  
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 14		# read file 
  syscall 		# reads 1 char and places into gamebaord
  
  bltz $v0, errorFile	
  li $t9, 0
  lb $t9, 0($a1)	# content read 
  
  beq $t9, $t8, ignoreNULLcol
  beq $t9, $t7, ignoreNULLcol

  addi $t9, $t9, -48 	# to get int value
  mul $t6, $t6, $t5		# sum = (sum * 10)
  add $t6, $t6, $t9       # (if character then sum = sum + t9)
  j COLBEGIN
  
 ignoreNULLcol:
  sb $t6, 0($s0)
  addi $s0, $s0, 1    # board address + 1  (addi s0 s0 1
  li $t6, 0 #sum = 0 # reset sum to 0

  li $t8, ' '
  li $t7, 0x0a			# new line
  li $t4, 0			# counter for how many nonzeros





####################  ignores the newline char...
  li $t6, 0 # sum = 0
  li $t5, 10 # multitply by 10 for additional place
  li $t9, 0
  	
####################

readFile:
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 14		# read file 
  syscall 		# reads 1 char and places into gamebaord
  beqz $v0, doneReading	# v0 = 0... file is finished then break
  bltz $v0, errorFile	
  li $t9, 0
  lb $t9, 0($a1)	# content read 
  
  beq $t9, $t8, ignore
  beq $t9, $t7, ignore

  addi $t9, $t9, -48 	# to get int value
  mul $t6, $t6, $t5		# sum = (sum * 10)
  add $t6, $t6, $t9       # (if character then sum = sum + t9)
   
  j readFile
  
ignore:
  sh $t6, 0($s0)
  bgtz $t6, counterAdd    # if sum is greater than 0, then counter++ (return value for the part)
  addi $s0, $s0, 2    # board address + 1  (addi s0 s0 1
  li $t6, 0 #sum = 0 # reset sum to 0
  j readFile

#addi $t0, $t0, 1	# char++ saving

counterAdd:
addi $t4, $t4, 1
addi $s0, $s0, 2    # board address + 1  (addi s0 s0 1
li $t6, 0 #sum = 0 # reset sum to 0
j readFile


errorFile:
    li $t4, -1
    li $v0, -1
    j skip

openingError:
    li $t4, -1
    li $v0, -1
    j skip

doneReading:
  addi $sp, $sp, 4
  

skip:
################# close file
    move $a0, $s7			# original v0 value into a0
    li $v0, 16
    syscall  
################# 
move $v0, $t4


lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)	
lw $s7, 12($sp)			
addi $sp,$sp, 16 
    
jr $ra




# Part 2
save_game_file:
  addi $sp, $sp, -24
  sw $s0, 0($sp)		# gameboard address... input buffer
  sw $s1, 4($sp)		# output.txt filename
  
  sw $s2, 8($sp)		# row number
  sw $s3, 12($sp)		# col number
  
  sw $s4, 16($sp)		# row number COUNTER
  sw $s5, 20($sp)		# col number COUNTER
  
  li $s4, 0			# row counter
  li $s5, 1			# col counter
  
  move $s0, $a0		# copy of the original board 

  
############# output.txt open
  li $v0, 13	  # open file 
  move $a0, $a1   # file name string adress
  li $a1, 1	  # flag = 1 	... writing
  li $a2, 0	  # mode = 0 (ignore)
  syscall
  move $s1, $v0		# copy of filename2
############# 
  
   #########################     row number     ################################
  
 li $t2, 0 
 li $t3, 0
 li $t0, 0 
 lbu $t0, 0($s0)	# loads an individual number 
 move $s2, $t0		# row number saved on stack
 
addi $sp, $sp, -3	# make space on stack
li $t5, 0 		# counter for stack

writeRow:
 li $t1, 10 	# divide by 10
 li $t2, 0	# sum reversed 
 
 div $t0, $t1 	# (18/10)			18 / 10 -> 1 R 8
 mfhi $t3	# remainder from divison
 mflo $t4	# quoient from divison 
 addi $t2, $t3, 48	# t2 = t2 + remainder		48 + 8 =  56
 sb $t2, 0($sp)
 addi $t5, $t5, 1
 beqz $t4, WRITEINGROWNOW
 
 
 div $t4, $t1
 mfhi $t3	# remainder from divison
 mflo $t4	# quoient from divison 
 addi $t2, $t3, 48	# t2 = t2 + remainder		
 sb $t2, 1($sp)
 addi $t5, $t5, 1
 beqz $t4, WRITEINGROWNOW
 
 div $t4, $t1
 mfhi $t3	# remainder from divison
 mflo $t4	# quoient from divison 
 addi $t2, $t3, 48	# t2 = t2 + remainder		
 sb $t2, 2($sp)
 addi $t5, $t5, 1
 beqz $t4, WRITEINGROWNOW
 

 WRITEINGROWNOW:
 addi $t5,$t5, -1		# stack start from 0 
 li $t6, 0							
 li $t7, 0 							
 
 add $t6, $t5, $sp
 lb $t7, 0($t6)			# load top of stack into t7
 
  addi $sp, $sp, -1
  sb $t7, 0($sp)		# save the ascii char value of int on the stack
  move $a0, $s1			# file descriptor
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 15			# write file 
  bltz $v0, errorWriting		# if syscall's v0 is -1 branch
  syscall
  
  addi $sp, $sp, 1 		# remove space on stack
  beqz $t5, donerow		# stack is empty then break out
 j WRITEINGROWNOW
  
  donerow:
  ############# add space 
  addi $s0, $s0, 1	# to go to next number
  li $t8, 0x20		# space
  sb $t8, 0($sp)	# store space on stack
  move $a0, $s1			# file descriptor
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 15			# write file 
  syscall
  bltz $v0, errorWriting		# if syscall's v0 is -1 branch
  addi $sp, $sp, 3		# remove space on stack
 
 
 #########################     column number     ################################
 
 li $t2, 0 
 li $t3, 0
 li $t0, 0 
 lbu $t0, 0($s0)	# loads an individual number 
 move $s3, $t0		# col number saved on stack

addi $sp, $sp, -3	# make space on stack
li $t5, 0 		# counter for stack

writeCol:						### writes on the stack .. reverse...
 li $t1, 10 	# divide by 10
 li $t2, 0	# sum reversed 
 
 div $t0, $t1 	# (18/10)			18 / 10 -> 1 R 8
 mfhi $t3	# remainder from divison
 mflo $t4	# quoient from divison 
 addi $t2, $t3, 48	# t2 = t2 + remainder		48 + 8 =  56
 sb $t2, 0($sp)
 addi $t5, $t5, 1
 beqz $t4, WRITEINGCOLNOW
 
 
 div $t4, $t1
 mfhi $t3	# remainder from divison
 mflo $t4	# quoient from divison 
 #mul $t3, $t3, $t1
 addi $t2, $t3, 48	# t2 = t2 + remainder		
 sb $t2, 1($sp)
 addi $t5, $t5, 1
 beqz $t4, WRITEINGCOLNOW
 
 div $t4, $t1
 mfhi $t3	# remainder from divison
 mflo $t4	# quoient from divison 
 #mul $t3, $t3, $t1
 addi $t2, $t3, 48	# t2 = t2 + remainder		
 sb $t2, 2($sp)
 addi $t5, $t5, 1	
 beqz $t4, WRITEINGCOLNOW					### done on the stack ...
 

 WRITEINGCOLNOW:
 addi $t5,$t5, -1		# stack start from 0 
 li $t6, 0							
 li $t7, 0 							
 
 add $t6, $t5, $sp
 lb $t7, 0($t6)			# load top of stack into t7
 
  addi $sp, $sp, -1
  sb $t7, 0($sp)		# save the ascii char value of int on the stack
  move $a0, $s1			# file descriptor
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 15			# write file 
  bltz $v0, errorWriting		# if syscall's v0 is -1 branch
  syscall
  
  addi $sp, $sp, 1 		# remove space on stack
  beqz $t5, donecol		# stack is empty then break out
 j WRITEINGCOLNOW
  
  donecol:
  ############# add newline 
  addi $s0, $s0, 1	# to go to next number
  li $t8, 0x0a		# newline
  sb $t8, 0($sp)	# store space on stack
  move $a0, $s1			# file descriptor
  move $a1, $sp 		# s0 -> a1
  li $a2, 1
  li $v0, 15			# write file 
  syscall
  bltz $v0, errorWriting		# if syscall's v0 is -1 branch
  addi $sp, $sp, 3		# remove space on stack
  
  
  #########################     board contents     ################################
  

  
  rowLoop:	
    beq $s2, $s4, EVERYTHINGDONE		# row number = row counter
    
    colLoop:

      #######    PLACE THE VALUEEE   ######
     
 	li $t2, 0 
 	li $t3, 0
 	li $t0, 0 
 	lhu $t0, 0($s0)	# loads an individual number 
 	#move $s3, $t0		# col number saved on stack
						
	addi $sp, $sp, -5	# make space on stack
	li $t5, 0 		# counter for stack

	writeBoard:						### writes on the stack .. reverse...
	  li $t1, 10 	# divide by 10
 	  li $t2, 0	# sum reversed 
 
 	  div $t0, $t1 	# (18/10)			18 / 10 -> 1 R 8
	  mfhi $t3	# remainder from divison
 	  mflo $t4	# quoient from divison 
 	  addi $t2, $t3, 48	# t2 = t2 + remainder		48 + 8 =  56
 	  sb $t2, 0($sp)
 	  addi $t5, $t5, 1
 	  beqz $t4, WRITEBOARDNOW
 
 
 	div $t4, $t1
 	mfhi $t3		# remainder from divison
 	mflo $t4		# quoient from divison 
 	addi $t2, $t3, 48	# t2 = t2 + remainder		
 	sb $t2, 1($sp)
 	addi $t5, $t5, 1
 	beqz $t4, WRITEBOARDNOW
 
 	div $t4, $t1
 	mfhi $t3		# remainder from divison
 	mflo $t4		# quoient from divison 
 	addi $t2, $t3, 48	# t2 = t2 + remainder		
 	sb $t2, 1($sp)
 	addi $t5, $t5, 1
 	beqz $t4, WRITEBOARDNOW
 
 	div $t4, $t1
 	mfhi $t3		# remainder from divison
 	mflo $t4		# quoient from divison 
 	addi $t2, $t3, 48	# t2 = t2 + remainder		
 	sb $t2, 1($sp)
 	addi $t5, $t5, 1
 	beqz $t4, WRITEBOARDNOW
 
 	div $t4, $t1
 	mfhi $t3		# remainder from divison
 	mflo $t4		# quoient from divison 
 	addi $t2, $t3, 48	# t2 = t2 + remainder		
 	sb $t2, 2($sp)
 	addi $t5, $t5, 1	
 	beqz $t4, WRITEBOARDNOW					### done on the stack ...
 

 	WRITEBOARDNOW:
 	  addi $t5,$t5, -1		# stack start from 0 
 	  li $t6, 0							
 	  li $t7, 0 							
 										
	  add $t6, $t5, $sp
 	  lb $t7, 0($t6)			# load top of stack into t7
 
  	  addi $sp, $sp, -1
 	  sb $t7, 0($sp)		# save the ascii char value of int on the stack
	  move $a0, $s1			# file descriptor
	  move $a1, $sp 		# s0 -> a1
	  li $a2, 1
	  li $v0, 15			# write file 
	  bltz $v0, errorWriting		# if syscall's v0 is -1 branch
 	 syscall
  
	  addi $sp, $sp, 1 		# remove space on stack
	  beqz $t5, doneboard		# stack is empty then break out
	 j WRITEBOARDNOW
	 
	 
  
 	 doneboard:
  	    addi $sp, $sp, 5	# make space on stack
  
  	    blt $s5, $s3, branch2	# col counter is less than col number
      
       ################################    insert new lineeeee  ####################
        addi $sp, $sp, -4
        addi $s0, $s0, 2	# to go to next number
  	li $t8, 0x0a		# newline
  	sb $t8, 0($sp)	# store space on stack
  	move $a0, $s1			# file descriptor
  	move $a1, $sp 		# s0 -> a1
  	li $a2, 1
  	li $v0, 15			# write file 
  	syscall
  	bltz $v0, errorWriting		# if syscall's v0 is -1 branch
  	addi $sp, $sp, 4
       ################################    insert new lineeeee doneee  ####################
       
      beq $s3, $s5, rowIncrement	# col number = col counter... 
      
      branch2:
       ################################    insert spaceee  ####################
   	addi $sp, $sp, -4
   	addi $s0, $s0, 2	# to go to next number
  	li $t8, 0x20		# space
  	sb $t8, 0($sp)	# store space on stack
  	move $a0, $s1			# file descriptor
  	move $a1, $sp 		# s0 -> a1
  	li $a2, 1
  	li $v0, 15			# write file 
  	syscall
  	bltz $v0, errorWriting		# if syscall's v0 is -1 branch
  	
  	addi $sp, $sp, 4
       ################################    insert space doneee  ####################
       
       addi $s5,$s5, 1	# col ++
       j colLoop
      
    rowIncrement:
    li $s5, 1		# reinitialize col counter
    addi $s4, $s4, 1	# row ++
   j rowLoop		# go to next row
    
    
    
  EVERYTHINGDONE:




################# close file
    move $a0, $s1			# original v0 value into a0
    li $v0, 16
    syscall  
################# 
li $v0, 0		# file success written
j restore

errorWriting:
li $v0, -1		# file failed writing
j restore



restore:
  lw $s0, 0($sp)	
  lw $s1, 4($sp)	
  lw $s2, 8($sp)		
  lw $s3, 12($sp)	
  lw $s4, 16($sp)
  lw $s5, 20($sp)	
  addi $sp, $sp, 24
  
jr $ra


# Part 3
get_tile:
   addi $sp, $sp, -12		
   sw $s0, 0($sp) 		# board
   sw $s1, 4($sp) 		# row
   sw $s2, 8($sp) 		# col

    move $s0, $a0 		# board address
    move $s1, $a1 		# $s1 = row position that we want 		7
    move $s2, $a2 		# $s2 = column position that we want		6
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	8
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board	7

    beq $s1, $t1,rowOrColERROR		# row we want = actual rows (rows - 1)... out of bound
    beq $s2, $t2,rowOrColERROR		# col we want = actual col (col - 1)... out of bound
    bltz $s1, rowOrColERROR 		# row position we want is less than 0
    bltz $s2, rowOrColERROR	 	# col position we want is less than 0
    blt $t1, $s1, rowOrColERROR		# number of rows on the board is less than row number
    blt $t2, $s2, rowOrColERROR		# number of col on the board is less than cpol number
   
    addi $s0, $s0, 2		# offset memory game board address to skip row and col numbers
   
    mul $t4, $s1, $t2		# t4 = (row number we want) * (actual number of col) ... 2 * 7
    add $t4, $t4, $s2		# t4 = t4 + (col position we want)
    li $t9, 2		
    mul $t4, $t4, $t9 		# times 2 
    add $s0, $s0, $t4		# s0 = (game board memory address) + t4		... offset game board
   
    lhu $t5, 0($s0)
    move $v0, $t5
    j restoringPart3

rowOrColERROR:
    li $t5, -1
    li $v0, -1

restoringPart3:
    lw $s0, 0($sp) 	
    lw $s1, 4($sp) 	
    lw $s2, 8($sp) 
    addi $sp, $sp, 12 
jr $ra


# Part 4
set_tile:
    addi $sp, $sp, -16 
    sw $s0, 0($sp) 
    sw $s1, 4($sp) 
    sw $s2, 8($sp) 
    sw $s3, 12($sp) 

    move $s0, $a0 		# board
    move $s1, $a1 		# row 
    move $s2, $a2 		# col
    move $s3, $a3 		# value
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	8
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board	7
    
    li $t9, 49152		# highest possible value tile for the game
    
    beq $s1, $t1,rowOrColERROR		# row we want = actual rows (rows - 1)... out of bound
    beq $s2, $t2,rowOrColERROR		# col we want = actual col (col - 1)... out of bound
    bltz $s3, rowOrColERRORinPart4		# value is less than 0 
    bgt $s3, $t9, rowOrColERRORinPart4		# value is greater than highest tile value 
    bltz $s1, rowOrColERRORinPart4 		# row position we want is less than 0
    bltz $s2, rowOrColERRORinPart4 	 	# col position we want is less than 0
    blt $t1, $s1, rowOrColERRORinPart4		# number of rows on the board is less than row number
    blt $t2, $s2, rowOrColERRORinPart4		# number of col on the board is less than cpol number
  
    addi $s0, $s0, 2		# offset memory game board address to skip row and col numbers
    
    mul $t4, $s1, $t2		# t4 = (row number we want) * (actual number of col) ... 2 * 7
    add $t4, $t4, $s2		# t4 = t4 + (col position we want)
    li $t9, 2		
    mul $t4, $t4, $t9 		# times 2 
    add $s0, $s0, $t4		# s0 = (game board memory address) + t4		... offset game board
	
    sh $s3, 0($s0)
    
    lhu $t5, 0($s0)
    move $v0, $t5
   j restoringPart4
    
    rowOrColERRORinPart4:
     li $t5, -1
     li $v0, -1
   
restoringPart4:
    lw $s0, 0($sp) 	
    lw $s1, 4($sp) 	
    lw $s2, 8($sp) 
    lw $s3, 12($sp) 
    addi $sp, $sp, 16 
jr $ra


# Part 5
can_be_merged:
   lw $t3, 0($sp)			# loads col2 from stack and saves into t3
   
   addi $sp, $sp, -32
   sw $ra, 0($sp)		# return address			
   sw $s0, 4($sp) 		
   sw $s1, 8($sp) 		
   sw $s2, 12($sp)
   sw $s3, 16($sp)
   sw $s4, 20($sp)
   sw $s5, 24($sp)		# jal return value first time
   sw $s6, 28($sp)		# jal return value first time
 
   move $s0, $a0		# board
   move $s1, $a1		# row 1
   move $s2, $a2 		# col 1
   move $s3, $a3 		# row 2
   move $s4, $t3 		# col 2
   
   li $s5, 0			# instantiate s5
   li $s6, 0			# instantiate s6
   
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board	

	############################ basic conditions ############################
	
    beq $s1, $t1,rowOrColERRORinPart5		# row we want = actual rows (rows - 1)... out of bound
    beq $s2, $t2,rowOrColERRORinPart5		# col we want = actual col (col - 1)... out of bound
    beq $s3, $t1,rowOrColERRORinPart5		# row we want = actual rows (rows - 1)... out of bound
    beq $s4, $t2,rowOrColERRORinPart5		# col we want = actual col (col - 1)... out of bound
    
    bltz $s1, rowOrColERRORinPart5 		# row1 position we want is less than 0
    bltz $s2, rowOrColERRORinPart5	 	# col1 position we want is less than 0
    bltz $s3, rowOrColERRORinPart5 		# row2 position we want is less than 0
    bltz $s4, rowOrColERRORinPart5	 	# col2 position we want is less than 0
    
    blt $t1, $s1, rowOrColERRORinPart5		# number of rows on the board is less than row number
    blt $t2, $s2, rowOrColERRORinPart5		# number of col on the board is less than col number
    blt $t1, $s3, rowOrColERRORinPart5		# number of rows on the board is less than row number
    blt $t2, $s4, rowOrColERRORinPart5		# number of col on the board is less than col number
    
	##########################################################################
	
	
	############################ adjacent conditions #########################
	beq $s1, $s3, rowISTHESAME		# row 1 == row 2
	beq $s2, $s4, colISTHESAME		# col 1 == col 2
	
	rowISTHESAME:
	  beq $s2, $s4, rowOrColERRORinPart5		# col2 == col2... same tile for both
	  
	  bgt $s4,$s2, s4isbigger
	  bgt $s2,$s4, s2isbigger
	  s4isbigger:
	    addi $t8, $s2, 1			# t8 = s2 + 1  ... (col 1)  + 1 
	    bne $s4, $t8, rowOrColERRORinPart5	# (col 1 + 1) != (col 2)		condition c 
	    j conditonPassed
	  s2isbigger:
	    addi $t8, $s2, -1			# t8 = s2 - 1  ... (col 1)  - 1 
	    bne $s4, $t8, rowOrColERRORinPart5	# (col 1 - 1) != (col 2)		condition d
	    j conditonPassed
	
	colISTHESAME:
	  bgt $s1,$s3, s1isbigger
	  bgt $s3,$s1, s3isbigger
	  s1isbigger:
	    addi $t8, $s1, -1			# t8 = s1 - 1  ... (row 1)  - 1 
	    bne $s3, $t8, rowOrColERRORinPart5	# (row 1 - 1) != (row 2)		condition b
	    j conditonPassed
	  s3isbigger:
	    addi $t8, $s1, 1			# t8 = s1 + 1  ... (row 1)  + 1 
	    bne $s3, $t8, rowOrColERRORinPart5	# (row 1 + 1) != (row 2)		condition a
	    j conditonPassed
	
	
	##########################################################################
	
	conditonPassed:
	move $a0, $s0	# board
	move $a1, $s1	# row 1
	move $a2, $s2	# col 1 
	jal get_tile
	lw $a1, 8($sp)		# load original row
	lw $a2, 12($sp)		# load original col
	lw $a0, 4($sp)		# load original board
	move $s5, $v0	#save return in s6	
	
				
        move $a0, $s0	# board
        move $a1, $s3	# row 2
	move $a2, $s4	# col 2
	jal get_tile
	lw $a1, 8($sp)		# load original  row
	lw $a2, 12($sp)		# load original  col
	lw $a0, 4($sp)		# load original board		
   	move $s6, $v0	#save return in s6	
	
	
	li $t9, 1
	li $t1, 2
	li $t2, 3
	
	beq $t9, $s5, s5_is_ONE
	beq $t1, $s5, s5_is_TWO
	bge $s5, $t2, s5_is_ATLEAST_THREE
	
	s5_is_ONE:
	  beq $t1, $s6, possibleCombo	# s5 = 1, s6 = 2 ... 1 + 2 
	  j rowOrColERRORinPart5	# s6 is something else, throw error
	
	s5_is_TWO:
	  beq $t9, $s6, possibleCombo	# s5 = 2, s6 = 1 ... 2 + 1
	  j rowOrColERRORinPart5	# s6 is something else, throw error
	
	s5_is_ATLEAST_THREE:
	  blt $s6, $t2, rowOrColERRORinPart5	# s6 is less than 3, throw error .... 5 + 1 
	  beq $s5, $s6, possibleCombo		# s5 == s6,   x + x 
	  j rowOrColERRORinPart5		# s5 != s6
	
	
    possibleCombo:
	add $s6, $s5, $s6			# s6 = s5 + s6 ... s6 = return1 + return2
	move $v0, $s6
   j restoringPart5
   
    
    rowOrColERRORinPart5:
     li $s6, -1
     li $v0, -1
   
restoringPart5:
   lw $ra, 0($sp)				
   lw $s0, 4($sp) 		
   lw $s1, 8($sp) 		
   lw $s2, 12($sp)
   lw $s3, 16($sp)
   lw $s4, 20($sp)
   lw $s5, 24($sp)	
   lw $s6, 28($sp)	
   addi $sp, $sp, 32
jr $ra










# Part 6
slide_row:
   addi $sp, $sp, -40
   sw $s0, 4($sp)
   sw $s1, 8($sp)
   sw $s2, 12($sp)
   sw $s3, 16($sp)
   sw $ra, 20($sp)
   sw $s7, 24($sp)
   sw $s5, 28($sp)
   sw $s4, 32($sp)
   sw $s6, 36($sp)				
   
   move $s0, $a0		# board
   move $s1, $a1		# row
   move $s2, $a2 		# direction
   
    li $s3, 0			# instantiate s3
    li $s7, 0			# instantiate s7 ..... column counter
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board	

	############################ basic conditions ############################
	
    beq $s1, $t1,rowOrColERRORinPart6		# row we want = actual rows (rows - 1)... out of bound
    bltz $s1, rowOrColERRORinPart6 		# row position we want is less than 0
    blt $t1, $s1, rowOrColERRORinPart6		# number of rows on the board is less than row number
   
    li $t3, -1
    li $t4, 1
    beq $s2, $t3, valid_DirectionLEFT		# direction is left
    beq $s2, $t4, valid_DirectionRIGHT		# direction is right
    j rowOrColERRORinPart6			# direction is 0, or another number
	##########################################################################

valid_DirectionLEFT:

    mergeFirst_or_ZeroFirst:
      li $t3, 0
      lbu $t2, 1($s0) 
      addi $t3, $t2, -1
      beq $t3, $s7, nomergeorzerofound
    
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      jal get_tile
      move $a0, $s0		# original board
      move $a1, $s1		# original row
      move $a2, $s2 		# originaldirection
      move $s3, $v0 		# return value from function in s3  
      beqz $s3, zeroTileFoundSETUP
      
  
	move $a0, $s0
	move $a1, $s1	# row 
	move $a2, $s7	# col 
	move $a3, $s1	# row
	addi $s6, $s7, 1	# column + 1 
	addi $sp, $sp, -4
	sw $s6, 0($sp)
	jal can_be_merged
	addi $sp, $sp, 4
        move $s3, $v0 		# return value from function in s3 
   	bgtz $s3, mergeComboFound
      addi $s7, $s7, 1		# column ++
    j mergeFirst_or_ZeroFirst


zeroTileFoundSETUP:
	li $t3, 0
	lbu $t2, 1($s0) 
	addi $t3, $t2, -1	# col - 1 
	
zeroTileFound:		#s7 -> col we're on rn 
      li $t3, 0
      lbu $t2, 1($s0) 
      addi $t3, $t2, -1
    beq $s7, $t3, hardCodeZero_inLastCOL
    addi $s7, $s7, 1	# next col number
    
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      jal get_tile
     
      addi $s7, $s7, -1 	# go back to real/orignal col
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    addi $s7, $s7, 1 	# col ++ next loop
   j zeroTileFound  
   
   hardCodeZero_inLastCOL:
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $zero	# return value from get_tile
      jal set_tile
      li $v0, 0
   j restoringPart6


mergeComboFound:	# s7 -> current col, s6 = col + 1
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      addi $s7, $s7, 1	# next col number
	
mergocomboShiftingLEFT:		#s7 -> col we're on rn 
li $t3, 0
lbu $t2, 1($s0) 		
addi $t3, $t2, -1	# col - 1 

    beq $s7, $t3, hardCodeZero_inLastCOL_1
    addi $s7, $s7, 1	# next col number
    
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col + 1
      jal get_tile
     
      addi $s7, $s7, -1 	# go back to real/orignal col
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    
    addi $s7, $s7, 1 	# col ++ next loop
  j mergocomboShiftingLEFT
   
   hardCodeZero_inLastCOL_1:
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $zero	# return value from get_tile
      jal set_tile
      li $v0, 1
   j restoringPart6

nomergeorzerofound:
    li $v0, 0
    j restoringPart6

########################################################

valid_DirectionRIGHT:
lbu $t2, 1($s0) 
addi $s7, $t2, -1	# last col - 1 

    mergeFirst_or_ZeroFirst_RIGHT:		# R -> L		s7 -> column counter
      beq $s7, $zero, nomergeorzerofound_right
    
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      jal get_tile
      move $a0, $s0		# original board
      move $a1, $s1		# original row
      move $a2, $s2 		# originaldirection
      move $s3, $v0 		# return value from function in s3  
      beqz $s3, zeroTileFoundSETUP_RIGHTT
      
      
	move $a0, $s0
	move $a1, $s1	# row 
	move $a2, $s7	# col 
	move $a3, $s1	# row
	addi $s6, $s7, -1	# column - 1 
	addi $sp, $sp, -4
	sw $s6, 0($sp)
	jal can_be_merged
	addi $sp, $sp, 4
        move $s3, $v0 		# return value from function in s3 
   	bgtz $s3, mergeComboFound_RIGHTT
      addi $s7, $s7, -1		# column --
    j mergeFirst_or_ZeroFirst_RIGHT


zeroTileFoundSETUP_RIGHTT:
	
zeroTileFound_RIGHT:		#s7 -> col we're on rn 
    beq $s7, $zero, hardCodeZero_inLastCOL_RIGHT
    addi $s7, $s7, -1	# next col number
    
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      jal get_tile
     
      addi $s7, $s7, 1 	# go back to real/orignal col
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    addi $s7, $s7, -1 	# col -- next loop
   j zeroTileFound_RIGHT  
   
   hardCodeZero_inLastCOL_RIGHT:
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $zero	# col
      move $a3, $zero	# return value from get_tile
      jal set_tile
      li $v0, 0
   j restoringPart6


mergeComboFound_RIGHTT:	# s7 -> current col, s6 = col - 1
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $s3	# return value from can_merge
      jal set_tile
      addi $s7, $s7, -1	# next col number

	
mergocomboShiftingRIGHTTTTTT:		#s7 -> col we're on rn 
    beq $s7, $zero, hardCodeZero_inLastCOL_RTTTTT
    addi $s7, $s7, -1	# next col number
    
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col - 1
      jal get_tile
     
      addi $s7, $s7, 1 	# go back to real/orignal col
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $s7	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    
    addi $s7, $s7, -1 	# col ++ next loop
   j mergocomboShiftingRIGHTTTTTT  
   
   hardCodeZero_inLastCOL_RTTTTT:
      move $a0, $s0	# board
      move $a1, $s1	# row
      move $a2, $zero	# col
      move $a3, $zero	# hard code 0 
      jal set_tile
      li $v0, 1
   j restoringPart6


nomergeorzerofound_right:
    li $v0, 0
    j restoringPart6


rowOrColERRORinPart6:
   li $v0, -1
   j restoringPart6
   
 
restoringPart6:
   lw $s0, 4($sp)
   lw $s1, 8($sp)
   lw $s2, 12($sp)
   lw $s3, 16($sp)
   lw $ra, 20($sp)
   lw $s7, 24($sp)
   lw $s5, 28($sp)
   lw $s4, 32($sp)
   lw $s6, 36($sp)				
   addi $sp, $sp, 40
jr $ra





# Part 7
slide_col:
   addi $sp, $sp, -40
   sw $s0, 4($sp)
   sw $s1, 8($sp)
   sw $s2, 12($sp)
   sw $s3, 16($sp)
   sw $ra, 20($sp)
   sw $s7, 24($sp)
   sw $s5, 28($sp)
   sw $s4, 32($sp)
   sw $s6, 36($sp)				
   
   move $s0, $a0		# board
   move $s1, $a1		# col
   move $s2, $a2 		# direction
   
    li $s3, 0			# instantiate s3
    li $s7, 0			# instantiate s7 ..... row counter
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board	

	############################ basic conditions ############################
	
    beq $s1, $t2,rowOrColERRORinPart7		# row we want = actual rows (rows - 1)... out of bound
    bltz $s1, rowOrColERRORinPart7		# row position we want is less than 0
    blt $t2, $s1, rowOrColERRORinPart7		# number of rows on the board is less than row number
   
    li $t3, -1
    li $t4, 1
    beq $s2, $t3, valid_DirectionUP		# direction is up
    beq $s2, $t4, valid_DirectionDOWN		# direction is down
    j rowOrColERRORinPart7			# direction is 0, or another number
	##########################################################################

valid_DirectionUP:	# direction is -1

 mergeFirst_or_ZeroFirst_UPPPPPP:
      li $t3, 0
      lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
      addi $t3, $t1, -1
      beq $t3, $s7, nomergeorzerofound_UP
    
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      jal get_tile
      move $a0, $s0		# original board
      move $a1, $s1		# original col
      move $a2, $s2 		# original direction
      move $s3, $v0 		# return value from function in s3  
      beqz $s3, zeroTileFoundSETUP_UP
      
  
	move $a0, $s0
	move $a1, $s7	# row 
	move $a2, $s1	# col
	addi $s6, $s7, 1	# row + 1 
	move $a3, $s6	# (row + 1)
	addi $sp, $sp, -4
	sw $s7, 0($sp)	# col
	jal can_be_merged
	addi $sp, $sp, 4
        move $s3, $v0 		# return value from function in s3 
   	bgtz $s3, mergeComboFound_UP
      addi $s7, $s7, 1		# row ++
    j mergeFirst_or_ZeroFirst_UPPPPPP


zeroTileFoundSETUP_UP:
	li $t3, 0
        lbu $t1, 0($s0) 	
	addi $t3, $t1, -1	# row - 1 
	
zeroTileFound_UP:		#s7 -> col we're on rn 
     li $t3, 0
     lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
     addi $t3, $t1, -1	# row - 1 
     
    beq $s7, $t3, hardCodeZero_inLastROWWW
    addi $s7, $s7, 1	# next row number
    
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      jal get_tile
     
      addi $s7, $s7, -1 	# go back to real/orignal col
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    addi $s7, $s7, 1 	# row ++ next loop
   j zeroTileFound_UP  
   
   hardCodeZero_inLastROWWW:
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $zero	# hard codes 0 into last row
      jal set_tile
     li $v0, 0
   j restoringPart7


mergeComboFound_UP:	# s7 -> current row, s6 = row + 1
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      addi $s7, $s7, 1	# next row number
	
mergocomboShiftingUPPPP:		#s7 -> col we're on rn 
li $t3, 0
      lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
addi $t3, $t1, -1	# row - 1 

    beq $s7, $t3, hardCodeZero_inLastROW_1
    addi $s7, $s7, 1	# next row number
    
      move $a0, $s0	# board
      move $a1, $s7	# row + 1
      move $a2, $s1	# col
      jal get_tile
     
      addi $s7, $s7, -1 	# go back to real/orignal row
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    addi $s7, $s7, 1 	# row ++ next loop
  j mergocomboShiftingUPPPP
   
   
   hardCodeZero_inLastROW_1:
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $zero	# hard code 0 in last row 
      jal set_tile
      li $v0, 1
   j restoringPart7

nomergeorzerofound_UP:
    li $v0, 0
    j restoringPart7

########################################################
########################################################
########################################################

valid_DirectionDOWN:	# direction is 1
lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
addi $s7, $t1, -1	# last row - 1 

mergeFirst_or_ZeroFirst_DOWNNNN:
    #  li $t3, 0
    #  lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
    #  addi $t3, $t1, -1
      beqz $s7, nomergeorzerofound_DOWN
    
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      jal get_tile
      move $a0, $s0		# original board
      move $a1, $s1		# original col
      move $a2, $s2 		# original direction
      move $s3, $v0 		# return value from function in s3  
      beqz $s3, zeroTileFoundSETUP_DOWN
  
	move $a0, $s0
	move $a1, $s7	# row 
	move $a2, $s1	# col
	addi $s6, $s7, -1	# row - 1 
	move $a3, $s6	# (row - 1)
	addi $sp, $sp, -4
	sw $s1, 0($sp)	# col
	jal can_be_merged
	addi $sp, $sp, 4
        move $s3, $v0 		# return value from function in s3 
   	bgtz $s3, mergeComboFound_DOWNNNNNNN
      addi $s7, $s7, -1		# row --
    j mergeFirst_or_ZeroFirst_DOWNNNN


zeroTileFoundSETUP_DOWN:
	#li $t3, 0
	#addi $t3, $t1, -1	# row - 1 
	
zeroTileFound_DOWN:		#s7 -> col we're on rn 
    # li $t3, 0
    # lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
    # addi $t3, $t1, -1	# row - 1 
     
    beqz $s7, hardCodeZero_inLastROWWW123
    addi $s7, $s7, -1	# next row number
    
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      jal get_tile
     
      addi $s7, $s7, 1 	# go back to real/orignal col
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    addi $s7, $s7, -1 	# row -- next loop
   j zeroTileFound_DOWN  
   
   hardCodeZero_inLastROWWW123:
      move $a0, $s0	# board
      #lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
      # addi $s7, $t1, -1	# last row - 1 
      move $a1, $zero	# first row
      move $a2, $s1	# col
      move $a3, $zero	# hard codes 0 into first row
      jal set_tile
    li $v0, 0
   j restoringPart7


mergeComboFound_DOWNNNNNNN:	# s7 -> current row, s6 = row + 1
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      addi $s7, $s7, -1	# next row number
	
mergocomboShiftingDOWNNN:		#s7 -> col we're on rn 
#li $t3, 0
#lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board
#addi $t3, $t1, -1	# row - 1 

    beqz $s7, hardCodeZero_inLastROW_2
    addi $s7, $s7, -1	# next row number
    
      move $a0, $s0	# board
      move $a1, $s7	# row - 1
      move $a2, $s1	# col
      jal get_tile
     
      addi $s7, $s7, 1 	# go back to real/orignal row
      move $a0, $s0	# board
      move $a1, $s7	# row
      move $a2, $s1	# col
      move $a3, $v0	# return value from get_tile
      jal set_tile
      
    addi $s7, $s7, -1 	# row -- next loop
  j mergocomboShiftingDOWNNN
   
   
   hardCodeZero_inLastROW_2:
      move $a0, $s0	# board
      move $a1, $zero	# row
      move $a2, $s1	# col
      move $a3, $zero	# hard code 0 in last row 
      jal set_tile
      li $v0, 1
   j restoringPart7

nomergeorzerofound_DOWN:
     li $v0, 0
    j restoringPart7


rowOrColERRORinPart7:
   li $v0, -1
   j restoringPart7
   
 
restoringPart7:
   lw $s0, 4($sp)
   lw $s1, 8($sp)
   lw $s2, 12($sp)
   lw $s3, 16($sp)
   lw $ra, 20($sp)
   lw $s7, 24($sp)
   lw $s5, 28($sp)
   lw $s4, 32($sp)
   lw $s6, 36($sp)				
   addi $sp, $sp, 40
jr $ra


# Part 8
slide_board_left:
   addi $sp, $sp, -16
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   sw $s2, 8($sp)
   sw $ra, 12($sp)
   
   move $s0, $a0		# board
 
    li $s1, 0			# instantiate s1 ... return value
    li $s2, 0			# row tracker 
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board

   doingworkforLEFT_SHIFT_ROW:
   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   beq $t1, $s2, donemovingEVERY_ROW_LEFT 	# all rows covered
   
	move $a0, $s0		# board
	move $a1, $s2		# row
	li $t9, -1
	move $a2, $t9		# direction is left 
        jal slide_row
        add $s1, $s1, $v0	# sum = sum + return value
   
      addi $s2, $s2, 1		# row ++
   j doingworkforLEFT_SHIFT_ROW

donemovingEVERY_ROW_LEFT:
move $v0, $s1			# sum of shifting is printed 
 
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   lw $s2, 8($sp)
   lw $ra, 12($sp)
   addi $sp, $sp, 16
jr $ra

# Part 9
slide_board_right:
   addi $sp, $sp, -16
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   sw $s2, 8($sp)
   sw $ra, 12($sp)
   
   move $s0, $a0		# board
 
    li $s1, 0			# instantiate s1 ... return value
    li $s2, 0			# row tracker 
    
   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board

    
   doingworkforRIGHT_SHIFT_ROW:
   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   beq $t1, $s2, donemovingEVERY_ROW_RIGHT 	# all rows covered
   
	move $a0, $s0		# board
	move $a1, $s2		# row
	li $t9, 1
	move $a2, $t9		# direction is right 
        jal slide_row
        add $s1, $s1, $v0	# sum = sum + return value
   
      addi $s2, $s2, 1		# row ++
      
   j doingworkforRIGHT_SHIFT_ROW

donemovingEVERY_ROW_RIGHT:
move $v0, $s1			# sum of shifting is printed 
 
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   lw $s2, 8($sp)
   lw $ra, 12($sp)
   addi $sp, $sp, 16
jr $ra






# Part 10
slide_board_up:
   addi $sp, $sp, -16
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   sw $s2, 8($sp)
   sw $ra, 12($sp)
   
   move $s0, $a0		# board
 
    li $s1, 0			# instantiate s1 ... return value
    li $s2, 0			# col tracker 
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board

   doingworkforUP_SHIFT_ROW:
   lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
   beq $t2, $s2, donemovingEVERY_ROW_UP 	# all col covered
   
	move $a0, $s0		# board
	move $a1, $s2		# col
	li $t9, -1
	move $a2, $t9		# direction is up 
        jal slide_col
        add $s1, $s1, $v0	# sum = sum + return value
   
      addi $s2, $s2, 1		# col ++
   j doingworkforUP_SHIFT_ROW

donemovingEVERY_ROW_UP:
move $v0, $s1			# sum of shifting is printed 
 
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   lw $s2, 8($sp)
   lw $ra, 12($sp)
   addi $sp, $sp, 16
jr $ra






# Part 11
slide_board_down:
   addi $sp, $sp, -16
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   sw $s2, 8($sp)
   sw $ra, 12($sp)
   
   move $s0, $a0		# board
 
    li $s1, 0			# instantiate s1 ... return value
    li $s2, 0			# col tracker 
    
    lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
    lbu $t2, 1($s0) 		# $t2 = actual number of col from the board

   doingworkforDOWN_SHIFT_ROW:
   lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
   beq $t2, $s2, donemovingEVERY_ROW_DOWN 	# all col covered
   
	move $a0, $s0		# board
	move $a1, $s2		# col
	li $t9, 1
	move $a2, $t9		# direction is down 
        jal slide_col
        add $s1, $s1, $v0	# sum = sum + return value
   
      addi $s2, $s2, 1		# col ++
   j doingworkforDOWN_SHIFT_ROW

donemovingEVERY_ROW_DOWN:
move $v0, $s1			# sum of shifting is printed 
 
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   lw $s2, 8($sp)
   lw $ra, 12($sp)
   addi $sp, $sp, 16
jr $ra






# Part 12
game_status:
   addi $sp, $sp, -36
   sw $ra, 24($sp)		# return address			
   sw $s0, 4($sp) 		# board
   sw $s1, 8($sp) 		# row counter	
   sw $s2, 12($sp)		# col counter	
   sw $s3, 16($sp) 		# actual number of rows
   sw $s4, 20($sp)		# actual number of col
   sw $s5, 28($sp)		# row movement
   sw $s6, 32($sp)		# col movement

   move $s0, $a0		# board
   li $s1, 0 			# row counter
   li $s2, 0			# column counter
   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   lbu $t2, 1($s0) 		# $t2 = actual number of col from the board


#############	FIND IF THE PLAYER HAS WON // HIGHEST TILE #########
   findingMax_ROW:
  	 lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
  	 lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
  	 beq $t1, $s1, checkfor_NOGAP_and_NOMERGE		# reached the last row
       
       findingMax_COL:
          lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   	  lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
          beq $s2, $t2, adding1toROw	# reached the last the col, now move to next row
          move $a0, $s0	# board
	  move $a1, $s1	# row counter 
	  move $a2, $s2 # col counter 
	  jal get_tile
	  li $t8, 49152		# winning number
	  beq $v0, $t8, PLAYERWON
	  addi $s2, $s2, 1	# column ++
	j findingMax_COL
     
     adding1toROw:
     	addi $s1, $s1, 1
        li $s2, 0			# reset column counter
    j findingMax_ROW

   PLAYERWON:
     li $v0, -2
     li $v1, -2
     j restoringPart12

#############	 #########

checkfor_NOGAP_and_NOMERGE:
   li $s1, 0 			# row counter
   li $s2, 0			# column counter

  findingNonZeroInROW:
 	lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
  	lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
    	beq $t1, $s1, noMore_Gaps_or_merging		# reached the last row
       
       findingNonZeroInCOL:
          lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   	  lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
          beq $s2, $t2, movetonextroww	# reached the last the col, now move to next row
          move $a0, $s0	# board
	  move $a1, $s1	# row counter 
	  move $a2, $s2 # col counter 
	  jal get_tile
	  beqz $v0, sumOF_ROW_and_COL_Shifting			# found tile with a zero
	  	
	  move $a0, $s0	# board
	  move $a1, $s1	# row 1
	  move $a2, $s2	# col 1
	  move $a3, $s1	# row 1
	  move $t4, $s2		# t4 = col 1
	  addi $t4, $t4, 1	# col 1 + 1 = col2
	  addi $sp,$sp, -4
	  sw $t4, 0($sp) # col 2
	  jal can_be_merged
	  lw $t4, 0($sp)
	  addi $sp,$sp, 4	 
	  bgtz $v0, sumOF_ROW_and_COL_Shifting	# return value from the funciton is at least 0 meaning merge is possible	
	  addi $s2, $s2, 1	# column ++
	j findingNonZeroInCOL
     
      movetonextroww:
     	addi $s1, $s1, 1
        li $s2, 0			# reset column counter
    j findingNonZeroInROW

   noMore_Gaps_or_merging:
     li $v0, -1
     li $v1, -1
     j restoringPart12




########################################################################################################
########################################################################################################

sumOF_ROW_and_COL_Shifting:
   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
   li $s5, 0 			# instantiate row counter 
   li $s6, 0 			# instantiate col counter 
   
   li $s3, 0	# row sum
   li $s4, 0	# col sum
	
	checkingTHE_ROW_FOR_COMBO_SUM:
   	  lbu $t1, 0($s0) 				# $t1 = actual number of rows from the board
	  beq $t1, $s5, checkingTHE_COL_FOR_COMBO_SUM	# reaches the last row
	   li $s6, 0				# reset col
	
	col_plusplus:
	   lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
	   beq $t2, $s6, row_plusplus	# goes through all columns

           move $a0, $s0	# board
           move $a1, $s5	# row
           move $a2, $s6	# col
           jal get_tile
           beqz $v0, adder_FOR_ROW_TOTAL
	   
	   move $a0, $s0		# board
	   move $a1, $s5		# row 
	   move $a2, $s6		# col current
	   move $a3, $s5		# row
	   addi $t6, $s6, 1		# current column + 1 
	   addi $sp, $sp, -4
	   sw $t6, 0($sp)
	   jal can_be_merged
	   addi $sp, $sp, 4
   	   bgtz $v0, adder_FOR_ROW_TOTAL

           addi $s6, $s6, 1		# col ++
        j col_plusplus      
        
       row_plusplus: 
          addi $s5, $s5, 1		# row ++
          li $s6, 0			# reset col
      j checkingTHE_ROW_FOR_COMBO_SUM
	
	adder_FOR_ROW_TOTAL:
	   addi $s3, $s3, 1		# sum ++
	   addi $s5, $s5, 1		# row ++
	   li $s6, 0			# reset col
	j checkingTHE_ROW_FOR_COMBO_SUM

########################################################################
########################################################################

checkingTHE_COL_FOR_COMBO_SUM:
   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
   lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
   li $s5, 0 			# instantiate row counter 
   li $s6, 0 			# instantiate col counter 
   li $s4, 0	# col sum

checkingTHE_COL_FOR_COMBO_SUM_WORK:
   	  lbu $t2, 1($s0) 		# $t2 = actual number of col from the board
	  beq $t2, $s5, load_values	# reaches the last col
	  li $s6, 0				# reset row
	
	row_plusplus_111:
   	   lbu $t1, 0($s0) 		# $t1 = actual number of rows from the board	
	   beq $t1, $s6, col_plusplus_111	# goes through all rows
           move $a0, $s0	# board
           move $a1, $s6	# row
           move $a2, $s5	# col
           jal get_tile
           beqz $v0, adder_FOR_COL_TOTAL
	   move $a0, $s0		# board
	   move $a1, $s6		# current row 
	   move $a2, $s5		# col 
	   addi $t6, $s6, 1	
	   move $a3, $t6		# current row + 1
	   addi $sp, $sp, -4
	   sw $s5, 0($sp)		# col
	   jal can_be_merged
	   addi $sp, $sp, 4
   	   bgtz $v0, adder_FOR_COL_TOTAL
           addi $s6, $s6, 1		# row ++
        j row_plusplus_111      
        
       col_plusplus_111: 
          addi $s5, $s5, 1		# col ++
          li $s6, 0			# reset row
      j checkingTHE_COL_FOR_COMBO_SUM_WORK
	
	adder_FOR_COL_TOTAL:
	   addi $s4, $s4, 1		# sum ++
	   addi $s5, $s5, 1		# col ++
	   li $s6, 0			# reset col
	j checkingTHE_COL_FOR_COMBO_SUM_WORK
					
load_values:

	move $v0, $s3	# row sum
	move $v1, $s4	# col sum

  j restoringPart12
  
  
restoringPart12:
   lw $ra, 24($sp)				
   lw $s0, 4($sp) 		
   lw $s1, 8($sp) 		
   lw $s2, 12($sp)			
   lw $s3, 16($sp) 		
   lw $s4, 20($sp)	
   lw $s5, 28($sp)
   lw $s6, 32($sp)		
   addi $sp, $sp, 36
jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
