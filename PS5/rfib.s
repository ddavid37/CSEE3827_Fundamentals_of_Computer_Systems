rfib:
    # Base case for rfib(0)
    beq     $a0,            0,      rfib_zero
    # Base case for rfib(1)
    beq     $a0,            1,      rfib_one

    # Recursive case: calculate rfib(n-1) + rfib(n-2)
    # Save $a0 (n) on the stack
    addi    $sp,            $sp,    -4
    sw      $a0,            0($sp)

    # Calculate rfib(n-1)
    addi    $a0,            $a0,    -1
    jal     rfib
    # Save result of rfib(n-1) in $t0
    move    $t0,            $v0

    # Restore $a0 (n) and calculate rfib(n-2)
    lw      $a0,            0($sp)
    addi    $a0,            $a0,    -2
    jal     rfib
    # Result of rfib(n-2) is in $v0

    # Add rfib(n-1) and rfib(n-2) with unsigned addition to avoid overflow exception
    addu    $v0,            $t0,    $v0

    # Restore $a0 and return
    lw      $a0,            0($sp)
    addi    $sp,            $sp,    4
    jr      $ra

rfib_zero:
    li      $v0,            0
    jr      $ra

rfib_one:
    li      $v0,            1
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
