# Hoamework 3, Question 7
# ajb200
 
.globl main_test

.data
        PromptA:                 .asciiz "Input the value for the A coefficient: "
        PromptB:                 .asciiz "Input the value for the B coefficient: "
        PromptC:                 .asciiz "Input the value for the C coefficient: "
        PromptX:                 .asciiz "Input each value for the array (after each value, press enter): \n"
        PromptArraySize: .asciiz "Input the size of the array to hold the numbers: "
       
        OverFlowError:   .asciiz "Error: Overflow :("
       
.align 2                          # Fixes Array-Offset Bug
Array:
 
 
.text
 
 
main_test:
        # Get the value of the A coefficient
        la $a0, PromptA
        jal PromptForVariable
        addi $s0, $v0, 0x0              # Store it in $s0
 
        # Get the value of the A coefficient
        la $a0, PromptB
        jal PromptForVariable
        addi $s1, $v0, 0x0              # Store it in $s1
 
        # Get the value of the A coefficient
        la $a0, PromptC
        jal PromptForVariable
        addi $s2, $v0, 0x0              # Store it in $s2
 
        # Get the value of the A coefficient
        la $a0, PromptArraySize
        jal PromptForVariable
        addi $s3, $v0, 0x0              # Store it in $s3
 
        # Get the value of the size of the array
        la $a0, PromptX
        li $v0, 4                               # SysCall #4 is print_string
        syscall
 
        # Prepare our for loop
        li $s5, 0x0
        la $s4, Array
 
InputForLoop:
        beq $s5, $s3, EndInputLoop      # while (i < N)
        li $v0, 5                                       # SysCall #5 is read_int
        syscall
 
        sw $v0, 0($s4)                          # Relative addressing is fun!
        addi $s4, $s4, 0x04             # *array = *array + (sizeof)int
        addi $s5, $s5, 0x01             # i++
 
        j InputForLoop
 
EndInputLoop:
 
        # Prepare for the calculation loop
        la $s5, Array
        li $s6, 0x0
 
CalculationLoop:
        beq $s6, $s3, EndCalculationLoop # while (i < N)
        lw $s7, 0($s5) # Load int from array 1
 
        # $v0 = X * X
        addi $a0, $s7, 0
        addi $a1, $s7, 0
        jal Multiply
 
        # $s8 = $v0 = $v0 * A
        addi $a0, $v0, 0
        addi $a1, $s0, 0
        jal Multiply
        addi $s8, $v0, 0
 
        # $v0 = X * B
        addi $a0, $s7, 0
        addi $a1, $s1, 0
        jal Multiply
 
        # $v0 = (X * B) + (X * X * A)
        addi $a0, $v0, 0
        addi $a1, $s8, 0
        jal Addition
 
        # $s4 = $v0 = $v0 + C
        addi $a0, $v0, 0
        addi $a1, $s2, 0
        jal Addition
        sw $v0, 0($s4)
 
        # Increment counters and addresses
        addi $s6, $s6, 0x1      # i++;
        addi $s5, $s5, 0x4      # *array1[i] = *array1[i] + sizeof(int)
        addi $s4, $s4, 0x4      # *array2[i] = *array2[i] + sizeof(int)
        j CalculationLoop
       
EndCalculationLoop:
        li $v0, 10              # SysCall #10 is Exit
        syscall
 
# a0 = **char message
# v0 = int value
PromptForVariable:
        li $v0, 4       # Syscall #4 is print_string
        syscall
 
        li $v0, 5       # SysCall #5 is read_int
        syscall
 
        jr $ra          # return
       
# $a0 = int x
# $a1 = int y
# $v0 = x * y
Multiply:
        mult $a0, $a1
        mflo $v0
        mfhi $t0
 
        bne $t0, $zero, OverFlowErrorTrap # Spim can't do it's own error checking
 
        jr $ra
       
# $a0 = int x
# $a1 = int y
# $v0 = x + y
Addition:
        addu $v0, $a0, $a1      # Unsigned add
       
        # Check for negativity
        bltz $a0, Negative
        bltz $a1, FinishAdding
        bltz $v0, OverFlowErrorTrap
        j FinishAdding
       
Negative:
        bgtz $a1, FinishAdding
        bgtz $v0, OverFlowErrorTrap
 
FinishAdding:
        jr $ra
       
OverFlowErrorTrap:
        li $v0, 4                                       # SysCall #4 is print_string
        la $a0, OverFlowError           # $a0 is the string
        syscall
        j done

done:
	j done
