.data  
T0: .space 4                           # the pointers to your lookup tables
T1: .space 4                           
T2: .space 4                           
T3: .space 4                           
fin: .asciiz "C:\\Users\\rebah\\Desktop\\CS_S03E03\\CS 401\\PROJECT\\tables.dat"  # put the fullpath name of the file AES.dat here
string: .space 11  # Memory space for 10 characters plus null terminator

buffer: .space 5000                    # temporary buffer to read from file
newline: .asciiz "\n"
#fileLengthMsg: .asciiz "File length is (byte): "

int_per_line: .word 5

.text
#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor 

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor 
la   $a1, buffer   # address of buffer to which to read
li   $a2, 12288     # hardcoded buffer length
syscall            # read from file

move $s0, $v0	   # the number of characters read from the file
la   $s1, buffer   # address of buffer that keeps the characters


# your code goes here


## initializations
#la   $s1, buffer   # address of buffer that keeps the characters
#li   $t0, 10       # counter for number of chars to print
#
#print_chars:
#    lb   $a0, 0($s1)  # load a byte (character) from the buffer into $a0
#    li   $v0, 11      # system call for print char
#    syscall            # print character
#
#    addi $s1, $s1, 1  # increment buffer pointer to next char
#    addi $t0, $t0, -1 # decrement counter
#
#    bgtz $t0, print_chars  # if counter > 0, go back and print next char





# initializations
la   $s1, buffer   # address of buffer that keeps the characters
la   $s2, string   # address of the string memory block
li   $t0, 10       # counter for number of chars to store

store_chars:
    lb   $t1, 0($s1)    # load a byte (character) from the buffer into $t1
    sb   $t1, 0($s2)    # store the byte into the string memory block

    addi $s1, $s1, 1    # increment buffer pointer to next char
    addi $s2, $s2, 1    # increment string pointer to next position
    addi $t0, $t0, -1   # decrement counter

    bgtz $t0, store_chars  # if counter > 0, go back and store next char

# store null terminator at the end of the string
li   $t1, 0
sb   $t1, 0($s2)


la $a0, string
li $v0, 4
syscall


Exit:
li $v0,10
syscall             #exits the program


# ----------- file reader function ------------




# ---------- converter function ---------------
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
    # -------------------- temp prints ---------------
    move $a0, $t4
    li $v0, 1                    #  print integer
    syscall
    
    la $a0, newline
    li $v0, 4                      #print newline
    syscall
    # -------------------- temp prints ---------------

    move $v0, $t4                 # result will be ready at $t4
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# -------------- converter ends ------------------


# ------------- printer function ------------------
printArrayFunc:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)    #yazdirilacak arrayin adresi
    sw $a1, 8($sp)    #yazdirilacak arrayin size
    
    li $t0, 0          # t0 = index
    move $t1, $a0

printLoop:  
    beq $a1, $t0, endPrint  # end if i = size 
    sll $t2, $t0, 2          # 4 ile carp
    add $t2, $t2, $t1
    lw  $t3, 0($t2)
    
    # Prepare to print integer
    move $a0, $t3
    li $v0, 1    # print integer
    
    syscall
    
    # print new line
    la $a0, newline  
    li $v0, 4
    syscall
    addi $t0 $t0, 1
    j printLoop


endPrint:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

    
