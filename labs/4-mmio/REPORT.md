### Lab 4: MMIO - Efrén BOYARIZO GARGALLO

# Summary
> Overall, my implementation of the `io.s` program differs in that it waits for the user to press enter in order to print the error message. This for both overflows and NaN errors.

> Regarding the implementation, we have several new functions to implement:
> 1. `getc`: we now need to use MMIO, and for that we read from address `0xffff0000` to check if new data is available and if so we read from `0xffff0004`, else we loop until data is available
> 2. `putc`: using MMIO as well, we wait for `0xffff0008` to be equal to 1 indicating we can now write the character in `0xffff0012`
> 3. `print_string`: from the parameter passed, we read from the address until we find a `\0` (incrementing at each loop the address by 1), the character read is then passed onto putc to print the string in the MMIO
> 4. `d2i`: to convert from ASCII to integer representation we can subtract the offset of character `0` which is `48`. To detect if our character is not a number (NaN) we can compare with the lower limit of 48 and upper limit of 57. If it is not in the range we know it is not a number
> 5. `geti`: has a main loop that reads a character with getc and converts it to integer with d2i. To read the multicharacter number each time we loop we must multiply the previous number by 10 and then add the new number. One of the difficulties I've found is with detecting the overflows. My first idea was to detect if it was less than the previous number, but this implementation was not correct. I did not find another method except for the one given in the `.io.s` file in the next lab