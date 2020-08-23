# Nitin Dev
# NDEV
# 112298641

.text
strlen: 			# part 1 # 
	
	li $t0, 0 	# counter variable
	charCounter:
		li $t1, 0			# initialize
		lbu $t1, 0($a0)			# load first character
		beqz $t1,charCounterFinished	# if next is null = break loop
		addi $t0,$t0,1
		addi $a0, $a0, 1		# increments pointer to next character
		j charCounter
	
	charCounterFinished:
		move $v0, $t0
     jr $ra
	j exit

insert:				# part 2 # 

	addi $sp, $sp, -4 		# allocates 4 bytes into the stack to preserve 
	sw $ra, 0($sp) 
	move $t8, $a0			# copy of a0
	li $t0, 0 			# counter variable
	li $t9, 0  			# length variable after insertion
	jal strlen
	move $a0, $t8			# reinitialize a0 to t8
	move $t0, $v0			# t0 holds the length of the string 
	bgt $a2, $t0, invalid		# if the index is greater than the str length  
	add $a0, $a0, $a2		# a1 is from the other file and is the index 
	move $t2, $a1			# copy of the char 
	
	shiftingLoop:
	lbu $t1, 0($a0)			# load the character with the offset from the previous lin 
	beqz $t1, oneLastLoop
	sb $t2, ($a0) 			# storing byte t2 ("X") into a0
	move $t2, $t1 			# replaces the value of t2, with t1
	addi $a0, $a0, 1		# increment
	j shiftingLoop			# loop back
		
	oneLastLoop:
	sb $t2, ($a0)			# last char
	sb $t1, 1($a0)			# null terminator 
	addi $t0, $t0, 1
	move $v0, $t0
	j skipinvalid
	
	invalid:
	li $v0, -1		# if the index is invalid it overrides t9 and saves its value as -1
	
	skipinvalid:
	lw $ra, 0($sp) 				# loads the stuff from the stack
	addi $sp, $sp, 4 		 	# frees up the previously allocated memory
	
	jr $ra
	j exit

pacman:				# part 3 # 

	addi $sp, $sp, -4 		# allocates 4 bytes into the stack to preserve 
	sw $ra, 0($sp) 
	move $t8, $a0			# copy of a0
	
	jal strlen			# string length counter 
	move $a0, $t8			# reinitialize a0 to t8
	move $s7, $v0			# t0 holds the length of the string 
	move $s4, $a0
	li $t4, 0			# is used to keep track of the index in the string. initialized to 0 
	
	loopThroughString:
	li $t9, 71	# G
	lbu $t1, 0($a0)			# load the character 
	beqz $t1,char_ISNOTFOUND	# if char is not there then break (sees a null)
	beq $t1, $t9, char_IsFound
	li $t9, 72	# H	
	beq $t1, $t9, char_IsFound
	li $t9, 79	# O
	beq $t1, $t9, char_IsFound
	li $t9, 83	# S
	beq $t1, $t9, char_IsFound
	li $t9, 84	# T
	beq $t1, $t9, char_IsFound
	
	li $t9, 103	# g
	beq $t1, $t9, char_IsFound
	li $t9, 104	# h
	beq $t1, $t9, char_IsFound
	li $t9, 111	# o
	beq $t1, $t9, char_IsFound
	li $t9, 115	# s
	beq $t1, $t9, char_IsFound
	li $t9, 116	# t
	beq $t1, $t9, char_IsFound
	
	addi $a0, $a0, 1		# increment to next character
	addi $t4, $t4, 1		# adds 1 to mark the increase of the index number
	j loopThroughString
	
	char_ISNOTFOUND:				
		move $s0, $a1 		# keeps a copy of the current a1 to s0  (ch)
		li $a1, '<'		# override a1 to be '<'
		move $s1, $a2		# keeps a copy of the current a2 to s1 (index)
		li $a2, 0		# override a1 to be index 0
		
		jal insert
		move $s5, $v0		# s5 has the legnth of the string after the '<' is inserted
		move $a1, $s0		# reinitialize a1 to orginal value
		move $a2, $s1		# reinitialize a2 to orginal value
		move $a0, $s4		# reinitialize a0 to orginal value
		move $v0, $s3		# reinitialize v0 to orginal value
		move $v0, $t4
		move $v1, $s7
		addi $v1,$v1,1
	j underline
	
	char_IsFound:			# if char is either GHOST or ghost
	beqz $t4, charFoundAtIndexZero	# index = 0 .... zero index (first letter)
	addi $t4,$t4,-1
	add $a0,$t4,$s4
	li $t9, '<'
	sb $t9, ($a0)
	j skipZeroIndex
	
	charFoundAtIndexZero:	# if the char is first element in the string (index 0) then we add one to the string length
		addi $t0,$t0, 1		# length += 1
		move $s0, $a1 		# keeps a copy of the current a1 to s0  (ch)
		li $a1, '<'		# override a1 to be '<'
		move $s1, $a2		# keeps a copy of the current a2 to s1 (index)
		#move $s2, $a0		# keeps a copy of the current a2 to s1	(str)
		li $a2, 0		# override a1 to be index 0
		
		jal insert
		move $s5, $v0		# s5 has the legnth of the string after the '<' is inserted
		move $a1, $s0		# reinitialize a1 to orginal value
		move $a2, $s1		# reinitialize a2 to orginal value
		move $a0, $s4		# reinitialize a0 to orginal value
		move $v0, $s3		# reinitialize v0 to orginal value

	move $v0, $t4
	move $v1, $s7
	addi $v1,$v1,1
	j doneunderline
	
	skipZeroIndex:
	move $a0, $s4
	move $v0, $t4
	move $v1, $s7
	
	underline:
		li $t2, '<'
		li $t3, '_'
		lbu $t1, 0($a0)			# load first character
		beq $t1, $t2, doneunderline
		sb $t3, ($a0) 
		addi $a0, $a0, 1		# increments pointer to next character
		j underline
	doneunderline:
	
	lw $ra, 0($sp) 				# loads the stuff from the stack
	addi $sp, $sp, 4 		 	# frees up the previously allocated memory
	jr $ra
	j exit


replace_first_pair:		# part 4 #
	li $s0, 0 			# index counter
	lw $s0, ($sp)			# loads s0 from stack
	add $a0, $a0, $s0		# adds the start index value to a0 which becomes the offset amount

	goingThroughString:
	lbu $s2, 0($a0)			# load the first char 	(pair)
	lbu $s3, 1($a0)			# load the second char (pair)
	beqz $s3, noInstanceFound	# if second char is null then break
	beq $s2, $a1, firstCharMatch	# first char in string = first letter in main
	j skipFirstCharMatch		# first char in string != first letter in main then skip over 

	firstCharMatch:			# check if the second char in string = second letter in main
		beq $s3, $a2, pairFound

	skipFirstCharMatch:
	addi $a0, $a0, 1		# increment to next character
	addi $s0, $s0, 1		# increment index counter 
	j goingThroughString

	noInstanceFound:
		li $v0, -1	# set the return value to -1 
		j part4Done	# to skip over pair_IsFound 

	pairFound:
	move $v0, $s0		# set the return value to the index value
	sb $a3, 0($a0)		# replaces the first letter to replaced by the replacement char		

	shiftLeft:
	lbu $s3, 2($a0)			# load the second char in updated str
	beqz $s3, removeDuplicateLastLetter		# if second char is null then break
	sb $s3, 1($a0)
	addi $a0, $a0, 1		# increment to next character
	j shiftLeft

	removeDuplicateLastLetter:
	li $s2, '\0'
	sb $s2, 1($a0)

	part4Done:
	jr $ra
	j exit


replace_all_pairs:		# part 5 # 
	addi $sp, $sp, -12 		# allocates 4 bytes into the stack to preserve 
	sw $ra, 8($sp) 
	move $s0, $a0			# copy of the str is saved in s0
	li $t9, 0		# counter for how many replacements were done
	li $t0, 0 			# loads 0 as the starting index
	
	replacingLoop:
		sw $t0, 0($sp)
		sw $a0, 4($sp) 
		jal replace_first_pair	

		lw $a0, 4($sp)
		move $t0, $v0
		li $t2, -1
		beq $t0, $t2, doneReplacing	# if the return from part 4 is (-1) == -1, then break
		addi $t9,$t9,1			# increments replacement counter
		addi $t0,$t0,1
		j replacingLoop

	doneReplacing:
	move $v0, $t9			# puts the number of replacements into v0
	lw $ra, 8($sp) 				# loads the stuff from the stack
	addi $sp, $sp, 12		 	# frees up the previously allocated memory

	jr $ra
	j exit
	
	
	
	
	
bytepair_encode:		# part 6 #

   addi $sp, $sp, -20	# allocate space for stack
   sw $a1, 0($sp)		# save freq into stack
   sw $a2, 4($sp)		# save replacements into stack 
   sw $s7, 8($sp)
   sw $ra, 12($sp)
   sw $a0, 16($sp)
   li $t0, 52		# size of replacements (52)
   li $t1, 0		# counter for loop
   li $t2, '\0'
   move $s0, $a0	# original string
   move $s1, $a1	# original frequency 0th index pointer 
   move $s2, $a2	# original replacements 0th index pointer
     
   replacementsZero:
   beq $t0, $t1, frequenciesZero	# array is all zeroed out
   sb $t2, ($a2)  			# store null byte at the current byte 
   addi $t1,$t1, 1			# ++1 in loop counter 
   addi $a2, $a2, 1			# ++1 in memory address
   j replacementsZero
  
   frequenciesZero:
   li $t0, 676		# size of frequencies (676)
   li $t1, 0		# counter for loop is reset 
   move $s1, $a1
   
   frequenciesZero_loop:
   beq $t0, $t1, startAlgorithm		# array is all zeroed out
   sb $t2, ($s1)  			# store null byte at the current byte 
   addi $t1,$t1, 1			# ++1 in loop counter 
   addi $s1, $s1, 1			# ++1 in memory address
   j frequenciesZero_loop



startAlgorithm:
   li $s7, 0		# KEEPS TRACK OF HOW MANY TOTAL REPLACEMENTS WERE DONE
   li $s4, 90    	 # replacement char
   li $s5, 0
   
   loopforTWENTYSIXTtimes:
   li $s6, 26
   beq $s5, $s6, twentysixloopDONE
   addi $s5, $s5, 1	# do this for a total of 26 times  
   
   freqCountUpdate:
   	li $t2, 97
   	lw  $a1,0($sp)			#orignal pointer to frequency
	lbu $t0, 0($a0)			# load the first letter
	lbu $t1, 1($a0)			# load the second letter
	
   	beqz $t1, freqCountUpdateDONE

   	addi $t0, $t0, -97		# get the 0-25 value of first lower case letter 
   	addi $t1, $t1, -97		# get the 0-25 value of second lower case letter 	
 	li $t4, 26			# t4 = numbers of letter in the alphabet
	
	mul $t5, $t0, $t4		# (26 * letter) = t5
	add $t6, $t5, $t1		# (26 * letter) + second letter = t6
	
	
	add $a1, $a1, $t6		# adds t6 value to the adress of the frequency to get to that location 
	lbu $t7, ($a1)			# loads the value from the freq into t7
	addi $t7,$t7, 1			# +1 to the current value in the freq
	sb $t7, ($a1) 			# save updated value to freq
	addi $a0, $a0, 1		# string ++
	j freqCountUpdate

freqCountUpdateDONE:
   li $t0, 676		# size of frequencies (676)
   li $t1, 0		# counter for loop is reset
   addi $t1, $a1, 676	# adds 676 to the freq array address
   li $t9, 0 				# saves the highest value of the freq
   lw $a1,0($sp)			# orignal pointer to frequency
   li $t8, -1
   li $t7, 0

   findHighestFreqCount:
        lbu $t3, ($a1)				# save the value of the freq from the array into t3
 	addi $t8, $t8, 1	# keeps track of the arr				
 	addi $a1, $a1, 1 	# ++ to freq

 	ble $t0, $t8, findHighestFreqCountDONE	
 	bgt $t3, $t9, higherFreqFOUND			# current t3 > old t9	
       	j findHighestFreqCount
       
       	higherFreqFOUND:
       		move $t9, $t3	# keep updating t9 with the highest value from freq
       		move $t7, $t8	# t7 has the reference of where the highest freq pair is located
       	         j findHighestFreqCount	# go back last function
       	
    findHighestFreqCountDONE:
        li $t9, 0	# sets the t9 to 0
        li $t6, 26 	# used for the divide by 26 formula
        lw $a1,0($sp)			# orignal pointer to frequency
        add $a1, $a1, $t7		# gets the posi
   	sb $t9, ($a1)	# overrides the current al1 with 0
    	div $t7, $t6		# divide the t7 (posiiton) by 26 
    	mflo $t4		# whole number
    	mfhi $t5		# remainder	### number = 26q + r --> numberLetter/26 = x.abcdefge	  			  		
        addi $a1, $t4, 0x61  # first char
        addi $a2, $t5, 0x61  # second char 
	lw $a0, 16($sp)
	move $a3, $s4

	jal replace_all_pairs
	
	lw $a1, 0($sp) # original freq
	lw $a2, 4($sp) # oringal replacement
    	add $s7, $s7, $v0 		# counter = counter + v0 
    	move $v0, $s7
    	
    					    				    			    				    # (v0 is the return value from the replace_all_pairs method)
addi $s4,$s4, -1 	# decrease Z -> Y -> X 	

    	j loopforTWENTYSIXTtimes
    	
    	donewithFreq:

	LETTERISCAPITAL:
        addi $a0, $a0, 1		# skip over the capital letter
    	j loopforTWENTYSIXTtimes
    	
    	twentysixloopDONE:
    	lw $ra, 12($sp) 
    	addi $sp, $sp, 20
    	jr $ra
	j exit
	
	
	
	
replace_first_char:		# part 7 # 
	li $t3, 0 			# index counter
	lw $t3, ($sp)			# loads t3 from stack
	add $a0, $a0, $t3		# adds the start index value to a0 which becomes the offset amount

	traverseString:
	lbu $t0, 0($a0)			# load the first char 	(pair)
	beqz $t0, noCharFound	# if second char is null then break
	beq $t0, $a1, addPair	# first char in string = first letter in main
	addi $a0, $a0, 1		# increment to next character
	addi $t3, $t3, 1		# increment index counter 
	j traverseString

	noCharFound:
		li $v0, -1	# set the return value to -1 
		j part7Done	# to skip over pair_IsFound 

	addPair:
	move $v0, $t3		# set the return value to the index value 
	sb $a2, 0($a0)		# replaces with the first letter 
	li $t7, 0
	shiftRight:		# brings pointter to end of stirng
		lbu $t9, 1($a0)
		beqz $t9, adding
		addi $a0, $a0, 1		# increment to next character
		addi $t7,$t7, 1
		j shiftRight
	
	adding:
	addi $a0, $a0, 1
	add $t7,$t7,$t3
	move $t6, $t7 		# str length

	endofString:
		lbu $t9, 0($a0)
		sb $t9, 1($a0)
		beq $t7, $t3, addingsecChar
		addi $a0, $a0, -1
		addi $t7,$t7,-1
		j endofString

	addingsecChar:
		sb $a3, 0($a0)
	part7Done:
	jr $ra
	j exit
	
	
replace_all_chars:		# part 8 # 
	addi $sp, $sp, -12 		# allocates 4 bytes into the stack to preserve 
	sw $ra, 8($sp) 
	move $s0, $a0			# copy of the str is saved in s0
	li $s2, 0		# counter for how many replacements were done
	li $s1, 0 			# loads 0 as the starting index
	
	loopReplace:
		sw $s1, 0($sp)
		sw $a0, 4($sp) 
		jal replace_first_char	

		lw $a0, 4($sp)
		move $s1, $v0
		li $t2, -1
		beq $s1, $t2, finishedReplace	# if the return from part 4 is (-1) == -1, then break
		addi $s2,$s2,1			# increments replacement counter
		addi $s1,$s1,1
		j loopReplace

	finishedReplace:
	move $v0, $s2			# puts the number of replacements into v0
	lw $ra, 8($sp) 				# loads the stuff from the stack
	addi $sp, $sp, 12		 	# frees up the previously allocated memory

	jr $ra
	j exit
	

bytepair_decode:		# part 9 #  
   li $t9, 0 
   li $t8, 65
   li $t7, 90
   move $s0, $a0
   
   loopthrough:
   lbu $t0, 0($a0)			# load the replacements array 
   beqz $t0, loopthroughdone		# array is all zeroed out
   addi $a0, $a0, 1 
   bge $t0, $t8, condition1
   j loopthrough

    condition1:
    ble $t0, $t7, returnadd1
    j loopthrough
    
    returnadd1:
    addi $t9, $t9, 1
    j loopthrough
    
    loopthroughdone:
    	move $s6,$t9	
	move $a0, $s0
   addi $sp, $sp, -20	# allocate space for stack
   sw $a0, 0($sp)		# save original string into stack
   sw $ra, 8($sp)
   li $s0, 0	# replacements counter 
   sw $s0, 12($sp)
   sw $s1, 16 ($sp)
   addi $a1, $a1, 50	#skips this many spaces for the address for replacements array
   sw $a1, 4($sp)   		# save replacements into stack
   li $s7, 'Z'		
 
LetterFind:
	lbu $t0, 0($a1) 	# first letter
	lbu $t1, 1($a1)		# second letter

	beqz $t0, LetterFindDONE
	beqz $t1, LetterFindDONE

	move $a2, $t0	# first replacement
	move $a3, $t1	# second repacement
	move $a1, $s7	# letter going to be replaced
	jal replace_all_chars
	
  	lw $a1, 4($sp) 
  	lw $s0, 12($sp)
   	lw $s1, 16 ($sp)
	addi $s7, $s7, -1	# Z -> Y -> X
	addi $a1, $a1, -2	# REPLACEMENTS ++
	addi $s0, $s0, 1	# counter ++
	sw $s0, 12($sp)		# save v0/counter to stack
	sw $a1, 4($sp)   		# save replacements into stack
	j LetterFind


LetterFindDONE:
	move $v0, $s6
  	lw $ra, 8($sp) 
 	addi $sp, $sp, 20
  
    	jr $ra
    	j exit
    	

exit:
    li $v0, 10
    syscall
