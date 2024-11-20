.text

isletter:
    li      $t1,                    65
    li      $t2,                    90
    li      $t3,                    97
    li      $t4,                    122

    # check if char is in range A-Z or a-z
    bgt     $a0,                    $t2,                    check_a

    bgt     $t1,                    $a0,                    zero_value
    bgt     $a0,                    $t2,                    zero_value
    li      $v0,                    1
    jr      $ra

check_a:
    bgt     $t3,                    $a0,                    zero_value
    bgt     $a0,                    $t4,                    zero_value
    li      $v0,                    1
    jr      $ra

zero_value:

    li      $v0,                    0
    jr      $ra

    #### Do not move this separator. Place all of your isletter code above this line, and below previous separator. ###

    # check if two characters match
lettersmatch:
    li      $t8,                    32
    beq     $a1,                    $a0,                    link_one
    slt     $v0,                    $a0,                    $a1
    beq     $v0,                    $zero,                  sub_a
    sub     $v0,                    $a1,                    $a0
    beq     $v0,                    $t8,                    link_one
    li      $v0,                    0
    jr      $ra

sub_a:
    sub     $v0,                    $a0,                    $a1
    beq     $v0,                    $t8,                    link_one
    li      $v0,                    0
    jr      $ra

link_one:
    li      $v0,                    1
    jr      $ra

    #### Do not move this separator. Place all of your lettersmatch code above this line, and below previous separator. ###

    # find the next word in a string
nextword:
    addi    $sp,                    $sp,                    -8
    sw      $a0,                    0($sp)
    sw      $ra,                    4($sp)

curr_word:
    move    $t9,                    $a0
    lbu     $t5,                    0($a0)
    beq     $t5,                    $zero,                  end
    move    $a0,                    $t5
    jal     isletter
    move    $a0,                    $t9
    beq     $v0,                    $zero,                  skip_gap
    addi    $a0,                    $a0,                    1
    j       curr_word

skip_gap:
    move    $t9,                    $a0
    lbu     $t5,                    0($a0)
    beq     $t5,                    $zero,                  end
    move    $a0,                    $t5
    jal     isletter
    move    $a0,                    $t9
    bne     $v0,                    $zero,                  return
    addi    $a0,                    $a0,                    1
    j       skip_gap

return:
    move    $v0,                    $a0
    lw      $a0,                    0($sp)
    lw      $ra,                    4($sp)
    addi    $sp,                    $sp,                    8
    jr      $ra

end:
    li      $v0,                    0
    lw      $a0,                    0($sp)
    lw      $ra,                    4($sp)
    addi    $sp,                    $sp,                    8
    jr      $ra

    #### Do not move this separator. Place all of your nextword code above this line, and below previous separator. ###

wordsmatch:
    addi    $sp,                    $sp,                    -12         # Save to stack (12 bytes)
    sw      $ra,                    0($sp)                              # Save return address
    sw      $a0,                    4($sp)                              # Save first word
    sw      $a1,                    8($sp)                              # Save second word

check_value:
    move    $t7,                    $a0                                 # Save first word
    move    $t4,                    $a1                                 # Save second word
    lbu     $s0,                    0($a0)                              # Load byte from first word
    lbu     $s1,                    0($a1)                              # Load byte from second word
    beq     $s0,                    $zero,                  end_check   # Check for null terminator in first word
    beq     $s1,                    $zero,                  end_check   # Check for null terminator in second word
    move    $a0,                    $s0
    move    $a1,                    $s1
    jal     lettersmatch                                                # Call lettersmatch
    move    $a0,                    $t7                                 # Restore first word
    move    $a1,                    $t4                                 # Restore second word
    bne     $v0,                    $zero,                  next_value  # If letters don't match, go to next_value
    move    $a0,                    $s0
    move    $a1,                    $s1
    jal     isletter                                                    # Check if first letter is valid
    move    $t6,                    $v0
    move    $a0,                    $a1
    jal     isletter                                                    # Check if second letter is valid
    move    $a0,                    $t7                                 # Restore first word
    move    $a1,                    $t4                                 # Restore second word
    beq     $t6,                    $zero,                  end_check   # If first letter is not valid, end check
    beq     $v0,                    $zero,                  end_check   # If second letter is not valid, end check
    j       check_value                                                 # Continue checking next character

next_value:
    jal     isletter                                                    # Check if first letter is valid
    move    $t6,                    $v0                                 # Save return value for first letter
    move    $a0,                    $a1                                 # Move to next character in second word
    jal     isletter                                                    # Check if second letter is valid
    move    $a1,                    $t7                                 # Restore first word
    beq     $t6,                    $zero,                  end_check   # If first letter is not a letter, return 0
    addi    $a0,                    $a0,                    1           # Move to next char in first word
    addi    $a1,                    $a1,                    1           # Move to next char in second word
    j       check_value                                                 # Continue checking next characters

end_check:
    beq     $t6,                    $v0,                    return_one  # If both strings end, return 1
    j       return_zero                                                 # If one string ends, return 0

return_one:
    li      $v0,                    1                                   # Return 1
    lw      $ra,                    0($sp)                              # Restore return address
    lw      $a0,                    4($sp)                              # Restore first word
    lw      $a1,                    8($sp)                              # Restore second word
    addi    $sp,                    $sp,                    12          # Restore stack
    jr      $ra                                                         # Return

return_zero:
    li      $v0,                    0                                   # Return 0
    lw      $ra,                    0($sp)                              # Restore return address
    lw      $a0,                    4($sp)                              # Restore first word
    lw      $a1,                    8($sp)                              # Restore second word
    addi    $sp,                    $sp,                    12          # Restore stack
    jr      $ra                                                         # Return

    #### Do not move this separator. Place all of your wordsmatch code above this line, and below previous separator. ###

main:
    # save to stack
    addi    $sp,                    $sp,                    -12
    sw      $ra,                    0($sp)
    sw      $s0,                    4($sp)
    sw      $s1,                    8($sp)

    ########################################
    la      $s0,                    isletter_tests

    # isletter(@) = 0
    lbu     $a0,                    0($s0)
    jal     isletter_test

    # isletter(A) = 1
    lbu     $a0,                    1($s0)
    jal     isletter_test

    # isletter(z) = 1
    lbu     $a0,                    2($s0)
    jal     isletter_test

    # isletter({) = 0
    lbu     $a0,                    3($s0)
    jal     isletter_test

    # isletter(Z) = 1
    lbu     $a0,                    4($s0)
    jal     isletter_test

    # isletter([) = 0
    lbu     $a0,                    5($s0)
    jal     isletter_test

    # isletter(a) = 1
    lbu     $a0,                    6($s0)
    jal     isletter_test

    # isletter(`) = 0
    lbu     $a0,                    7($s0)
    jal     isletter_test

    ########################################
    la      $s0,                    lettersmatch_tests

    # lettersmatch(X, X) = 1
    lbu     $a0,                    0($s0)
    lbu     $a1,                    1($s0)
    jal     lettersmatch_test

    # lettersmatch(X, x) = 1
    lbu     $a0,                    2($s0)
    lbu     $a1,                    3($s0)
    jal     lettersmatch_test

    # lettersmatch(b, a) = 0
    lbu     $a0,                    4($s0)
    lbu     $a1,                    5($s0)
    jal     lettersmatch_test

    # lettersmatch(m, M) = 1
    lbu     $a0,                    6($s0)
    lbu     $a1,                    7($s0)
    jal     lettersmatch_test

    # lettersmatch(e, a) = 0
    lbu     $a0,                    8($s0)
    lbu     $a1,                    9($s0)
    jal     lettersmatch_test

    # lettersmatch(C, N) = 0
    lbu     $a0,                    10($s0)
    lbu     $a1,                    11($s0)
    jal     lettersmatch_test

    # lettersmatch(D, d) = 1
    lbu     $a0,                    12($s0)
    lbu     $a1,                    13($s0)
    jal     lettersmatch_test

    ########################################
    la      $s0,                    dogbitesman

    # nextword(pointer to "Dog bites man.") = pointer to "bites man."
    addi    $a0,                    $s0,                    0
    jal     nextword_test

    # nextword(pointer to "og bites man.") = pointer to "bites man."
    addi    $a0,                    $s0,                    1
    jal     nextword_test

    # nextword(pointer to "g bites man.") = pointer to "bites man."
    addi    $a0,                    $s0,                    2
    jal     nextword_test

    # nextword(pointer to " bites man.") = pointer to "bites man."
    addi    $a0,                    $s0,                    3
    jal     nextword_test

    # nextword(pointer to "man.") = 0
    addi    $a0,                    $s0,                    10
    jal     nextword_test

    # nextword(pointer to ".") = 0
    addi    $a0,                    $s0,                    13
    jal     nextword_test

    la      $s0,                    dogbitesman2

    # nextword(pointer to "Dog-bites&2man!!") = pointer to "bites&2man!!"
    addi    $a0,                    $s0,                    0
    jal     nextword_test

    # nextword(pointer to "ites&2man!!") = pointer to "man!!"
    addi    $a0,                    $s0,                    5
    jal     nextword_test

    # nextword(pointer to "2man!!") = pointer to "man!!"
    addi    $a0,                    $s0,                    10
    jal     nextword_test

    # nextword(pointer to "an!!") = 0
    addi    $a0,                    $s0,                    12
    jal     nextword_test

    # nextword(pointer to "!!") = 0
    addi    $a0,                    $s0,                    14
    jal     nextword_test

    ########################################
    la      $s0,                    dogbitesman
    la      $s1,                    dogbitesman2

    # wordsmatch("Dog bites man.", "Dog-bites&2man!!") = 1
    addi    $a0,                    $s0,                    0
    addi    $a1,                    $s1,                    0
    jal     wordsmatch_test

    # wordsmatch("bites man.", "bites&2man!!") = 1
    addi    $a0,                    $s0,                    4
    addi    $a1,                    $s1,                    4
    jal     wordsmatch_test

    # wordsmatch("man.", "man!!") = 1
    addi    $a0,                    $s0,                    10
    addi    $a1,                    $s1,                    11
    jal     wordsmatch_test

    # wordsmatch("an.", "man!!") = 0
    addi    $a0,                    $s0,                    11
    addi    $a1,                    $s1,                    11
    jal     wordsmatch_test

    # wordsmatch("an.", "an!!") = 1
    addi    $a0,                    $s0,                    11
    addi    $a1,                    $s1,                    12
    jal     wordsmatch_test

    # wordsmatch("Dog bites man.", "bites&2man!!") = 0
    addi    $a0,                    $s0,                    0
    addi    $a1,                    $s1,                    4
    jal     wordsmatch_test

    # wordsmatch("Dog bites man.", "man!!") = 0
    addi    $a0,                    $s0,                    0
    addi    $a1,                    $s1,                    11
    jal     wordsmatch_test

    # wordsmatch("man.", "Dog-bites&2man!!") = 0
    addi    $a0,                    $s0,                    10
    addi    $a1,                    $s1,                    0
    jal     wordsmatch_test

    la      $s0,                    dogbitesman
    la      $s1,                    manbitesdog

    # wordsmatch("Dog bites man.", "Man bites dog.") = 0
    addi    $a0,                    $s0,                    0
    addi    $a1,                    $s1,                    0
    jal     wordsmatch_test

    # wordsmatch("Dog bites man.", "dog.") = 1
    addi    $a0,                    $s0,                    0
    addi    $a1,                    $s1,                    10
    jal     wordsmatch_test

    # wordsmatch("man.", "dog.") = 0
    addi    $a0,                    $s0,                    10
    addi    $a1,                    $s1,                    10
    jal     wordsmatch_test

    # wordsmatch("bites man.", "bites dog.") = 1
    addi    $a0,                    $s0,                    4
    addi    $a1,                    $s1,                    4
    jal     wordsmatch_test

    # restore from stack
    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    lw      $s1,                    8($sp)
    addi    $sp,                    $sp,                    12

    # return
    jr      $ra

    # print space to console
print_space:
    li      $a0,                    32
    li      $v0,                    11
    syscall
    jr      $ra

    # print newline to console
print_newline:
    li      $a0,                    10
    li      $v0,                    11
    syscall
    jr      $ra

    # print char to console
print_char:
    li      $v0,                    11
    syscall
    jr      $ra

    # print string to console
print_string:
    li      $v0,                    4
    syscall
    jr      $ra

    # print int to console
print_int:
    li      $v0,                    1
    syscall
    jr      $ra

    # same arguments as isletter, no return value
isletter_test:
    addi    $sp,                    $sp,                    -8
    sw      $ra,                    0($sp)
    sw      $s0,                    4($sp)

    # s0: char
    move    $s0,                    $a0

    # print msg1
    la      $a0,                    isletter_test_msg1
    jal     print_string

    # print input char
    move    $a0,                    $s0
    jal     print_char

    # print msg2
    la      $a0,                    isletter_test_msg2
    jal     print_string

    # call isletter
    move    $a0,                    $s0
    jal     isletter

    # print result
    move    $a0,                    $v0
    jal     print_int
    jal     print_newline

    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    addi    $sp,                    $sp,                    8
    jr      $ra

    # same arguments as lettersmatch, no return value
lettersmatch_test:
    addi    $sp,                    $sp,                    -12
    sw      $ra,                    0($sp)
    sw      $s0,                    4($sp)
    sw      $s1,                    8($sp)

    # s0, s1: chars
    move    $s0,                    $a0
    move    $s1,                    $a1

    # print msg1
    la      $a0,                    lettersmatch_test_msg1
    jal     print_string

    # print input char
    move    $a0,                    $s0
    jal     print_char

    # print msg2
    la      $a0,                    lettersmatch_test_msg2
    jal     print_string

    # print other input char
    move    $a0,                    $s1
    jal     print_char

    # print msg3
    la      $a0,                    lettersmatch_test_msg3
    jal     print_string

    # call lettersmatch
    move    $a0,                    $s0
    move    $a1,                    $s1
    jal     lettersmatch

    # print result
    move    $a0,                    $v0
    jal     print_int
    jal     print_newline

    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    lw      $s1,                    8($sp)
    addi    $sp,                    $sp,                    12
    jr      $ra

    # same arguments as nextword, no return value
nextword_test:
    addi    $sp,                    $sp,                    -8
    sw      $ra,                    0($sp)
    sw      $s0,                    4($sp)

    # s0: argument string
    move    $s0,                    $a0

    # print msg1
    la      $a0,                    nextword_test_msg1
    jal     print_string

    # print input string
    move    $a0,                    $s0
    jal     print_string

    # print msg2
    la      $a0,                    nextword_test_msg2
    jal     print_string

    # call nextword
    move    $a0,                    $s0
    jal     nextword
    beqz    $v0,                    nextword_test_zero

    # print returned string
    move    $s0,                    $v0
    la      $a0,                    nextword_test_msg3
    jal     print_string
    move    $a0,                    $s0
    jal     print_string
    la      $a0,                    nextword_test_msg4
    jal     print_string
    jal     print_newline
    b       nextword_test_return

    # print 0 and be done
nextword_test_zero:
    li      $a0,                    0
    jal     print_int
    jal     print_newline

nextword_test_return:
    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    addi    $sp,                    $sp,                    8
    jr      $ra

    # same arguments as wordsmatch, no return value
wordsmatch_test:
    addi    $sp,                    $sp,                    -12
    sw      $ra,                    0($sp)
    sw      $s0,                    4($sp)
    sw      $s1,                    8($sp)

    # s0, s1: strings
    move    $s0,                    $a0
    move    $s1,                    $a1

    # print msg1
    la      $a0,                    wordsmatch_test_msg1
    jal     print_string

    # print input char
    move    $a0,                    $s0
    jal     print_string

    # print msg2
    la      $a0,                    wordsmatch_test_msg2
    jal     print_string

    # print other input char
    move    $a0,                    $s1
    jal     print_string

    # print msg3
    la      $a0,                    wordsmatch_test_msg3
    jal     print_string

    # call wordsmatch
    move    $a0,                    $s0
    move    $a1,                    $s1
    jal     wordsmatch

    # print result
    move    $a0,                    $v0
    jal     print_int
    jal     print_newline

    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    lw      $s1,                    8($sp)
    addi    $sp,                    $sp,                    12
    jr      $ra

.data

isletter_test_msg1:     .asciiz "isletter("
isletter_test_msg2:     .asciiz ") = "

isletter_tests:         .asciiz "@Az{Z[a`"

lettersmatch_test_msg1: .asciiz "lettersmatch("
lettersmatch_test_msg2: .asciiz ", "
lettersmatch_test_msg3: .asciiz ") = "

lettersmatch_tests:     .asciiz "XXXxbamMeaCNDd"

manbitesdog:            .asciiz "Man bites dog."
dogbitesman:            .asciiz "Dog bites man."
dogbitesman2:           .asciiz "Dog-bites&2man!!"

nextword_test_msg1:     .asciiz "nextword(pointer to \""
nextword_test_msg2:     .asciiz "\") = "
nextword_test_msg3:     .asciiz "pointer to \""
nextword_test_msg4:     .asciiz "\""

wordsmatch_test_msg1:   .asciiz "wordsmatch(\""
wordsmatch_test_msg2:   .asciiz "\", \""
wordsmatch_test_msg3:   .asciiz "\") = "

