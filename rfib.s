rfib:
    # Replace these two instructions with your function
    li      $v0,            0
    jr      $ra
    #### Do not remove this separator. Place all of your code above this line. ####
main:
    addi    $sp,            $sp,    -4
    sw      $ra,            0($sp)

    # rfib(0) = 0
    li      $a0,            0
    jal     rfib
    move    $a0,            $v0
    jal     print_int

    # rfib(4) = 3
    li      $a0,            4
    jal     rfib
    move    $a0,            $v0
    jal     print_int

    # rfib(5) = 5
    li      $a0,            5
    jal     rfib
    move    $a0,            $v0
    jal     print_int

    # return
    lw      $ra,            0($sp)
    addi    $sp,            $sp,    4
    jr      $ra

print_int:
    addi    $sp,            $sp,    -4
    sw      $ra,            0($sp)
    li      $v0,            1
    syscall
    jal     print_newline
    lw      $ra,            0($sp)
    addi    $sp,            $sp,    4
    jr      $ra

print_newline:
    li      $v0,            11
    li      $a0,            10
    syscall
    jr      $ra

