.data 
x: .word 0x84d6 
newline: .asciiz "\n
.text

 
lw $a0, x                    #a0 = x 
jal hexConverter  
move $s0, $v0 

li $v0,10
syscall             #exits the program

hexConverter:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)              #a0 = hex word

    li $t4, 0                   # store the output at $t4

    move $t2 $a0
    addiu $t0, $zero, 31        #(t0) i == 31 (the counter) 
    li $t1, 1                   #(t1) mask 
    sll $t1, $t1, 31            

converterLoop: 
    beq $t0, -1, converterEndLoop #if t0 == -1 exit loop 
    and $t3, $t2, $t1           #isolate the bit 
    beq $t0, $0, after_shift    #shift is needed only if t0 > 0 
    srlv $t3, $t3, $t0          #right shift before display 
    
    after_shift: 
    sll $t4, $t4, 1
    add $t4, $t4, $t3           # store the new bit at result
    
    subi $t0, $t0, 1           #decrease the counter 
    srl $t1, $t1, 1            #right shift the mask 
    j converterLoop 

converterEndLoop:
    move $a0, $t4
    li $v0, 1                    #  print integer
    syscall
    
    la $a0, newline
    li $v0, 4                      #print newline
    syscall

	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
