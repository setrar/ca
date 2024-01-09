### Lab 3: Polling - Efrén BOYARIZO GARGALLO

# Summary
> Rather than using the Syscalls as in the lab 2, we've replaced them by MMIO keyboard and display. That way out program is interacting directly with simulated peripherals and not using some abstractions implemented by the emulator.
>
> A comprehensive analysis of the functioning of the program as well +the answers to the different questions proposed in the `README.md` can be found below
>

# Questions
#### 2. Study the code in `mmio.s` and try to understand it.

> The code is composed of three parts: 
> 
> 1. Get input: check if input is available by checking LSB at address `0xffff0000`. If 1, then read character stored at memory address `0xffff0004`. If 0 check again the LSB
> 
> 2. Print the character read: check if display is available by verifying that LSB of address `0xffff0008`. If 1, put the character in address `0xffff000c`. If 0, iterate again until the LSB becomes 1
>
> 3. Using the same methodology as the previous step, print a new line character
> 
> 4. Go back to the beginning to process the next character

#### 3.1. Pause the execution ([Run -> Pause]). In the Data Segment sub-window select the 0xffff0000 (MMIO) region to observe the Receiver and Transmitter registers. Enter a character and continue executing step by step. Do you understand what happens?

> When we type a character, the address `0xffff0000` becomes 1 indicating that we have some new data to read. The data is stored  address `0xffff0004`
>
> When we read from `0xffff0004`, address `0xffff0000` goes back to 0 indicating no new data is available
>
> As we have not yet written anything to the terminal, the address `0xffff0008` is 1 indicating that we can write data in address `0xffff000c`
>
> Continuing the execution of the program we can see that when it writes the read character to address `0xffff000c`, the control address `0xffff0008` becomes 0, indicating that we have to wait to print a new character
>
> When finally the character appears on the screen, `0xffff0008` should go back to 1

#### 3.2.  What is the ASCII code of the character you typed? In which register is it stored?
> The ASCII code of the character typed is stored in register a0, and for letter h it corresponds to 104 or 0x68

#### 9. This program could be slightly optimized for speed (number of executed instructions) and footprint (total number of instructions). Do you see how?

> We can reduce footprint by moving the code for reading and printing into their own independent functions:
> 
> 1. read: reads a character and stores it in a0 as a return parameter
> 
> 2. print: prints the character stored in a0 which is the parameter passed to the function
>
> To reduce the number of executed instructions we can store the address where peripherals start (`0xffff0000`) once, and use increments (+0, +4, +8 and +12) in the following instructions to access the correct part of memory. This way we convert 6 "li" instructions into just 1. The address is stored in a2 which is a parameter to all the functions