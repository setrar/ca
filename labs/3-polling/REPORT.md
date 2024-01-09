# Lab 3

### 2

The code in `mmio.s` wait for a character to be sent using the `MMIO Keyboard Tool`. It then sent it to the `MMIO Display Tool`.

### 5

When entering a character (i.e., `a`) its ASCII code (i.e., `97`) is stored in the memory at address `0xfff0004`. Then the memory is read, and the character is stored in `a0`.

### 9

If we were to merge the `wait_for_trans_1` and `wait_for_trans_2` functions, we should be able to speed up the program.  
We could also speed it up by not doing the initialization every iteration of the loop.
