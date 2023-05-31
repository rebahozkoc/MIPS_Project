.data
T0: .space 4                           # the pointers to your lookup tables
T1: .space 4
T2: .space 4
T3: .space 4            
newline: .asciiz "\n
s: .word 0xd82c07cd, 0xc2094cbd, 0x6baa9441, 0x42485e3f
rkey: .word 0x82e2e670, 0x67a9c37d, 0xc8a7063b, 0x4da5e71f


.text


main:


    #la $a1, T0        # Address of T0 in $a1
    #lw $a0, 0($a1)    # address of array pointed by T0 is at a0. bunu kullan

    #move $a0, $v0   # T0 yazdiriliyor
    #lw $a1, s     # T0 size a1 de ama byte seklinde
    #srl $a1, $a1, 2  # divide by 4
    
    # Load the state and round key into registers
    la $s0, s
    la $s1, rkey
    
    jal roundFunc
    
    
    
    # Exit program
    li $v0, 10
    syscall
    
roundFunc:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)    # round key r
    sw $a1, 8($sp)    # state s
    
    
    
endRoundFunc:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    addi $sp, $sp, 12
    jr $ra