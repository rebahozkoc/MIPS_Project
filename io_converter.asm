.data
bufferIO: .space 1024
msg: .asciiz "Enter string: "
newline: .asciiz "\n"
.text

li $v0, 4               # system call for print string
la $a0, msg             # load address of string to print
syscall                 # print enter string message

li $v0, 8               # system call for reading string
la $a0, bufferIO        # load address of buffer
li $a1, 1024            # maximum characters to read
syscall                 # read string

la $a0, bufferIO        # load address of string
jal stringCount

la $a0, bufferIO
move $a1, $v0
jal parse_all



li $v0,10
syscall             #exits the program

stringCount:
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $a0, 8($sp)
    li $s1, 0
    move  $s0, $a0
    
    
stringCountLoop:
    lb $a0, 0($s0)
    beqz $a0, stringCountLoopOut
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j stringCountLoop


stringCountLoopOut:
    move $v0, $s1
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $a0, 8($sp)
    addi $sp, $sp, 12
    jr $ra


print_chars:
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)
    move $t0, $a0
    li $t2, 4
    li $v0, 0
    li $s0, 0
    li $s1, 0
    li $s2, 0
    li $s3, 0
        
print_loop:
    beqz $t2, end_print_loop  
    lb $t1, 0($t0)       # load byte from string   
    sll $s0, $s0, 8
    add $s0, $s0, $t1
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    j print_loop         # repeat

end_print_loop:
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4
    
print_loop2:
    beqz $t2, end_print_loop2  
    lb $t1, 0($t0)       # load byte from string   
    sll $s0, $s0, 8
    add $s0, $s0, $t1
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    j print_loop2         # repeat

end_print_loop2:
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4    

print_loop3:
    beqz $t2, end_print_loop3  
    lb $t1, 0($t0)       # load byte from string   
    sll $s0, $s0, 8
    add $s0, $s0, $t1
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    j print_loop3         # repeat

end_print_loop3:
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4    
    
print_loop4:
    beqz $t2, end_print_loop4 
    lb $t1, 0($t0)       # load byte from string   
    sll $s0, $s0, 8
    add $s0, $s0, $t1
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    j print_loop4         # repeat

end_print_loop4:
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4    
    
ph_return:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    move $v0, $t0
    jr $ra               # return
    
parse_all:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    addi $a1, $a1, 14    # a1 contains size
    div $a1, $a1, 16
    
parse_all_loop:
    beqz $a1, end_parse_all
    jal print_chars         # convert and print as hexadecimal
    
    move $t1, $v0
    la $a0, newline         # print new line
    li $v0, 4
    syscall
    move $a0, $t1
    subi $a1, $a1, 1
    j parse_all_loop

end_parse_all:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

