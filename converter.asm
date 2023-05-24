.data

temp: .asciiz "c66363a5"

.text

    # load the address of the string into $a0
    la $a0, temp
    # call the syscall to print the string
    li $v0, 4
    syscall
    
    la $a0, temp
    jal convert_hex_to_bin
    j Exit

convert_hex_to_bin:



Exit:
    li $v0,10
    syscall             #exits the program