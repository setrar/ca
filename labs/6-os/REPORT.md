# Lab 6

## User tasks

The code we use is:

```riscv
.global taskX
taskX:
    li   s0, 0
    li   s1, 10007
taskX_loop:
    beq  s0, s1, taskX_print
    addi s0, s0, 1
    b    taskX_loop
taskX_print:
    li   a7, 11
    li   a0, 'A'
    ecall
taskX_end:
    b    taskX
```

For clarity, we keep the `taskX_end`, but we could remove it (because we do not use a `b taskX_end`).

## Understanding the starting point of the mini-OS

### 6

The exception handler treats `ucause` as a signed integer. That way (after storing its value in an intermediate register), we only need to monitor its sign to know if it is an exception (>= 0) or an interrupt (< 0)

### 7

The handler select the message to show by computing the address of the message corresponding to the exception. It multiply the error code by 4 (32 bits) to get the address of the message in `_excp` and adds to it the address of `_excp`. That way it gets the address of the message to use with two simple computation.

### 8

For each exception, we only use the third strategy (the `ret` label). There is however, the second strategy also implemented in the code under the `skip` label.

### 9

The way the handler select the first instruction of the ISR to execute is the same as how the handler select the address of the message to show. It multiply the error code by 4 (using `slli` remove the need to care about the MSB, which we could not do if we were to use something like `mul t1, t0, 4`), and adds the address of the `_isr` array. It jumps to the address and each label choose which strategy to use.

### 10

In the *startup code* we store the address of the exception handler in `utvec`, enable interrupts, print "Hello, World!" and then quits.

## Call a user task, test an exception

### 4

We get the behaviour we expected: we print "Hello, World!" and then a continuous string of "A" that never stops (because `taskA` never quits).

### 6

I got the result I expected: print "Hello, World!", print a single "A", then quit the program.

```diff
    li   s1, 10007
+   la   s2, taskA
...
taskA_end:
-   b taskA
+   jalr t0, s2, 2
```

### 7

On the breakpoint:

- `sp`: `0x7fffeffc`
- `pc`: `0x00400174`
- `t0`: `0x00400000`
- `t1`: `0x00000000`

Exception handler:

- `ustatus`: `0x00000010`, in exception handler, so bit 0 (was 1) copied to bit 4 and cleared.
- `utvec`: `0x00400000`, equal to t0, the address of the exception handler.
- `uepc`: `0x0040014a`, address of the `jalr` (in `taskA`) instruction.
- `ucause`: `0x00000000`, exception (MSB = 0) and instruction address misaligned (bit 31-0 = 0).

## Add a timer ISR

### 6 & 8

We get the expected behaviour: every 100ms we have a `*` printed between the `A` or `B`.

## Context switch

### 1

The registers that constitute a running task are: `s0`, `s1`, `a0`, `a7`, and we also need to save the address of the instruction that was running when the interrupt was raised. However, it may not be needed to save `s1`, `a0`, and `a7` as they do not change over time.  
Depending on the implementation of `taskX`, it may not be needed to load `a0` and `a7`, as they could be loaded just before the `ecall`.  
Because `a7` is used by both tasks, we don't even need to save it, as the exception handler save (line 48 is os.s) and restore (line 147) it for us.

We can also consider that the labels used are part of a running task. But we cannot really save them.

### 2

Considering that task change every 100ms, we need a very fast access time, so the values should be saved in memory. If we were able to decide, it would be even better to save them in the CPU cache, on the first level. We would need only less than half a kilobyte to save the two tasks.

### 3

For the same reason as 2, the data structures should be saved if possible in the CPU cache with preferences for level 1, but the memory works as well.  
As for the data structure itself, I think a simple array of 10 continuous elements (4 bytes each) would suffice. We would store the address of the first element in a register, and add 20 to it to go to the other task (and then subtract 20 to go back to the first).

### 7

The behaviour is as expected. We get 3 'A' for 1 'B' as B need very close to 3 times the incrementation of A, and a lot of * between each letter, as we switch every 100ms to the other task, we lose time.
