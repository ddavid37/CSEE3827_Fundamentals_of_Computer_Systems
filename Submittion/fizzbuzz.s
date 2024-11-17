fizzbuzz:
    # Preserve $ra on the stack
    addi    $sp,                    $sp,                -4
    sw      $ra,                    0($sp)

    # Initialize the loop variable
    li      $t0,                    1                                           # $t0 will hold the current number in the loop

loop_start:
    # Check if $t0 is greater than the input value in $a0
    bgt     $t0,                    $a0,                end_loop

    # Check if $t0 is a multiple of both 3 and 5
    li      $t1,                    3
    rem     $t2,                    $t0,                $t1                     # $t2 = $t0 % 3
    li      $t1,                    5
    rem     $t3,                    $t0,                $t1                     # $t3 = $t0 % 5
    beq     $t2,                    0,                  fizz_check
    j       number_print                                                        # If not a multiple of 3 or 5, print the number

fizz_check:
    beq     $t3,                    0,                  print_fizzbuzz_label    # If both $t2 and $t3 are zero, print "fizzbuzz"
    j       fizz_only                                                           # If only $t2 is zero, print "fizz"

buzz_check:
    beq     $t3,                    0,                  buzz_only               # If only $t3 is zero, print "buzz"

number_print:
    # Print the number
    move    $a0,                    $t0                                         # Put the current number in $a0 for print_int
    jal     print_int
    j       increment_loop                                                      # Go to the next iteration

print_fizzbuzz_label:
    jal     print_fizzbuzz_func
    j       increment_loop

fizz_only:
    jal     print_fizz
    j       increment_loop

buzz_only:
    jal     print_buzz
    j       increment_loop

increment_loop:
    # Increment the loop variable
    addi    $t0,                    $t0,                1
    j       loop_start                                                          # Go to the next iteration

end_loop:
    # Restore $ra and return
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra

    #### Do not remove this separator. Place all of your code above this line. ####

main:
    addi    $sp,                    $sp,                -4
    sw      $ra,                    0($sp)

    # fizzbuzz(10)
    li      $a0,                    10
    jal     fizzbuzz
    jal     print_newline

    # fizzbuzz(20)
    li      $a0,                    20
    jal     fizzbuzz
    jal     print_newline

    # fizzbuzz(100)
    li      $a0,                    100
    jal     fizzbuzz

    # return
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra

print_newline:
    li      $v0,                    11
    li      $a0,                    10
    syscall
    jr      $ra

print_string:
    li      $v0,                    4
    syscall
    jr      $ra

print_fizz:
    addi    $sp,                    $sp,                -4
    sw      $ra,                    0($sp)
    la      $a0,                    fizz_string
    jal     print_string
    jal     print_newline
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra

print_buzz:
    addi    $sp,                    $sp,                -4
    sw      $ra,                    0($sp)
    la      $a0,                    buzz_string
    jal     print_string
    jal     print_newline
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra

print_fizzbuzz:
    addi    $sp,                    $sp,                -4
    sw      $ra,                    0($sp)
    la      $a0,                    fizzbuzz_string
    jal     print_string
    jal     print_newline
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra

print_int:
    addi    $sp,                    $sp,                -4
    sw      $ra,                    0($sp)
    li      $v0,                    1
    syscall
    jal     print_newline
    lw      $ra,                    0($sp)
    addi    $sp,                    $sp,                4
    jr      $ra


.data

fizz_string:        .asciiz "fizz"
buzz_string:        .asciiz "buzz"
fizzbuzz_string:    .asciiz "fizzbuzz"
