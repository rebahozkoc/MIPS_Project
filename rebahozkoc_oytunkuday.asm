.data
T0: .space 4                           # the pointers to your lookup tables
T1: .space 4
T2: .space 4
T3: .space 4
fin: .asciiz "C:\\Users\\rebah\\Desktop\\CS_S03E03\\CS 401\\PROJECT\\tables.dat"  # put the fullpath name of the file AES.dat here
buffer: .space 5000                    # temporary buffer to read from file

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

#print first 10 characters
#move $t7, $zero
#addi $t6, 31
#addi $t5, 0 #result reg
li $t7, 2048
li $t6, 4 #table follow
li $t5, 268435456 #16^7
li $t4, 0 #integer of hex char
li $t3, 0 #hex in toplam sayi

#NEED TO initialize to table0  !!!!!!!!!!!!!!!!!
PrintLoop:
    beqz $s2, nexthex   # if counter is 0, exit loop
    bge $s2, 9, skip
    addi $t7, $t7, -1 #decrement total char count
    lbu  $t0, 0($s1) # load byte from buffer into $t0
    #beq  $t0, $zero, Exit # if byte is null, exit loop
    li   $v0, 11     # system call for print character
    move $a0, $t0    # character to print
    syscall          # print the character
    
    #sayiya cevir t4e depola
    beq $t0, '0', zerobranch
    beq $t0, '1', onebranch
    beq $t0, '2', twobranch
    beq $t0, '3', threebranch
    beq $t0, '4', fourbranch
    beq $t0, '5', fivebranch
    beq $t0, '6', sixbranch
    beq $t0, '7', sevenbranch
    beq $t0, '8', eightbranch
    beq $t0, '9', ninebranch
    beq $t0, 'a', tenbranch
    beq $t0, 'b', elevenbranch
    beq $t0, 'c', twelvebranch
    beq $t0, 'd', thirteenbranch
    beq $t0, 'e', fourteenbranch
    beq $t0, 'f', fifteenbranch
    
    progress:
    mul $t4, $t4, $t5 
    srl $t5,$t5,4
    addu $t3, $t3, $t4
    #heapzort
    skip:
    addi $s1, $s1, 1 # increment buffer pointer
    addi $s2, $s2, -1 # decrement character counter
    j    PrintLoop   # repeat the loop

    nexthex:
    li $t5, 268435456 #16^7
    li $s2 ,10
    addi $s1, $s1, 2 # increment buffer pointer
    
    #add elem to heap
    
    li $t3, 0
    beqz $t7, nexttable
    j PrintLoop
    
    nexttable:
    beqz $t6, Exit
    addi $t6,$t6, -1
    beq $t6, 3, table2 #go table 2
    beq $t6, 2, table3 #go table 3
    beq $t6, 1, table4 #go table 4
    
    table2:
    #make point to table 2 and init
    li $t7, 2048
    #lbu  $t0, 0($s1) # load byte from buffer into $t0
    #addi $s1, $s1, 1 # increment buffer pointer
    li   $s2, 10
    j PrintLoop
    
    
    table3:
    li $t7, 2048
    addi $s1, $s1, 1 # increment buffer pointer
    li   $s2, 10
    #make point to table 3 and init
    j PrintLoop
    
    table4:

    #make point to table 4 and init
    addi $s1, $s1, 1 # increment buffer pointer
    li $t7, 2048
    li $s2, 10
    j PrintLoop
    
# close the file


Exit:
li $v0, 16         # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close the file

li $v0,10
syscall             #exits the program

zerobranch:
    li $t4, 0
    j progress

onebranch:
    li $t4, 1
    j progress

twobranch:
    li $t4, 2
    j progress
    
threebranch:
    li $t4, 3
    j progress

fourbranch:
    li $t4, 4
    j progress

fivebranch:
    li $t4, 5
    j progress

sixbranch:
    li $t4, 6
    j progress

sevenbranch:
    li $t4, 7
    j progress

eightbranch:
    li $t4, 8
    j progress

ninebranch:
    li $t4, 9
    j progress

tenbranch:
    li $t4, 10
    j progress

elevenbranch:
    li $t4, 11
    j progress

twelvebranch:
    li $t4, 12
    j progress

thirteenbranch:
    li $t4, 13
    j progress

fourteenbranch:
    li $t4, 14
    j progress

fifteenbranch:
    li $t4, 15
    j progress
