## Polling - Efrén BOYARIZO GARGALLO

#### 1. Open the `io.s` file with the RARS editor, study the code and try to understand it. In order to understand what the various syscalls are doing and how they are called, you will need the `Syscalls` tab of the help window of RARS.

> We have three functions:
>
> * getc: reads character from the keyboard by calling the blocking syscall ReadChar. The read character is stored in A0
> * putc: prints in the console the character stored in A0
> * main: is an infinite loop. Prints the enter_char_message, waits for the character input, prints print_char_message, prints the character and compares it with Q. If it is Q, then it exits execution (printing bye_message) with code 0, if not restarts the program

#### 2. Observe how the various functions are written, how they are called, how their input parameters and output results are passed between callers and callees, how the return addresses are handled, how the stack frames are managed and what they are used for. Does the code comply with the ILP32 ABI?

> The code does comply with ILP32 ABI for the following reasons:
>
> * Functions parameters are passed and return in A0 register
>
> * The return value is stored in S0 which is a saved register
>
> * The stack is decreased or increased in order to save the return address or pop them
>
> * The program ends execution with code 0 to indicate that it has finished executing correctly

#### 3. Assemble `io.s` and simulate. After entering (and displaying) several characters reset the simulation (`[Run -> Reset]`) and start executing step-by-step (`[Run -> Step]`). After stepping over the `ReadChar` syscall do not forget to enter a character. Before each step, try to understand what instruction will be executed and what its effect should be. Cross-check your guessing by looking at the content of the registers (including the Program Counter - PC) before and after the step.

> The code works as expected, and only exist execution when the character 'Q' is entered. The registers use follow the ILP32 ABI and the function calls return back to their expected values. So the program handles correctly the stack

#### 4. Edit `io.s` and modify the code to add a `puti` function that prints the integer in register `a0`. Also add a `print_ascii_message` in the `data` segment with value `\nThe ASCII code of the character you entered is: `. Modify the `main` function to print `print_ascii_message` instead of `print_char_message`, and to use `puti` instead of `putc` to print the ASCII code of the entered character instead of the character itself. Test your modification.

> To print the integer value we can use the PrintInt syscall. Modifying the function putc by changing the number of the syscall to 1.
> 
> Additionally to to print the new message, we can add a new .asciiz tag and the new message. Changing this tag before challing the SysCall 4 in main prints our new message

#### 5. Use your application to find the ASCII codes of characters #, u and $

> \# = 35
> 
> u = 117
> 
> $ = 36
