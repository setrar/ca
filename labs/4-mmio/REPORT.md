# Lab 4

### 10

For the `d2i` function, we first make sure the ASCII code of the input is between the ASCII code for '0' and '9' (as all code for number follow each other).  
If it does, we subtract the value for the code of '0' to the input. That way, if we had '0' we get 0, if we had '1' we get 1, etc.

### 11

The `geti` function calls `d2i` for all new inputs except when the input is a newline character ('\n'). If the input is not a number, we print an error message, and if it is, we we multiply the previous value by 10 and add the converted input to give us a new value.  
We know there was an overflow if the new value is less than the previous one, and we print an error message.

### 12

The way the `puti` function works is by taking the unit number, calling itself with a value divided by 10, and then print the number it saved.  
If the value divided by 10 is equal to 0, then it does not call itself.

Here is a schema with a starting value of 724:

```text
724
  724 % 10 =  4    => value saved
  724 / 10 = 72.4  => repeat with 72 as we only take the whole part

  72
    72 % 10 = 2    => value saved
    72 / 10 = 7.2  => 7, repeat

    7
      7 % 10 = 7   => value saved
      7 / 10 = 0.7 => 0, we do not repeat

    print the value saved (7)
  print the value saved (2)
print the value saved (4)

=> 724
```
