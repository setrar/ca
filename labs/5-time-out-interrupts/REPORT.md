# Lab 5, Time out interrupts

## The time-out flag

We are using values 1, 2, and 4 rather than 1, 2, and 3, because that way we can know what was the error code by just looking at the bits of the return value.  
That way, if there were more than 1 error during the execution, we can easily let the user know.

## The timer tool

The values are not exactly the same. For example, while the `Time Tool` window gives a time of `00:04:08`, the memory gives `0x000010d4` (or 4308, so about `00:04:31`)

## First exception handler

The value we receive are

```text
ustatus:  0x00000010
uie:      0x00000010
utvec:    0x00400000
uscratch: 0x7fffefbc
uepc:     0x00400104
ucause:   0x80000004
```

`ustatus` is `0x00000010` because we enabled global interrupts, and we are in the exception handler, so bit 0 was copied to bit 4 and cleared.
`uie` is `0x00000010` because we enabled timeout interrupts (bit 4).
`utvec` is the address of the exception handler.
`uscratch` stores the value of `sp` during the execution of the exception handler.
`uepc` stores the value of the running instruction when the interrupt was raised (here it is `beq t2, zero, getc_wait`).
`ucause` is `0x80000004`. This means that this exception was really an interrupt, and the numeric code for it is 4 (so a timeout exception).

## Using timer interrupts to set the time-out flag

I guess that should we reset the time-out flag, and then call `set_timer`, there is a risk that exception handler is called while we are modifying the `timecmp` register.
