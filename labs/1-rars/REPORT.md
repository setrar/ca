## Luca NEPOTE

## Launch RARS, settings, help, registers

1) Actual content of the pc register 0x00400000
2)Registers different from 0: 
s2i 0x7fffeffc

- sp:  U (base 2):   0111 1111 1111 1111 1110 1111 1111 1100 
    U (base 10):  2147479548
    
s2i 0x10008000

- gp : U (base 2):   0001 0000 0000 0000 1000 0000 0000 0000 
U (base 10):  268468224

3)All the values are positive because the system could not interpret the MSB as the sign, but it adds only the final value. It is counted as a normal bit.

## Unsigned and signed integers

1) addi t0, zero, 1 (it adds 1 to the zero register and save it in the t0 register. Addition immediate. zero is a ROM register whose content is always 0) (we can also do it in a bitwise OR)

2) Initial address: 0x00400000

3) The current content of the pc register is the same because it points only to the instruction to be executed. In this case, it is the first one.

#simulation

1) the changed register are t0: 0x00000001 and pc: 0x00400004. The changes are consistent because we changed only the value of the 't0' register, whereas all the others have the same values. After we run the simulation, also the value of the 'pc' register is changed, as correctly expected (program counter: our instruction is encoded in 4 bytes, when the execution is finished, the pointer points to the final register where the instruction has been saved)

2) After executing an instruction, the 'pc' register will increase by 4.

#left shift

1) shift1: slli t1, t0 ,1 

2) final value stored in t1: 2 (we shifted only by 1 bit)
0000 0000 0000 0000 0000 0000 0000 0010

3) for multiplying by 3 we can shift the register by 1 bit to the left and then add the initial number to the result

mul3:

slli t3, t2, 1

add t2, t2, t3 

I used a temporary register to save the intermediate value 

4) The content of the t2 register is 
0000 0000 0000 0000 0000 0000 0111 1110

5) i42:

addi t2, zero, 42

mul3:

slli t3, t2, 1

add t2, t2, t3 

#overflows

1) shift position 

s23:

slli t2, t2, 23


U (base 2):   0011 1111 0000 0000 0000 0000 0000 0000 

U (base 10):  1056964608

U (base 16):  3F000000

SM (base 10): 1056964608

TC (base 10): 1056964608

2) t2pt2:

add t2, t2, t2


t2:0x7e000000

U (base 2):   0111 1110 0000 0000 0000 0000 0000 0000 

U (base 10):  2113929216

U (base 16):  7E000000

SM (base 10): 2113929216

TC (base 10): 2113929216


3) second time:

U (base 2):   1111 1100 0000 0000 0000 0000 0000 0000 

U (base 10):  4227858432

U (base 16):  FC000000

SM (base 10): -2080374784

TC (base 10): -67108864


third time: 

U (base 2):   1111 1000 0000 0000 0000 0000 0000 0000 

U (base 10):  4160749568

U (base 16):  F8000000

SM (base 10): -2013265920

TC (base 10): -134217728


forth time U (base 2):   1111 0000 0000 0000 0000 0000 0000 0000 

U (base 10):  4026531840

U (base 16):  F0000000

SM (base 10): -1879048192

TC (base 10): -268435456


fifth time: 

U (base 2):   1110 0000 0000 0000 0000 0000 0000 0000 

U (base 10):  3758096384

U (base 16):  E0000000

SM (base 10): -1610612736

TC (base 10): -536870912


After 2 times the value of 'sm(t2)' and 'tc(t2)' become negatives. 

5) If I sum again, the unsigned value is no more correct.

#sign and magnitude or 2's complement
1) Setting to the value -1 the register, the number will be in 2's complement. This is because all the bits will be equal to 1.

tc:

addi t4, zero,-1


t4:0xffffffff

# modulo a power of 2
1) mod128:

addi t3, zero, 1547

andi t4, t3, 0x7f



U (base 2):   0000 0000 0000 0000 0000 0000 0000 1011 

U (base 10):  11

U (base 16):  0000000B

SM (base 10): 11

TC (base 10): 11


Notice that we obtained the correct remainder.

2) The operations above work only for unsigned numbers. For negative numbers in 2's complement the modulus operation does not behave as expected using only simple bitwise operations.

3) for compute the modulo 2^(n) we have to use the following instruction:
andi t4, t3, 0xN where N is (2^(n)-1)

#underflow 
1) I added 1 and then shift the register 31 times, till the head of the bit string
min:

addi t2, zero, 1

slli t2, t2, 31


the results are the following ones:

U (base 2):   1000 0000 0000 0000 0000 0000 0000 0000 

U (base 10):  2147483648

U (base 16):  80000000

SM (base 10): 0

TC (base 10): -2147483648


2) m1:

addi t2, t2, -1

the resultsare the following ones:

U (base 2):   0111 1111 1111 1111 1111 1111 1111 1111 

U (base 10):  2147483647

U (base 16):  7FFFFFFF

SM (base 10): 2147483647

TC (base 10): 2147483647


We obtained the biggest positive number.

# Right shifts as a way to divide by powers of 2
1)
rs:

addi t2, zero, 1

slli t2, t2, 31

srli t2, t2, 1



U (base 2):   0100 0000 0000 0000 0000 0000 0000 0000 

U (base 10):  1073741824

U (base 16):  40000000

SM (base 10): 1073741824

TC (base 10): 1073741824


The obtained two complement is half of the smallest negative number but with positive sign.

2)
addi t2, zero, 1

slli t2, t2, 31

srai t2, t2, 1


U (base 2):   1100 0000 0000 0000 0000 0000 0000 0000 

U (base 10):  3221225472

U (base 16):  C0000000

SM (base 10): -1073741824

TC (base 10): -1073741824


Using 'srai' instead of 'srli' we found the correct halved negative number.

# Controlling Overflows
For this section we had to check the the overflow condition in different situations.

## floating point numbers
2) floating point representation of 1/3 
0-01111101-01010101010101010101010 (0.3333333)

Notice that the floating point representation does not allow the accurate representation of all real numbers.

3) floating point representation of 1/2: it will be perfectly represented as it has only a decimal value 
0-01111110-00000000000000000000000

# floating point instructions
1) Notice the difference on the last bit: it means that the floating point number is 0.33333334. This is only because of the approximation. 

U (base 2):   0011 1110 1010 1010 1010 1010 1010 1011 

U (base 10):  1051372203

U (base 16):  3EAAAAAB

SM (base 10): 1051372203

TC (base 10): 1051372203


2) I initialized the temporary registers and then used the function fmv.s.x for transform the data from integer to floating point representation, into the registers ft2 and ft3.
NOTE: the values of ft2 and ft3 in hexadecimal notations correspond to the integer ones, not to the floating point ones.

# floating point erasure 
1) we verified that the content of the 'ft4' register corresponds to the one of 'ft2'.

2) the obtained result is equal to 0. This could be due to the fact that the two numbers are very different in order of magnitude, so, using the 'rne', the floating point representation could approximate the first summation to the same number (i.e. ft2 + ft3 ~ ft3). 

# floating point special values
For this part I wrote some assembly code in order to obtain special values like '-infinty', '+infinity' and 'NaN'. Notice that for the first case I divided a negative number by 0, in the second I did the same with a positive number, whereas for 'NaN' I put the condition 0/0.
The values I obtained for the three different cases are respectively:

- Nan --> 0x7fc00000

- +infinity --> 0x7f800000

- -infinity --> 0xff800000

