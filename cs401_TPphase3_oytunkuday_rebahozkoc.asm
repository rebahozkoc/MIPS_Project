.data
T0: .space 4                           # the pointers to your lookup tables
T1: .space 4
T2: .space 4
T3: .space 4
newline: .asciiz "\n"
roundmsg: .asciiz "new states:\n"
msg: .asciiz "Enter string: "
debugmsg: .asciiz "reached here:\n"
fin: .asciiz "C:\\Users\\rebah\\Desktop\\CS_S03E03\\CS 401\\PROJECT\\tables.dat"
buffer: .space 15000                    # temporary buffer to read from file
s: .word 0xd82c07cd, 0xc2094cbd, 0x6baa9441, 0x42485e3f
rkey: .word 0x82e2e670, 0x67a9c37d, 0xc8a7063b, 0x4da5e71f
key: .word 0x2b7e1516, 0x28aed2a6, 0xabf71588, 0x09cf4f3c
rcon : .word 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01
converted_msg : .word 0x00000000, 0x00000000, 0x00000000, 0x00000000
bufferIO: .space 1024

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
li   $a2, 15288     # hardcoded buffer length
syscall            # read from file

move $s0, $v0	   # the number of characters read from the file
la   $s1, buffer   # address of buffer that keeps the characters
li   $s2, 10       # initialize counter for 10 characters

#print first 10 characters
#move $t7, $zero
#addi $t6, 31
#addi $t5, 0 #result reg

li $a0, 1024
li $v0, 9
syscall
la $a1, T0   # Address of T0 in $a1
sw $v0, 0($a1)

li $a0, 1024
li $v0, 9
syscall

la $a1, T1   # Address of T0 in $a1
sw $v0, 0($a1)

li $a0, 1024
li $v0, 9
syscall

la $a1, T2   # Address of T0 in $a1
sw $v0, 0($a1)

li $a0, 1024
li $v0, 9
syscall
la $a1, T3   # Address of T0 in $a1
sw $v0, 0($a1)
	
la $t2, T0
lw $t2,0($t2)
	
li $t7, 2048
li $t6, 4 #table follow
li $t5, 268435456 #16^7
li $t4, 0 #integer of hex char
li $t3, 0 #hex in toplam sayi


    # Move the address from $t2 to $a0
    move $a0, $t2

    # Load the appropriate syscall code into $v0
    li $v0, 34

    # Perform the syscall
    syscall

#NEED TO initialize to table0  !!!!!!!!!!!!!!!!!
PrintLoop:
    beqz $s2, nexthex   # if counter is 0, exit loop
    
    bge $s2, 9, skip
    addi $t7, $t7, -1 #decrement total char count
    lbu  $t0, 0($s1) # load byte from buffer into $t0
    beq  $t0, $zero, Exit # if byte is null, exit loop
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
    sra $t5,$t5,4
    addu $t3, $t3, $t4
    #heapzort
    skip:
    addi $s1, $s1, 1 # increment buffer pointer
    addi $s2, $s2, -1 # decrement character counter
    j    PrintLoop   # repeat the loop

    nexthex:
    li $t5, 268435456 #16^7
    li $s2 ,10
    #add elem to heap
    sw $t3, 0($t2)
    addi $t2, $t2,4
    move $a0, $t3
    li $v0, 35
    syscall
    #
    li $t3, 0
    beqz $t7, nexttable
    addi $s1, $s1, 2 # increment buffer pointer
    j PrintLoop
    
    nexttable:
    li $a0, 10          # newline print
    li $v0, 11          
    syscall             
    beqz $t6, Exit
    addi $t6,$t6, -1
    addi $s1, $s1, 2
    beq $t6, 3, table2 #go table 2
    beq $t6, 2, table3 #go table 3
    beq $t6, 1, table4 #go table 4
    
    table2:
    #make point to table 2 and init
    li $t7, 2048
    #lbu  $t0, 0($s1) # load byte from buffer into $t0
    #addi $s1, $s1, 1 # increment buffer pointer
    la $t2, T1
    lw $t2,0($t2)
    li   $s2, 10
    j PrintLoop
    
    
    table3:
    li $t7, 2048
    li   $s2, 10
    la $t2, T2
    lw $t2,0($t2)
    #make point to table 3 and init
    j PrintLoop
    
    table4:
    #make point to table 4 and init
    li $t7, 2048
    la $t2, T3
    lw $t2,0($t2)
    li $s2, 10
    j PrintLoop
    
# close the file


Exit:
li $v0, 16         # system call for close file
move $a0, $s6      # file descriptor to close
syscall            # close the file

# print new line
la $a0, newline  
li $v0, 4
syscall


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

la $a0, bufferIO        # load address of string
jal stringCount

move $a3, $v0        # a3 contains size
addi $a3, $a3, 15   
div $a3, $a3, 16
    
cript_all_loop:
    beqz $a3, end_cript_all
    la $a1, converted_msg
    jal print_chars         # convert and print as hexadecimal
       
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    j process
cript_all_loop_cont:
    lw $a0, 0($sp)
    addi $sp, $sp, 4
    subi $a3, $a3, 1
    j cript_all_loop

end_cript_all:
    li $v0,10
    syscall             #exits the program

process: #128 bitte 1 buraya branchlencek

#KEY WHITENING:

la $s0, key
lw $t0, 0($s0)    # key[0]
lw $t1, 4($s0)    # key[1]
lw $t2, 8($s0)    # key[2]
lw $t3, 12($s0)   # key[3]

la $s0, converted_msg
lw $t4, 0($s0)    # key[0]
lw $t5, 4($s0)    # key[1]
lw $t6, 8($s0)    # key[2]
lw $t7, 12($s0)   # key[3]

xor $t0, $t0,$t4
xor $t1, $t1,$t5
xor $t2, $t2,$t6
xor $t3, $t3,$t7
xor $t4, $t4,$t8


move $a0, $t0
li $v0, 34         # print integer as hex
syscall
li $a0, 32
li $v0, 11  
syscall
move $a0, $t1
li $v0, 34         # print integer as hex
syscall
li $a0, 32
li $v0, 11  
syscall
move $a0, $t2
li $v0, 34         # print integer as hex
syscall
li $a0, 32
li $v0, 11  
syscall
move $a0, $t3
li $v0, 34         # print integer as hex
syscall

sw $t0, 0($s0)    # s[0]
sw $t1, 4($s0)    # s[1]
sw $t2, 8($s0)    # s[2]
sw $t3, 12($s0)   # s[3]

la $a0, newline  
li $v0, 4
syscall


# buraya 3.1 gelecek
#3.2
la $s0, key
lw $t0, 0($s0)    # key[0]
lw $t1, 4($s0)    # key[1]
lw $t2, 8($s0)    # key[2]
lw $t3, 12($s0)   # key[3]

la $s0, rkey

sw $t0, 0($s0)    # rkey[0]=key[0]
sw $t1, 4($s0)    # key[1]
sw $t2, 8($s0)    # key[2]
sw $t3, 12($s0)   # key[3]

li $s4, 0
la $s6, rcon

li $a0, 10          # newline print
li $v0, 11          
syscall       


round:

lw $t8,8($s0) #rkey[2]

#rkey operations here
srl $t4, $t8, 24  # a = rkey[2] >> 24
srl $t5, $t8, 16  # b = rkey[2] >> 16
srl $t6, $t8, 8   # c = rkey[2] >> 8
andi $t4, $t4, 0xFF
andi $t5, $t5, 0xFF
andi $t6, $t6, 0xFF
andi $t7, $t8, 0xFF  # d = rkey[2] & 0xFF

la $t8, T2
lw $t8, 0($t8)    # $t8 = T2

# Loading T2[b], T2[c], T2[d], T2[a]
sll $t5, $t5, 2   # b*4 to use with byte addressable memory
add $t5, $t5, $t8
lw $t5, 0($t5)    # e = T2[b]
andi $t5, $t5, 0xFF   # e = (T2[b] & 0xFF)

sll $t6, $t6, 2   # c*4
add $t6, $t6, $t8
lw $t6, 0($t6)    # f = T2[c]
andi $t6, $t6, 0xFF   # f = (T2[c] & 0xFF)

sll $t7, $t7, 2   # d*4
add $t7, $t7, $t8
lw $t7, 0($t7)    # g = T2[d]
andi $t7, $t7, 0xFF   # g = (T2[d] & 0xFF)

sll $t4, $t4, 2   # a*4
add $t4, $t4, $t8
lw $t4, 0($t4)    # h = T2[a]
andi $t4, $t4, 0xFF   # h = (T2[a] & 0xFF)

#e = (T2[b]&0xFF)^ rcon[i]
lb $s7, 0($s6)
xor $t5, $t5, $s7

# tmp = (e << 24) ^ (f << 16) ^ (g << 8) ^ h
sll $t5, $t5, 24 #e
sll $t6, $t6, 16 #f
sll $t7, $t7, 8  #g, no need for h
xor $t5, $t5, $t6 
xor $t5, $t5, $t7 #h
xor $t5, $t5, $t4  # tmp is $t5 

# rkey[0] (t0) = tmp ^ rkey[0]
lw $t0, 0($s0)
xor $t0, $t0, $t5
sw $t0, 0($s0)

# rkey[1] (t1) = rkey[0] ^ rkey[1]
lw $t1, 4($s0)
xor $t1, $t0, $t1
sw $t1, 4($s0)
    
# rkey[2] (t2) = rkey[1] ^ rkey[2]
lw $t2, 8($s0)
xor $t2, $t1, $t2
sw $t2, 8($s0)

# rkey[3] (t3) = rkey[2] ^ rkey[3]
lw $t3, 12($s0)
xor $t3, $t2, $t3
sw $t3, 12($s0)

addi, $s4,$s4,1
addi $s6,$s6,4

move $a0, $t0
li $v0, 34         # print integer as hex
syscall

li $a0, 32
li $v0, 11  
syscall

move $a0, $t1
li $v0, 34         # print integer as hex
syscall


li $a0, 32
li $v0, 11  
syscall

move $a0, $t2
li $v0, 34         # print integer as hex
syscall

li $a0, 32
li $v0, 11  
syscall

move $a0, $t3
li $v0, 34         # print integer as hex
syscall

li $a0, 10          # newline print
li $v0, 11          
syscall 

la $a0, newline  
li $v0, 4
syscall


la $a0, roundmsg  
li $v0, 4
syscall


la $a0, rkey
la $a1, converted_msg
jal roundFunc




li $a0, 10          # newline print
li $v0, 11          
syscall 



bne $s4, 8, round


#burada check edip tekrar inputa devam etmeye başlayacak, orada check olmalı input yoksa exitlicek

j cript_all_loop_cont






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
    

roundFunc:
    addi $sp, $sp, -44
    sw $ra, 0($sp)
    sw $a0, 4($sp)    # address of round key r
    sw $a1, 8($sp)    # address of state s
    
    sw $s0, 12($sp)   # save s registers in case of they are in use
    sw $s1, 16($sp)
    sw $s2, 20($sp)
    sw $s3, 24($sp)
    sw $s4, 28($sp)	# result t0 
    sw $s5, 32($sp)	# result t1
    sw $s6, 36($sp)	# result t2
    sw $s7, 40($sp)	# result t3
    
    la $s0, T0   
    lw $s0, 0($s0)    # $s0 = T0
    la $s1, T1       
    lw $s1, 0($s1)    # $s1 = T1
    la $s2, T2
    lw $s2, 0($s2)    # $S2 = T2
    la $s3, T3
    lw $s3, 0($s3)    # $s3 = T3
        
    lw $t0, 0($a0)    # rkey[0]
    lw $t1, 4($a0)    # rkey[1]
    lw $t2, 8($a0)    # rkey[2]
    lw $t3, 12($a0)   # rkey[3]
    lw $t4, 0($a1)   # s[0]
    lw $t5, 4($a1)   # s[1]
    lw $t6, 8($a1)   # s[2]
    lw $t7, 12($a1)  # s[3]
    
    #------------t[0]-----------------------
    
    srl $t8, $t4, 24   		# s[0]>>24
    sll $t8, $t8, 2
    add $t9, $t8, $s3  

    lw $s4, 0($t9)	 	# t[0] = T3[s[0]>>24]
    
    srl $t8, $t5, 16		# s[1]>>16
    and $t8, $t8, 0xff		# (s[1]>>16)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s1
    lw $t9, 0($t9)
    xor $s4, $s4, $t9 		# t[0] = T3[s[0]>>24]^T1[(s[1]>>16)&0xff]
    
    srl $t8, $t6, 8		# s[2]>>8
    and $t8, $t8, 0xff		# (s[2]>>8)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s2	
    lw $t9, 0($t9)
    xor $s4, $s4, $t9		# t[0] = T3[s[0]>>24]^T1[(s[1]>>16)&0xff]^T2[(s[2]>>8)&0xff]
    
    and $t8, $t7, 0xff		# s[3]&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s0

    lw $t9, 0($t9)
    xor $s4, $s4, $t9 		# t[0] = T3[s[0]>>24]^T1[(s[1]>>16)&0xff]^T2[(s[2]>>8)&0xff]^T0[s[3]&0xff]
    
    xor $s4, $s4, $t0		# t[0] = t[0]^rkey[0]	
    
    move $a0, $s4
    li $v0, 34         # print integer as hex
    syscall
    
    # print new line
    la $a0, newline  
    li $v0, 4
    syscall
    
    
    #------- t[0] is done -------------- 
    #---------- t[1]--------------------
    srl $t8, $t5, 24   		# s[1]>>24
    sll $t8, $t8, 2
    add $t9, $t8, $s3  	

    lw $s5, 0($t9)	 	# t[1] = T3[s[1]>>24]
    
    srl $t8, $t6, 16		# s[2]>>16
    and $t8, $t8, 0xff		# (s[2]>>16)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s1
    lw $t9, 0($t9)
    xor $s5, $s5, $t9 		# t[1] = T3[s[1]>>24]^T1[(s[2]>>16)&0xff]
    
    srl $t8, $t7, 8		# s[3]>>8
    and $t8, $t8, 0xff		# (s[3]>>8)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s2	
    lw $t9, 0($t9)
    xor $s5, $s5, $t9		# t[1] = T3[s[1]>>24]^T1[(s[2]>>16)&0xff]^T2[(s[3]>>8)&0xff]
    
    and $t8, $t4, 0xff		# s[0]&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s0

    lw $t9, 0($t9)
    xor $s5, $s5, $t9 		# t[1] = T3[s[1]>>24]^T1[(s[2]>>16)&0xff]^T2[(s[3]>>8)&0xff]^T0[s[0]&0xff]
    
    xor $s5, $s5, $t1		# t[1] = t[1]^rkey[1]		
    
    move $a0, $s5
    li $v0, 34         # print integer as hex
    syscall
    
    # print new line
    la $a0, newline  
    li $v0, 4
    syscall
    
    #---------------t[1] is done------------------------
     #---------- t[2]-----------------------------------
    srl $t8, $t6, 24   		# s[2]>>24
    sll $t8, $t8, 2
    add $t9, $t8, $s3  	

    lw $s6, 0($t9)	 	# t[2] = T3[s[2]>>24]
    
    srl $t8, $t7, 16		# s[3]>>16
    and $t8, $t8, 0xff		# (s[3]>>16)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s1
    lw $t9, 0($t9)
    xor $s6, $s6, $t9 		# t[2] = T3[s[2]>>24]^T1[(s[3]>>16)&0xff]
    
    srl $t8, $t4, 8		# s[0]>>8
    and $t8, $t8, 0xff		# (s[0]>>8)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s2	
    lw $t9, 0($t9)
    xor $s6, $s6, $t9		# t[2] = T3[s[2]>>24]^T1[(s[3]>>16)&0xff]^T2[(s[0]>>8)&0xff]
    
    and $t8, $t5, 0xff		# s[1]&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s0

    lw $t9, 0($t9)
    xor $s6, $s6, $t9 		# t[2] = T3[s[2]>>24]^T1[(s[3]>>16)&0xff]^T2[(s[0]>>8)&0xff]^T0[s[1]&0xff]
    
    xor $s6, $s6, $t2		# t[2] = t[2]^rkey[2]		
    
    move $a0, $s6
    li $v0, 34         # print integer as hex
    syscall

    # print new line
    la $a0, newline  
    li $v0, 4
    syscall    
    #---------------t[2] is done------------------------
    #---------- t[3]-----------------------------------
    srl $t8, $t7, 24   		# s[3]>>24
    sll $t8, $t8, 2
    add $t9, $t8, $s3  	

    lw $s7, 0($t9)	 	# t[3] = T3[s[3]>>24]
    
    srl $t8, $t4, 16		# s[0]>>16
    and $t8, $t8, 0xff		# (s[0]>>16)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s1
    lw $t9, 0($t9)
    xor $s7, $s7, $t9 		# t[3] = T3[s[3]>>24]^T1[(s[0]>>16)&0xff]
    
    srl $t8, $t5, 8		# s[1]>>8
    and $t8, $t8, 0xff		# (s[1]>>8)&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s2	
    lw $t9, 0($t9)
    xor $s7, $s7, $t9		# t[3] = T3[s[3]>>24]^T1[(s[0]>>16)&0xff]^T2[(s[1]>>8)&0xff]
    
    and $t8, $t6, 0xff		# s[2]&0xff
    sll $t8, $t8, 2
    add $t9, $t8, $s0

    lw $t9, 0($t9)
    xor $s7, $s7, $t9 		# t[3] = T3[s[3]>>24]^T1[(s[0]>>16)&0xff]^T2[(s[1]>>8)&0xff]^T0[s[2]&0xff]
    
    xor $s7, $s7, $t3		# t[3] = t[3]^rkey[3]		
    
    move $a0, $s7
    li $v0, 34         # print integer as hex
    syscall
    
    move $t0, $s4
    sw $t0, 0($a1)
    
    move $t0, $s5
    sw $t0, 4($a1)
    
    move $t0, $s6
    sw $t0, 8($a1)
    
    move $t0, $s7
    sw $t0, 12($a1)
    #---------------t[3] is done------------------------       
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $s0, 12($sp)
    lw $s1, 16($sp)
    lw $s2, 20($sp)
    lw $s3, 24($sp)
    lw $s4, 28($sp)
    lw $s5, 32($sp)
    lw $s6, 36($sp)
    lw $s7, 40($sp)
    addi $sp, $sp, 44
    jr $ra



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
    # a0'da input buffer var
    #a1'de output word var
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
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    sll $s0, $s0, 8
    xor $t4, $t1, 10
    beqz $t4, print_loop
    add $s0, $s0, $t1
    j print_loop         # repeat

end_print_loop:
    sw $s0, 0($a1)
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4
    
print_loop2:
    beqz $t2, end_print_loop2  
    lb $t1, 0($t0)       # load byte from string   
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    sll $s0, $s0, 8
    xor $t4, $t1, 10
    beqz $t4, print_loop2
    add $s0, $s0, $t1
    j print_loop2         # repeat

end_print_loop2:
    sw $s0, 4($a1)
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4    

print_loop3:
    beqz $t2, end_print_loop3  
    lb $t1, 0($t0)       # load byte from string   
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    sll $s0, $s0, 8
    xor $t4, $t1, 10
    beqz $t4, print_loop3
    add $s0, $s0, $t1
    j print_loop3         # repeat

end_print_loop3:
    sw $s0, 8($a1)
    li $v0, 34           
    move $a0, $s0
    syscall
    li $t2, 4    
    
print_loop4:
    beqz $t2, end_print_loop4 
    lb $t1, 0($t0)       # load byte from string   
    addiu $t0, $t0, 1    # increment the address
    subi $t2, $t2, 1
    sll $s0, $s0, 8
    xor $t4, $t1, 10
    beqz $t4, print_loop4
    add $s0, $s0, $t1
    j print_loop4         # repeat

end_print_loop4:
    sw $s0, 12($a1)

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
    move $t3, $a1        # a1 contains size
    addi $t3, $t3, 14   
    div $t3, $t3, 16
    
parse_all_loop:
    beqz $t3, end_parse_all
    la $a1, converted_msg
    jal print_chars         # convert and print as hexadecimal
    
    move $t1, $v0
    la $a0, newline         # print new line
    li $v0, 4
    syscall
    move $a0, $t1
    subi $t3, $t3, 1
    j parse_all_loop

end_parse_all:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
 
 
