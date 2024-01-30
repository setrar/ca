## Luca NEPOTE

## LAB3 
In this Lab we use another way to take and print characters based on memory mapped IO and polling. We use a Receiver device with two registers mapped at 0xffff0000 and 0xffff0004, and a Transmitted device mapped at memory addresses 0xffff0008 and 0xffff000c.

In the initial "mmio" program, at first we wait for the next character to be inserted, at first initializing the addresses of the memory, and we loop into this function ('wait_for_rcv') till a new character is inserted. Then, when this has been done, we initialize the registers with the memory addresses of the transmitter, we loop in this function ('wait_for_trans_1') till the buffer is busy and, otherwise we send the new character to the transmitter. We then print the "new line" character and start again. 

The program works as expected, printing the inserted character followed by a 'new line' in the console.

When I choose a value on the keyboard, the corresponding ASCII value is instantly inserted in the address 0xffff0004.
Then, after some steps, the value of the register 0xffff0000 goes from 1 to 0 and, after some other steps, the value of register 0xffff0008 and 0xffff000c are updated. More precisely, 0xffff0008 goes from 1 to 0, whereas in 0xffff000c the content of 0xffff0004 has been copied.
Then the values of 0xffff0008 goes back to 1, until the value of 0xffff000c is updated again with value 10 (in that case it goes again to 0). Finally, 0xffff0008 goes again back to 1 and all these values are stored till a new character is inserted from the keyboard.

For example, inserting the character `b`, its content has been stored in the `a0` register, with the correspondent value of `62` (in hexadecimal notation). 

To optimize the code we can create only two different functions, one for the reading operation and the other for the writing one. We can do that because only few lines of code are different between each other. In this way, we can call the same `write_func` twice, the first one loading the value of the character inserted from the keyboard, whereas the second time inserting the new line. 
Moreover, in order to reduce the number of executed instructions, we added a global `main` function in which we initialized two registers (`a1` and `a2`) to the values `0xffff_0000` and `0xffff_0008` respectively. The, we use these registers into the read and write functions, called in the `main_loop`. 
Using this procedure, the number of executed instructions and the footprint have been reduced.
Note that the `mmio.s` file is the initial one, whereas the modified version is `mmio2.s`.


