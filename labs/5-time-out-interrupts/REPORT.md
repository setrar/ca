## Report lab5
For the io.s I used the code provided because I had not finished the previous last lab yet.

In this lab we added a "set_timer" function in order to stop the program when a character is not inserted or printed for more than 5 seconds. In this way we can avoid that the CPU is completely occupied by the program during its execution.

Note that we chose the error codes (for `a1`) 1,2 and 4 instead of 1,2,3 because in this way each error represents an unique bit position considering the binary representation. In this way, we can easily see the combination of error conditions using the simple bitwise operation, and the checking of errors is simplified in this way.
