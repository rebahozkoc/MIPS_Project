.data
T0: .space 4                           # the pointers to your lookup tables
T1: .space 4
T2: .space 4
T3: .space 4            
size: .word 1024                        # size of the array in bytes
fin: .asciiz "C:\\Users\\rebah\\Desktop\\CS_S03E03\\CS 401\\PROJECT\\tables.dat"  # put the fullpath name of the file AES.dat here
newline: .asciiz "\n
buffer: .space 5000                    # temporary buffer to read from file
.text


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
li   $s2, 10       # initialize counter for 10 characters



main:
    # Load value at address size into $a0
    lw $a0, size

    # Set syscall number to 9 to allocate memory
    li $v0, 9
    syscall

    # The address of the start of the allocated block is now in $v0
    # Store this address for future reference in T0
    la $a1, T0   # Address of T0 in $a1
    sw $v0, 0($a1)
	
   
    li $t1, 31       #T0[0] = 31
    sw $t1, 0($v0)

    li $t2, 69      #TO[3] = 69
    sw $t2, 12($v0)
    
    la $a1, T0        # Address of T0 in $a1
    lw $a0, 0($a1)    # address of array pointed by T0 is at a0. bunu kullan
    
    #move $a0, $v0   # T0 yazdiriliyor
    lw $a1, size  # T0 size a1 de ama byte seklinde
    srl $a1, $a1, 2 # divide by 4
    jal printArrayFunc
    
    # Exit program
    li $v0, 10
    syscall
    
printArrayFunc:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)    #yazdirilacak arrayin adresi
    sw $a1, 8($sp)    #yazdirilacak arrayin size
    
    li $t0, 0          # t0 = index
    move $t1, $a0

printLoop:  
    beq $a1, $t0, endPrint  # end if i = size 
    sll $t2, $t0, 2          # 4 ile çarp
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

    
    
    
    
    
    
