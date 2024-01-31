# compute and return n! = 1*2*3*...*n
# n passed in a0, result returned in a0
factorial:
  addi sp,sp,-8      # allocate 8 bytes stack frame (2 words)
  sw   ra,0(sp)      # save ra in stack frame
  sw   s0,4(sp)      # save s0 in stack frame
  addi s0,zero,3     # s0 <- 3
  bltu a0,s0,end     # go to end if a0 (n) unsigned-less than s0 (3)
  add  s0,zero,a0    # save a0 (n) in s0
  addi a0,a0,-1      # a0 <- a0-1
  jal  ra,factorial  # call factorial, a0 <- factorial(n-1)
  mul  a0,a0,s0      # a0 <- a0*s0 = factorial(n-1)*n
end:
  lw   s0,4(sp)      # restore s0 from stack frame
  lw   ra,0(sp)      # restore ra from stack frame
  addi sp,sp,8       # deallocate stack frame, restore sp
  jalr zero,ra,0     # return to caller, the result is in a0


.data
    buffer: .space 16  # Allocate a 16-byte buffer for storing ASCII characters

.text

# Function: print_integer
# Description: Print an integer to the console
# Parameters: Integer to print in a0
# Return: None
print_integer:
    addi  sp, sp, -16   # Allocate stack frame (4 registers to save = 4*4 = 16 bytes)
    sw    ra, 0(sp)     # Save ra on stack
    sw    s0, 4(sp)     # Save s0 on stack
    sw    s1, 8(sp)     # Save s1 on stack
    sw    s2, 12(sp)    # Save s2 on stack

    mv    s0, a0        # Copy the integer to s0
    li    s1, 10        # Set s1 to 10 (decimal base)
    mv    s2, zero      # Initialize s2 to 0 (used for digit count)
    la    a1, buffer    # Load the address of the buffer into a1

    # Handle the case of zero separately
    beqz  s0, print_zero

    print_integer_loop:
        la    a1, buffer    # Load the address of the buffer into a1
        rem   a0, s0, s1    # Calculate remainder (last digit)
        addi  a0, a0, 48    # Convert remainder to ASCII
        addi  s2, s2, 1     # Increment digit count
        sb    a0, 0(a1)     # Store ASCII character in the buffer
        addi  a1, a1, 1     # Move to the next buffer location
        divu  s0, s0, s1    # Divide s0 by 10
        bnez  s0, print_integer_loop  # Repeat until s0 becomes 0

    print_integer_reverse_loop:
        addi  a1, a1, -1    # Move back to the last buffer location
        lb    a0, 0(a1)     # Load the ASCII character
        addi  a7, zero, 11  # Syscall code for PrintChar
        ecall               # Print the character
        beqz  s2, print_end # Exit loop if all digits printed
        addi  s2, s2, -1    # Decrement digit count
        b     print_integer_reverse_loop

    print_end:
        lw    ra, 0(sp)     # Restore ra from stack
        lw    s0, 4(sp)     # Restore s0 from stack
        lw    s1, 8(sp)     # Restore s1 from stack
        lw    s2, 12(sp)    # Restore s2 from stack
        addi  sp, sp, 16    # Deallocate stack frame
        ret                 # Return to caller

    print_zero:
        li    a0, 48        # Load ASCII '0'
        addi  a7, zero, 11  # Syscall code for PrintChar
        ecall               # Print '0'
        b      print_end    # Jump to the end

.global main

main:
  li    a0, 6         # 6! = 720
  call  factorial 
  mv    s0,a0         # copy read character in s0
  call  print_integer # call putc function to print character

  addi  a0, x0, 0     # Use 0 return code
  addi  a7, x0, 93    # Service command code 93 terminates
  ecall               # Call linux to terminate the program