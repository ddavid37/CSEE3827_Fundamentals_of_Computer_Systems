    # Replace the line below with your code
minbills:
    # At the start of minbills, the argument is in $a0.

    li      $t0,            0                   # Initialize count to 0
    move    $t1,            $a0                 # Initialize currvalue to totalvalue (argument in $a0)

while_10:
    bge     $t1,            10,     subtract_10 # If currvalue >= 10, go to subtract_10
    j       while_5                             # Otherwise, jump to the next loop

subtract_10:
    addi    $t0,            $t0,    1           # count += 1
    addi    $t1,            $t1,    -10         # currvalue -= 10
    j       while_10                            # Repeat the 10-loop check

while_5:
    bge     $t1,            5,      subtract_5  # If currvalue >= 5, go to subtract_5
    j       while_1                             # Otherwise, jump to the next loop

subtract_5:
    addi    $t0,            $t0,    1           # count += 1
    addi    $t1,            $t1,    -5          # currvalue -= 5
    j       while_5                             # Repeat the 5-loop check

while_1:
    bge     $t1,            1,      subtract_1  # If currvalue >= 1, go to subtract_1
    j       loop_exit                           # Otherwise, exit the loop

subtract_1:
    addi    $t0,            $t0,    1           # count += 1
    addi    $t1,            $t1,    -1          # currvalue -= 1
    j       while_1                             # Repeat the 1-loop check

loop_exit:
    move    $v0,            $t0                 # Move the result (count) to $v0 for return

return:
    # Your       return value should be in $v0 prior to returning
    jr      $ra                                 # Return to the calling function

    #### Do not remove this separator. Place all of your code above this line. ####

main:
    addi    $sp,            $sp,    -4
    sw      $ra,            0($sp)

    # minbills(10) = 1
    li      $a0,            10
    jal     minbills
    move    $a0,            $v0
    jal     print_int

    # minbills(40) = 4
    li      $a0,            40
    jal     minbills
    move    $a0,            $v0
    jal     print_int

    # minbills(57) = 8
    li      $a0,            57
    jal     minbills
    move    $a0,            $v0
    jal     print_int

    # minbills(156) = 17
    li      $a0,            156
    jal     minbills
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

print_string:
    li      $v0,            4
    syscall
    jr      $ra
