## Assignments

1. In the RARS `Tools` menu select `Keyboard and Display MMIO simulator`.
   A new window appears; click its `Help` button and read the 4 first paragraphs.

1. Study the code in `mmio.s` and try to understand it.

1. Load `mmio.s` in RARS and assemble it.

1. In the `Keyboard and Display MMIO simulator` window click the `Connect to Program` button.
   Execute the `mmio.s` application, enter characters and check your understanding.

1. Pause the execution (`[Run -> Pause]`).
   In the `Data Segment` sub-window select the `0xffff0000 (MMIO)` region to observe the Receiver and Transmitter registers.
   Enter a character and continue executing step by step.
   Do you understand what happens?
   What is the ASCII code of the character you typed?
   In which register is it stored?

1. If you continue executing step by step you should see the sending of the character you typed to the transmitter.
   Then, you should enter the `wait_for_trans_2` loop that waits until the transmitter is ready again to receive a character.
   Instead of stepping until it is, set a breakpoint on the first instruction after the loop and let the execution continue.

1. After exiting the `wait_for_trans_2` loop, continue step-by-step, observe the printing of the newline character and the branching to the beginning of the program for the next iteration.

1. Once you are done with your experiments click the `Disconnect from Program` and `Reset` buttons of the `Keyboard and Display MMIO simulator` window.

1. This program could be slightly optimized for speed (number of executed instructions) and footprint (total number of instructions).
   Do you see how?

1. Edit `mmio.s` to implement your optimizations.
   Assemble `mmio.s`, click the `Connect to Program` button of the `Keyboard and Display MMIO simulator` window, test your optimized version. 
