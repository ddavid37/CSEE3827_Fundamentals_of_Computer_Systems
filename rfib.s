    addi    $sp,            $sp,    -8              # Allocate stack space
    sw      $ra,            4($sp)                  # Save return address
    sw      $a0,            0($sp)                  # Save argument

    li      $t0,            1                       # Base case: if n == 1
    beq     $a0,            $t0,    base_case_one
    li      $t0,            0                       # Base case: if n == 0
    beq     $a0,            $t0,    base_case_zero

    addi    $a0,            $a0,    -1              # Recursive case: rfib(n-1)
    jal     rfib
    move    $t1,            $v0                     # Save rfib(n-1) in $t1

    lw      $a0,            0($sp)                  # Restore argument
    addi    $a0,            $a0,    -2              # Recursive case: rfib(n-2)
    jal     rfib
    add     $v0,            $v0,    $t1             # rfib(n) = rfib(n-1) + rfib(n-2)
    j       end_rfib

base_case_one:
    li      $v0,            1                       # rfib(1) = 1
    j       end_rfib

base_case_zero:
    li      $v0,            0                       # rfib(0) = 0

end_rfib:
    lw      $ra,            4($sp)                  # Restore return address
    lw      $a0,            0($sp)                  # Restore argument
    addi    $sp,            $sp,    8               # Deallocate stack space
    jr      $ra                                     # Return

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

