.data
	done: .asciiz "DONE\n"
	new: .asciiz "\n"
	space: .asciiz " "
.text
	.globl main

main:
	j createNode

createNode:
	li $v0, 9
	li $a0, 60 # Allocate for player
	syscall # $v0 contains address of memory
	move $a0, $v0 # Moves address of memory to $a0

	li $v0, 8 # Read player name
	li $a1, 60 # Sets length
	syscall # Players name in $a0
	move $t0, $a0 # Players name stored in $t0 temporarily
	
	la $a2, done # "DONE\n" to $a2
	add $t1, $zero, $a2 # $a2 to $t1
	add $s1, $zero, $t0 # Copy of name
	add $s2, $zero, $t1 # Copy of done
	jal strcmp # Compare $t0 to $t1 (copies)
	# Now v0 = 0 if equal, v0 = 1 if not equal
	beq $v0, $zero, printSetup # If $v0 = 0, at DONE. Send to print

	li $v0, 9 # Allocate heap memory
	li $a0, 68 # Bytes allocated
	syscall # $v0 contains address of memory
	move $s0, $v0 # $v0 to $s0
	
	sw $t0, 0($s0) # Load player name in $s0

	jal calcValue # Calculate Value

	sw $s3, 60($s0) # Add pointer in $s0 of $s3
	move $s3, $s0 # s0 (head) = s0->next
	j clear

clear:
	li $s1, 0 # Clear
	li $s2, 0 # Clear
	li $t0, 0 # Clear
	li $t1, 0 # Clear
	j createNode

calcValue:
	li $v0, 6 # Read PPG (float)
	syscall # Float stored in #$f0
	mov.s $f1, $f0 # Move to #$f1

	li $v0, 6 # Read RPG (float)
	syscall
	mov.s $f2, $f0 # Move to #$f2

	li $v0, 6 # Read TPG (float)
	syscall
	mov.s $f3, $f0 # Move to #$f3

	add.s $f4, $f2, $f1 # PPG + RPG
	div.s $f5, $f4, $f3 # (PPG+RPG)/TPG

	s.s $f5, 64($s0) # Player value at 64($s0)
	jr $ra # Return to createNode

strcmp:
	lbu $t2, 0($s1) # Load bit name to $t2
	lbu $t3, 0($s2) # Load bit done to $t3
	bne $t2, $t3, b1 # If not equal, continue prog
	beq $t2, $0, b2 # If $t2=$t3=null (end of check)
	j b3
b1:
	li $v0, 1 # Not equal to DONE
	jr $ra
b2:
	li $v0, 0 # Equal to DONE
	jr $ra	
b3:
	addi $s1, $s1, 1 # Increment next char
	addi $s2, $s2, 1 # Increment next char
	j strcmp # Check new chars
printSetup:
	la $s4, 0($s0) # $s4 Holds address to max
print:
	beqz $s3, printSingle # Go to end if null
sortAndPrint:
	l.s $f1, 64($s4) # Curr Max
	l.s $f2, 64($s3) # Curr value
	c.lt.s $f1, $f2
	bc1t updateMax # Branch if $f1<$f2
	lw $s3, 60($s3) # Curr = curr->next
	j print

updateMax:
	la $s4, 0($s3) # $s0 new max
	lw $s3, 60($s3) # Curr = curr->next
	j print

printSingle: # Prints current highest then sets used value at -1
	beq $s5, $0, MVP # Branch if never set MVP
	lwc1 $f12, 64($s4)
	li $t0, -1
	mtc1 $t0, $f5 # $f5 = $t0
	cvt.s.w $f5, $f5 # Double to single
	c.eq.s $f12, $f5
	bc1t end # Branch if $f1=-1

	li $v0, 4 # To print
	lw $a0, 0($s4)
	la $a1, 0($a0) # Copy $a0
	jal removeNew
	syscall

	li $v0, 4 # Print space
	la $a0, space
	syscall

	li $v0, 2 # To print
	l.s $f12, 64($s4) # Print value in $s4
	syscall

	li $v0, 4
	la $a0, new
	syscall

	li $t0, -1 # To set just printed value as -1
	mtc1 $t0, $f5 # $f5 = $t0
	cvt.s.w $f5, $f5 # Double to single
	swc1 $f5, 64($s4) # M[$s4+64] = $f5 = -1

	la $s3, 0($s0) # Load head back to $s0
	j printSetup

MVP:
	la $s5, 0($s4)
	j printSingle

removeNew: #remove \n from being printed
	lb $a3, 0($a1) # Load bit name to $a3
	addi $a1, $a1, 1 # Increment name by 1
	bnez $a3, removeNew # Continue if not at null
	addi $a1, $a1, -2 # At null so backtrack 2 to rid of \n
	sb $0, 0($a1) # Add null at end
	jr $ra
printMVP:
	li $v0, 4
	lw $a0, 0($s5) # MVP is $s5
	syscall # Print MVP
	jr $ra
end:
	jal printMVP
	li $v0, 10
	syscall  # End program