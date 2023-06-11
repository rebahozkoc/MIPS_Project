.data
bufferIO: .space 1024
msg: .asciiz "Enter string: "


.text


#4.2 
li $v0, 4             # system call for print string
la $a0, msg           # load address of string to print
syscall               # print enter string message

li $v0, 8             # system call for reading string
la $a0, bufferIO        # load address of buffer
li $a1, 1024          # maximum characters to read
syscall               # read string

la $a0, bufferIO        # load address of string
jal print_chars         # convert and print as hexadecimal


li $v0,10
syscall             #exits the program

stringCount:
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    li $s1, 0
    move  $s0, $a0
    
    
stringCountLoop:
    lb $a0, 0($s0)
    beqz $a0, stringCountLoopOut
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j stringCountLoop

stringCountLoopOut:
    li $v0, 1
    add $a0, $0, $s1
    syscall
    li $v0, 10
    syscall
    move $v0, $s1
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra


print_chars:
  move $t0, $a0

print_loop:
  lb $t1, 0($t0)       # load byte from string
  beqz $t1, ph_return  # if byte is zero, return
  li $v0, 34           # system call for print char
  move $a0, $t1
  syscall
  addiu $t0, $t0, 1    # increment the address
  j print_loop         # repeat

ph_return:
  jr $ra               # return
