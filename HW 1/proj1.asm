# Nitin Dev
# NDEV
# 112298641

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here
newline: .asciiz "\n"

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    								# Start the assignment by writing your code here
	##### PART 1 #####
	
	lw $s0, addr_arg0	#load the whole argument
	lb $t0, 0($s0)		# $t0 the first argument only
	li $t1, 66	# 66 is ascii for the letter B
	li $t2, 67	# 67 is ascii for the letter C
	li $t3, 68	# 68 is ascii for the letter D
	li $t4, 69	# 69 is ascii for the letter E
	lw $t5, num_args	# loads the nubmer of args in that line
	
	li $t6, '\0'	# stores a space into $t6
	lb $t7, 1($s0) # have an offset of 1 to store the next character using the whole argument
	bne $t6, $t7,errorOper # if the next character is not a space throw an error
	
	beq $t5, $zero, zero_args	# if number of arguments is 0, then print out no argument error print statement
	
	beq $t0, $t1,runB 	# if first argument is B, then go to label runB
	beq $t0, $t2,runC 	# if first argument is C, then go to label runC
	beq $t0, $t3,runD	# if first argument is D, then go to label runD
	beq $t0, $t4,runE	# if first argument is E, then go to label runE
	j errorOper	# if none above, then jump to error message
	
	runB:
	li $t6, 2	# load the number 2 to $t6
	bne $t5, $t6, errorArgs	# not equal to 2, then throw error 
	j part5
	
	runD:
	li $t6, 2	# load the number 2 to $t6
	bne $t5, $t6, errorArgs # not equal to 2, then throw error 
	j part2
	
	runC:
	li $t6, 4	# load the number 4 to $t6
	bne $t5, $t6, errorArgs	# not equal to 4, then throw error 
	j part4
	
	runE:
	li $t6, 5	# load the number 5 to $t6
	bne $t5, $t6, errorArgs	# not equal to 5, then throw error 
	j part3
	
	errorOper:
	la $a0, invalid_operation_error
	li $v0, 4
	syscall			# print out error message
	j exit			# exit the program
	
	errorArgs:
	la $a0, invalid_args_error
	li $v0, 4
	syscall			# print out error message
	j exit			# exit the program

	j exit




	##### PART 2 #####	
part2:
	lw $t0, addr_arg1			# load the second argument (arg1)
	
	lbu $t1, 0($t0)				# loads first character
	li $t2, '0'				# saves zero to t2
	bne $t1, $t2, errorArgs			# doesnt start with 0 then error
	lbu $t1, 1($t0)				# loads second character
	li $t2, 'x'				# saves "x" to t2
	bne $t1, $t2, errorArgs			# doesnt start with x then error
	
	li $t3, 0				# counter variable which starts from 0 for the number of characters in the argument
	li $t4, 48				# t4 -> 0 (the acceptable range for hex)
	li $t5, 70				# t5 -> F (the acceptable range for hex)
	li $t6, 57				# t6 -> 9 (the acceptable range for hex)
	li $t7, 65				# t7 -> A (the acceptable range for hex)
						# 65 - 70 (A-F)
						# 48 - 57 (0-9)
						
	loop:
		lbu $t1, 2($t0)			# loads third character
		beqz $t1,inBetweenDone		# if next character is a null terminator
		blt $t1, $t4, errorArgs 	# less than 48
		bgt $t1, $t5, errorArgs		# greater than 70
		
		bgt $t1, $t6, inBetween		# !more than 57
		cont:				# to pick up from where the letter loop
		addi $t0, $t0, 1		# increments pointer to next character
		addi $t3, $t3, 1 		# increments counter variable
		j loop				# loop goes again
		
	inBetween:
		bge $t1,$t7, alphaGood 		#character is greater than 65 
		j errorArgs
								#ignoreee -> blt $t1, $t7, errorArgs		#!less than 65
	alphaGood:
		ble $t1,$t5,cont			# character is less than 70
		j errorArgs
	
	inBetweenDone:
	li $t7, 8				# overrides t7 with 8 to check for counter == 8
	bne $t3, $t7, errorArgs			# if the counter is not 8 then it throws error
	
	lw $t0, addr_arg1			# assings first letter back to t0
	
	li $t9,0	# final conversion register instantiated			
		
	charToValueLoop:
		lbu $t1, 2($t0)			# loads third character
		beqz $t1,mask		# if next character is a null terminator
		
		li $t6, 57			# t6 -> 9 (the acceptable range for hex)
							#li $t7, 65			# t7 -> A (the acceptable range for hex)	
		ble $t1,$t6, numberConvert	# if current ascii is less than 57 (9)
		addi $t1,$t1,-55		# converts letter 
		sll $t9,$t9,4 			# shift final left 4 
		add $t9, $t1, $t9		# t9 = t1 + t9 (final = temp + final)
		
		j numberConvertDone		# jumps the number convert label
		
		numberConvert:	
			addi $t1,$t1,-48	# converts the number
			sll $t9,$t9,4 			# shift final left 4 
			add $t9, $t1, $t9		# t9 = t1 + t9 (final = temp + final)
		numberConvertDone:
					
		addi $t0, $t0, 1		# increments pointer to next character
		j charToValueLoop		# charToValueLoop goes again
	
	mask:
	li $t0, 0xFC000000	# masking for 6
	li $t1, 0x03E00000 	# masking for 5
	li $t2, 0x001F0000 	# masking for 5
	li $t3, 0x0000FFFF 	# masking for 16
	
	charConvertDone:
	and $t0,$t9,$t0 		# mask and replace... first set (6)
	and $t1,$t9,$t1 		# mask and replace... second set (5)
	and $t2,$t9,$t2 		# mask and replace... third set (5)
	and $t3,$t9,$t3 		# mask and replace... fourth set (16)
	
	srl $t0,$t0, 26	# removes the trailing 0 			(ex: 001100...0000000000000000)
	srl $t1,$t1, 21	# removes the trailing 0
	srl $t2,$t2, 16	# removes the trailing 0
	srl $t3,$t3, 0	# removes the trailing 0

	sll $t3,$t3, 16	# this shift left to get the MSB
	sra $t3,$t3, 16 # this shift right to get the MSB filled up
	
	li $t5, 32	# saves an empty space

	li $v0,1
	move $a0, $t0 # print value
	syscall
	li $v0,11
	move $a0, $t5 # print space
	syscall
	li $v0,1
	move $a0, $t1 # print value
	syscall
	li $v0,11
	move $a0, $t5 # print space
	syscall
	li $v0,1
	move $a0, $t2 # print value
	syscall
	li $v0,11
	move $a0, $t5 # print space
	syscall
	li $v0,1
	move $a0, $t3 # print value
	syscall
	li $v0, 4
	la $a0, newline # print newline
	syscall
	j exit	



	##### PART 3 #####	
part3:
	
	# $s0 = first group
	# $s1 = second group
	# $s2 = third group
	# $s3 = fourth group
	
	
		lw $s4, addr_arg1			# load the whole argument
		lbu $t0, 0($s4)				# loads first byte in first group
		addi $t0,$t0,-48			# converts the number
		lbu $t1,1($s4) 				# load second byte in first group
		addi $t1,$t1,-48			# converts the number
		li $t2, 10				# save 10 to t2 which is used to find the tens place
		mul $t2, $t2, $t0 		 	# to get the tens place of the first byte (t2 = 10 * t0)
		add $s0, $t2, $t1			# t3 is the full value of the first group (t3 = t2 + t1) 
		
		
		lw $s5, addr_arg2			#load the whole argument
		lbu $t0, 0($s5)				# loads first byte in second group
		addi $t0,$t0,-48			# converts the number
		lbu $t1,1($s5) 				# load second byte in second group
		addi $t1,$t1,-48			# converts the number	
		li $t2, 10				# save 10 to t2 which is used to find the tens place
		mul $t2, $t2, $t0 			# to get the tens place of the first byte (t2 = 10 * t0)
		add $s1, $t2, $t1			# t3 is the full value of the second group (t4 = t2 + t1) 
		
		
		lw $s6, addr_arg3			#load the whole argument
		lbu $t0, 0($s6)				# loads first byte in third group
		addi $t0,$t0,-48			# converts the number
		lbu $t1,1($s6) 	 			# load second byte in third group
		addi $t1,$t1,-48			# converts the number
		li $t2, 10				# save 10 to t2 which is used to find the tens place
		mul $t2, $t2, $t0 			# to get the tens place of the first byte (t2 = 10 * t0)
		add $s2, $t2, $t1			# t3 is the full value of the third group (t5 = t2 + t1) 
		
		
		lw $s7, addr_arg4			#load the whole argument
		lbu $t0, 0($s7)				# loads first byte in fourth group (ten thousandsth)
		li $t1,'-'				# sets t1 to the ascii of '-'
		beq $t0,$t1,negative			# check to see if the first char is - or 0
		j positive				# if not '-' then go to positive
			
					
		negative:
		lbu $t0, 1($s7)				# loads first byte in fourth group (ten thousandsth)
		addi $t0,$t0,-48			# converts the number
		lbu $t1,2($s7) 				# load second byte in fourth group (thousandsth)
		addi $t1,$t1,-48			# converts the number
		lbu $t7,3($s7) 				# load third byte in fourth group (hunreds)
		addi $t7,$t7,-48			# converts the number
		lbu $t8,4($s7) 				# load fourth byte in fourth group (tens)
		addi $t8,$t8,-48			# converts the number
		lbu $t9,5($s7) 				# load fifth byte in fourth group (ones)
		addi $t9,$t9,-48			# converts the number
		li $t2, 10000				# save 10000 to t2 which is used to find the tens thousands place
		mul $t2, $t2, $t0 			# to get the tens thousands place of the first byte (t2 = 10000 * t0)
		li $t3, 1000				# save 1000 to t3 which is used to find the thousands place
		mul $t3, $t3, $t1 			# to get the tens thousands place of the first byte (t2 = 1000 * t0)
		li $t4, 100				# save 100 to t4 which is used to find the hundreds place
		mul $t4, $t4, $t7 			# to get the hundreds place of the first byte (t2 = 100 * t0)
		li $t5, 10				# save 10 to t5 which is used to find the tens place
		mul $t5, $t5, $t8 			# to get the tens place of the first byte (t2 = 10 * t0)
		add $s3, $t2, $t3 			# s3 = 10000 + 1000
		add $s3, $s3, $t4 			# s3 = s3 + 100
		add $s3, $s3, $t5 			# s3 = s3 + 10
		add $s3, $s3, $t9 			# s3 = s3 + 1
		li $t0,-1				# if it is negative then multiply it by -1 to get final answer as negative
		mul $s3, $s3, $t0
		j doneConvertingStringtoValue
		
		positive:
		addi $t0,$t0,-48			# converts the number
		lbu $t1,1($s7) 				# load second byte in fourth group (thousandsth)
		addi $t1,$t1,-48			# converts the number
		lbu $t7,2($s7) 				# load third byte in fourth group (hunreds)
		addi $t7,$t7,-48			# converts the number
		lbu $t8,3($s7) 				# load fourth byte in fourth group (tens)
		addi $t8,$t8,-48			# converts the number
		lbu $t9,4($s7) 				# load fifth byte in fourth group (ones)
		addi $t9,$t9,-48			# converts the number
		li $t2, 10000				# save 10000 to t2 which is used to find the tens thousands place
		mul $t2, $t2, $t0 			# to get the tens thousands place of the first byte (t2 = 10000 * t0)
		li $t3, 1000				# save 1000 to t3 which is used to find the thousands place
		mul $t3, $t3, $t1 			# to get the tens thousands place of the first byte (t2 = 1000 * t0)
		li $t4, 100				# save 100 to t4 which is used to find the hundreds place
		mul $t4, $t4, $t7 			# to get the hundreds place of the first byte (t2 = 100 * t0)
		li $t5, 10				# save 10 to t5 which is used to find the tens place
		mul $t5, $t5, $t8 			# to get the tens place of the first byte (t2 = 10 * t0)
		add $s3, $t2, $t3 			# s3 = 10000 + 1000
		add $s3, $s3, $t4 			# s3 = s3 + 100
		add $s3, $s3, $t5 			# s3 = s3 + 10
		add $s3, $s3, $t9 			# s3 = s3 + 1
		
		
		doneConvertingStringtoValue:
		
		li $t0, 0		# RANGES 
		li $t1, 63		# RANGES 
		li $t2, 31		# RANGES 
		li $t3, -32768		# RANGES 
		li $t4, 32767		# RANGES 
		
		
		bge $s0, $t0,INITIALconditionMet		# first group is greater than or equal to 0
		j errorArgs
		
		INITIALconditionMet:
			ble $s0, $t1,FIRSTconditionMet		# first group is less than or equal to 63
			j errorArgs
		
		FIRSTconditionMet:
			bge $s1, $t0,FIRSTconditionMetpt2	# second group is greater than or equal to 0
			j errorArgs
			FIRSTconditionMetpt2:
			ble $s1, $t2,SECONDconditionMet	# second group is less than or equal to 31
			j errorArgs			# if condition is not met then throw invalid args error 
		
		SECONDconditionMet:
			bge $s2, $t0,SECONDconditionMetpt2	# third group is greater than or equal to 0
			j errorArgs
			SECONDconditionMetpt2:
			ble $s2, $t2,THIRDconditionMet	# third group is less than or equal to 31
			j errorArgs			# if condition is not met then throw invalid args error 
		
		THIRDconditionMet:
			bge $s3, $t3,THIRDconditionMetpt2	# third group is greater than or equal to -2^15
			j errorArgs
			THIRDconditionMetpt2:
			ble $s3, $t4,ALLconditionMet	# third group is less than or equal to (2^15) - 1
			j errorArgs			# if condition is not met then throw invalid args error 
		
		ALLconditionMet:
		
		# $s0 = first group
		# $s1 = second group
		# $s2 = third group
		# $s3 = fourth group
		
		li $t9,0 			# FINAL RESULT 
		
		li $t0,0			# first group temp
		li $t1,0			# second group temp
		li $t2,0			# third group temp
		li $t3,0			# fourth group temp
		
		sll $t0,$s0,26		
		sll $t1,$s1,21		
		sll $t2,$s2,16
		sll $t3,$s3,0
		
		li $t4, 0x0000FFFF 	# masking for 16
		
		and $t3,$t4,$t3 		# mask and replace... fourth set (16)			
		add $t9, $t0 ,$t1
		add $t9, $t9 ,$t2
		add $t9, $t9 ,$t3
	
		move $a0,$t9     
    		li $v0,34		# print out hexadecimal
    		syscall
    		
    		j exit
    		

	##### PART 4 #####	
part4:
	li $t0, '1'
	li $t1, '2'
	li $t2, 'S'

	lw $s0, addr_arg1			# load the first argument
	lbu $s0, 0($s0)
	beq $s0, $t0, checkArg2		# first argument is equal to 1 (49 ascii)
	beq $s0, $t1, checkArg2		# first argument is equal to 2 (50 ascii)
	beq $s0, $t2, checkArg2		# first argument is equal to S (83 ascii)
	j errorArgs				# invalid character then throw error 
		
	checkArg2:
		lw $s1, addr_arg2			# load the second argument
		lbu $s1, 0($s1)
		beq $s1, $t0, loadArg3		# second argument is equal to 1 (49 ascii)
		beq $s1, $t1, loadArg3		# second argument is equal to 2 (50 ascii)
		beq $s1, $t2, loadArg3		# second argument is equal to S (83 ascii)
		j errorArgs				# invalid character then throw error 

	loadArg3:			#to convert hex to binary
		lw $s2, addr_arg3			# load the third argument
		
	li $t9,0	# final conversion register instantiated			
		
	hexToValue:
		lbu $t0, 2($s2)			# loads third character
		beqz $t0,NEXTISNULL			# if next character is a null terminator
		
		li $t1, 57			# t1 -> 9 (the acceptable range for hex)

		ble $t0,$t1, ConvertingNow	# if current ascii is less than 57 (9)
		addi $t0,$t0,-55		# converts letter 
		sll $t9,$t9,4 			# shift final left 4 
		add $t9, $t0, $t9		# t9 = t0 + t9 (final = temp + final)
	
		j convertingSkip		# jumps the number convert label
		
		ConvertingNow:	
			addi $t0,$t0,-48	# converts the number
			sll $t9,$t9,4 			# shift final left 4 
			add $t9, $t0, $t9		# t9 = t0 + t9 (final = temp + final)
		
		convertingSkip:
				
		addi $s2, $s2, 1		# increments pointer to next character
		j hexToValue		# charToValueLoop goes again
	
	NEXTISNULL:	# this part deals with the from and to conversion
	li $t0, '1'
	li $t1, '2'
	li $t2, 'S'
	
	#s0 - first argument char
	#s1 - second argument char
	
	beq $s0, $s1, printInBinary		# first argument is equal to 1 (49 ascii) 1 -> 1 
	beq $s0, $s1, printInBinary		# first argument is equal to 2 (50 ascii) 2 -> 2
	beq $s0, $s1, printInBinary		# first argument is equal to S (83 ascii) S -> S
	
	beq $s0, $t0, firstArgIs_1		# first argument is equal to 1 (49 ascii) 
	beq $s0, $t1, firstArgIs_2		# first argument is equal to 2 (50 ascii)
	beq $s0, $t2, firstArgIs_S		# first argument is equal to S (83 ascii)
	
	
	firstArgIs_1:
	beq $s1, $t1, oneToTwo		# second argument is equal to 2 (50 ascii)... means 1 -> 2
	beq $s1, $t2, oneToSign		# second argument is equal to S (83 ascii)... means 1 -> S
	
	firstArgIs_2:
	beq $s1, $t0, twotoOne		# second argument is equal to 1 (49 ascii)... means 2 -> 1
	beq $s1, $t2, twoToSign		# second argument is equal to S (83 ascii)... means 2 -> S
	
	firstArgIs_S:
	beq $s1, $t0, signToOne		# second argument is equal to 1 (49 ascii)... means S -> 1 
	beq $s1, $t1, signToTwo		# second argument is equal to 2 (50 ascii)... means S -> 2


	oneToSign:
		move $t2, $t9		# copy binary t9 value to t2
		srl $t1, $t2, 31	# shifts everything to the right 31 to assign t1 to the sign bit
		beqz $t1, printInBinary	# if positive (sign bit = 0) then just print as is.
		
		# if the first number in the hex is negative it does the arithmetic
		
		li $t0, 0x7FFFFFFF		# masking WITH ALL 1 (first bit is kept for sign bit)
		xor $t9,$t9,$t0 		# this inverts the numbers. gives a value of 1 if only 1 is present during the xor of 2 statments
		li $t8, 0xFFFFFFFF		# 1111111111 -> 000000
		li $t7, 0x80000000		
		beq $t8,$t9, positiveZero	# converts -0 to +0
		beq $t7,$t9, positiveZero	# converts -0 to +0
		j printInBinary
		
	twoToSign:
		move $t2, $t9		# copy binary t9 value to t2
		srl $t1, $t2, 31	# shifts everything to the right 31 to assign t1 to the sign bit
		beqz $t1, printInBinary	# if positive (sign bit = 0) then just print as is.
		
		# if the first number in the hex is negative it does the arithmetic
		addi $t9,$t9,-1
		li $t0, 0x7FFFFFFF		# masking WITH ALL 1 (first bit is kept for sign bit)
		xor $t9,$t9,$t0 		# this inverts the numbers. gives a value of 1 if only 1 is present during the xor of 2 statments
		j printInBinary		
				
	signToOne:
		move $t2, $t9		# copy binary t9 value to t2
		srl $t1, $t2, 31	# shifts everything to the right 31 to assign t1 to the sign bit
		beqz $t1, printInBinary	# if positive (sign bit = 0) then just print as is.
		
		# if the first number in the hex is negative it does the arithmetic
		li $t0, 0x7FFFFFFF		# masking WITH ALL 1 (first bit is kept for sign bit)
		xor $t9,$t9,$t0 		# this inverts the numbers. gives a value of 1 if only 1 is present during the xor of 2 statments
		
		li $t8, 0xFFFFFFFF		# 1111111111 -> 000000
		li $t7, 0x80000000		#10000000000 -> 0000000000	
		beq $t8,$t9, positiveZero	# converts -0 to +0
		beq $t7,$t9, positiveZero	# converts -0 to +0
		j printInBinary
	
	signToTwo:
		move $t2, $t9		# copy binary t9 value to t2
		srl $t1, $t2, 31	# shifts everything to the right 31 to assign t1 to the sign bit
		beqz $t1, printInBinary	# if positive (sign bit = 0) then just print as is.
		
		# if the first number in the hex is 8 or greater it does the arithmetic
		li $t0, 0x7FFFFFFF		# masking WITH ALL 1 (first bit is kept for sign bit) $t0 = sign bit
		xor $t9,$t9,$t0 		# this inverts the numbers. gives a value of 1 if only 1 is present during the xor of 2 statments
		addi $t9, $t9, 1		# adds 1 to give the 2's complement
		j printInBinary
		
	oneToTwo:
		move $t2, $t9		# copy binary t9 value to t2
		srl $t1, $t2, 31	# shifts everything to the right 31 to assign t1 to the sign bit
		beqz $t1, printInBinary	# if positive (sign bit = 0) then just print as is.
		
		# if the first number in the hex is negative it does the arithmetic
		li $t0, 1	
		add $t9, $t9, $t0
		j printInBinary
	
	twotoOne:	
		move $t2, $t9		# copy binary t9 value to t2
		srl $t1, $t2, 31	# shifts everything to the right 31 to assign t1 to the sign bit
		beqz $t1, printInBinary	# if positive (sign bit = 0) then just print as is.
		
		# if the first number in the hex is negative it does the arithmetic
		li $t0, -1				
		add $t9, $t9, $t0
		j printInBinary
	
	printInBinary:
		move $a0,$t9     
    		li $v0,35		
    		syscall
    		j exit
    	
    	positiveZero:
    		li $t9, 0x00000000	# replaces -0 with +0
    		move $a0,$t9     
    		li $v0,35		
    		syscall
    		
    	j exit
	
  
	##### PART 5 #####	
part5:	
	lw $s0, addr_arg1		# load the first argument
	
	li $s1, 0							# final point value
	
	li $t9, 'J'			# t9 = jack
	li $t8, 'Q'			# t8 = queen
	li $t7, 'K'			# t7 = king
	li $t6, 'A'			# t6 = ace
	
	getTheCardNumber:
		lbu $t0, 0($s0)			# loads first character
		beqz $t0,getTheCardSuitBeginning	# if the next char is nothing then exit loop

		beq $t0, $t9, cardIsAJack	
		beq $t0, $t8, cardIsAQueen
		beq $t0, $t7, cardIsAKing
		beq $t0, $t6, cardIsAnAce
		j cardHasNoValue			# if the card isnt any of the point cards
		
		cardIsAJack:
		addi $s1, $s1, 1		# increase total score by 1 
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardNumber		# getTheCardNumber goes again
		
		cardIsAQueen:
		addi $s1, $s1, 2		# increase total score by 2
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardNumber		# getTheCardNumber goes again
		
		cardIsAKing:
		addi $s1, $s1, 3		# increase total score by 3
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardNumber		# getTheCardNumber goes again
		
		cardIsAnAce:
		addi $s1, $s1, 4		# increase total score by 4
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardNumber		# getTheCardNumber goes again
		
		cardHasNoValue:
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardNumber		# getTheCardNumber goes again
	
	
	getTheCardSuitBeginning:	# resets the registers
	lw $s0, addr_arg1		# load the first argument
	
	li $t9, 'H'			# t9 = heart
	li $t8, 'D'			# t8 = diamond
	li $t7, 'C'			# t7 = clubs
	li $t6, 'S'			# t6 = spades
	
	li $t5, 0		# counter for number of heart
	li $t4, 0		# counter for number of diamond
	li $t3, 0		# counter for number of clubs
	li $t2, 0		# counter for number of spades
	
	getTheCardSuit:	# this loop deals with the additional points based on the occurance of suits
		lbu $t0, 0($s0)			# loads first character
		
		beqz $t0, addingPoints		# if the next char is nothing then exit loop
		
		beq $t0, $t9, heartCounter	# current char is a heart then add 1 to the counter	
		beq $t0, $t8, diamondCounter	# current char is a diamond then add 1 to the counter	
		beq $t0, $t7, clubsCounter	# current char is a clubs then add 1 to the counter	
		beq $t0, $t6, spadesCounter	# current char is a spades then add 1 to the counter	
		
		addi $s0, $s0, 1		# increments pointer to skip a character... if none of the suits are there
		j getTheCardSuit		# getTheCardSuit goes again
		
		heartCounter:
		addi $t5, $t5, 1		# increase counter
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardSuit		# getTheCardNumber goes again
		
		diamondCounter:
		addi $t4, $t4, 1		# increase counter
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardSuit		# getTheCardNumber goes again
		
		clubsCounter:
		addi $t3, $t3, 1		# increase counter
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardSuit		# getTheCardNumber goes again
		
		spadesCounter:
		addi $t2, $t2, 1		# increase counter
		addi $s0, $s0, 1		# increments pointer to skip a character
		j getTheCardSuit		# getTheCardNumber goes again
		
		
	addingPoints:	
	li $t8, 1			# counter = 1
	li $t9, 2			# counter = 2 
		
		zeroSuitT5:
			beqz $t5, addThreePointsT5	# hearts suit counter is 0
			j zeroSuitT4			# if heart is not 0 then try diamond
		zeroSuitT4:
			beqz $t4, addThreePointsT4	# diamond suit counter is 0
			j zeroSuitT3			# if diamond is not 0 then try clubs
		zeroSuitT3:
			beqz $t3, addThreePointsT3	# clubs suit counter is 0
			j zeroSuitT2			# if clubs is not 0 then try spades
		zeroSuitT2:
			beqz $t2, addThreePointsT2	# spades suit counter is 0
			j TwoSuitT5			# if spades is not 0 then move to next set
		addThreePointsT5:
			addi $s1, $s1, 3		# add 3 
			j zeroSuitT4			# return back to top of first set
		addThreePointsT4:
			addi $s1, $s1, 3
			j zeroSuitT3
		addThreePointsT3:
			addi $s1, $s1, 3
			j zeroSuitT2
		addThreePointsT2:
			addi $s1, $s1, 3
			j TwoSuitT5
		
		TwoSuitT5:
			beq $t9, $t5, addOnePointT5	# hearts suit counter is 2
			j TwoSuitT4			# if heart is not 2 then try diamond
		TwoSuitT4:
			beq $t9, $t4, addOnePointT4	# diamond suit counter is 2
			j TwoSuitT3
		TwoSuitT3:
			beq $t9, $t3, addOnePointT3	# clubs suit counter is 2
			j TwoSuitT2
		TwoSuitT2:
			beq $t9, $t2, addOnePointT2	# spades suit counter is 2
			j OneSuitT5
		addOnePointT5:
			addi $s1, $s1, 1
			j TwoSuitT4
		addOnePointT4:
			addi $s1, $s1, 1
			j TwoSuitT3
		addOnePointT3:
			addi $s1, $s1, 1
			j TwoSuitT2
		addOnePointT2:
			addi $s1, $s1, 1
			j OneSuitT5
		
		OneSuitT5:
			beq $t8, $t5, addTwoPointT5	# hearts suit counter is 1
			j OneSuitT4
		OneSuitT4:
			beq $t8, $t4, addTwoPointT4	# diamond suit counter is 1
			j OneSuitT3
		OneSuitT3:
			beq $t8, $t3, addTwoPointT3	# clubs suit counter is 1
			j OneSuitT2
		OneSuitT2:
			beq $t8, $t2, addTwoPointT2	# spades suit counter is 1
			j noAddingPoints
		addTwoPointT5:
			addi $s1, $s1, 2
			j OneSuitT4
		addTwoPointT4:
			addi $s1, $s1, 2
			j OneSuitT3
		addTwoPointT3:
			addi $s1, $s1, 2
			j OneSuitT2
		addTwoPointT2:
			addi $s1, $s1, 2
			j noAddingPoints

		noAddingPoints:
		
	
	printOutFinalValue:
	move $a0,$s1     
    	li $v0,1		
    	syscall
    
    j exit

exit:
	li $v0, 4
	la $a0, newline
	syscall
    li $v0, 10
    syscall
