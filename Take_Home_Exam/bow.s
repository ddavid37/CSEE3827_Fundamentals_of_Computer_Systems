.text

isletter:
    # Check if the character is in the range 'A' to 'Z'
    li      $t0,                    65                                          # ASCII value of 'A'
    li      $t1,                    90                                          # ASCII value of 'Z'
    bge     $a0,                    $t0,                    check_upper_end
    j       check_lower                                                         # Skip to lowercase check if less than 'A'

check_upper_end:
    ble     $a0,                    $t1,                    return_true         # If <= 'Z', it's a letter

check_lower:
    # Check if the character is in the range 'a' to 'z'
    li      $t0,                    97                                          # ASCII value of 'a'
    li      $t1,                    122                                         # ASCII value of 'z'
    bge     $a0,                    $t0,                    check_lower_end
    j       return_false                                                        # If less than 'a', it's not a letter

check_lower_end:
    ble     $a0,                    $t1,                    return_true         # If <= 'z', it's a letter

return_false:
    li      $v0,                    0                                           # Not a letter
    jr      $ra                                                                 # Return to caller

return_true:
    li      $v0,                    1                                           # It's a letter
    jr      $ra                                                                 # Return to caller


    #### Do not move this separator. Place all of your isletter code above this line. ####

lettersmatch:
    # Convert $a0 (first letter) to uppercase if it's lowercase
    li      $t0,                    97                                          # ASCII value of 'a'
    li      $t1,                    122                                         # ASCII value of 'z'
    li      $t2,                    32                                          # Difference between uppercase and lowercase
    bge     $a0,                    $t0,                    check_a0_uppercase
    j       check_a1                                                            # Skip if already uppercase

check_a0_uppercase:
    ble     $a0,                    $t1,                    convert_a0
    j       check_a1                                                            # Skip if not lowercase


convert_a0:
    sub     $a0,                    $a0,                    $t2                 # Convert to uppercase
    j       check_a1

check_a1:
    # Convert $a1 (second letter) to uppercase if it's lowercase
    li      $t0,                    97                                          # ASCII value of 'a'
    li      $t1,                    122                                         # ASCII value of 'z'
    bge     $a1,                    $t0,                    check_a1_uppercase
    j       compare_letters                                                     # Skip if already uppercase

check_a1_uppercase:
    ble     $a1,                    $t1,                    convert_a1
    j       compare_letters                                                     # Skip if not lowercase

convert_a1:
    sub     $a1,                    $a1,                    $t2                 # Convert to uppercase

compare_letters:
    # Compare $a0 and $a1
    beq     $a0,                    $a1,                    letters_match
    j       letters_dont_match

letters_match:
    li      $v0,                    1                                           # Letters match
    jr      $ra                                                                 # Return to caller

letters_dont_match:
    li      $v0,                    0                                           # Letters don't match
    jr      $ra                                                                 # Return to caller

    #### Do not move this separator. Place all of your lettersmatch code above this line, and below previous separator. ###

nextword:
    # replace thiese instructions with your code
    addi    $sp,                    $sp,                    -8
    sw      $ra,                    0($sp)
    sw      $ra,                    4($sp)

curr_word:
    move    $t9,                    $a0
    lbu     $t5,                    0($t0)
    beq     $t5,                    $zero,                  end
    move    $a0,                    $t9
    beq     $v0,                    $zero,                  skip_gap
    addi    $a0,                    $a0,                    1
    jal     curr_word

skip_gap:
    move    $t9,                    $a0
    lbu     $t5,                    0($t0)
    beq     $t5,                    $zero,                  end
    move    $a0,                    $t5
    jal     isletter
    move    $a0,                    $t9
    bne     $v0,                    $zero,                  return
    addi    $a0,                    $a0,                    1
    jal     skip_gap

return:
    move    $v0,                    $a0
    lw      a0,                     0($sp)
    lw      ra,                     4($sp)
    addi    $sp,                    $sp,                    8
    jr      $ra

    # First, if we're inside a word, skip to end of current word
skip_current:
    # Load current character
    lbu     $a0,                    0($s0)

    # If null terminator, return 0
    beqz    $a0,                    nextword_not_found

    # Check if current char is letter
    jal     isletter

    # If not a letter, move to finding next word
    beqz    $v0,                    find_next

    # Still in word, keep moving
    addi    $s0,                    $s0,                    1
    j       skip_current

find_next:
    # Load current character
    lbu     $a0,                    0($s0)

    # If null terminator, return 0
    beqz    $a0,                    nextword_not_found

    # Check if current char is letter
    jal     isletter

    # If it's a letter, we found the start of next word
    bnez    $v0,                    nextword_found

    # Not a letter, keep looking
    addi    $s0,                    $s0,                    1
    j       find_next

nextword_found:
    # Return pointer to start of word
    move    $v0,                    $s0
    j       nextword_return

nextword_not_found:
    # Return 0 if no word found
    li      $v0,                    0

nextword_return:
    # Restore saved registers
    lw      $ra,                    0($sp)
    lw      $s0,                    4($sp)
    addi    $sp,                    $sp,                    8
    jr      $ra

    #### Do not move this separator. Place all of your nextword code above this line, and below previous separator. ###

wordsmatch:
    # replace these instructions with your code
    li      $v0,                    0
    jr      $ra

    #### Do not move this separator. Place all of your nextword code above this line, and below previous separator. ###

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

