# Q&A

## :round_pushpin: GPT in RISC-V what is the difference between add and addi instructions?

In the RISC-V instruction set architecture (ISA), "add" and "addi" are both used for addition operations, but they have different purposes and formats:

1. `add` (Addition):
   - `add` is used for adding two registers and storing the result in a destination register.
   - It operates on two source registers and stores the result in a destination register, which is specified as part of the instruction.
   - Example:
     ```assembly
     add x3, x1, x2  # x3 = x1 + x2
     ```

2. `addi` (Addition Immediate):
   - `addi` is used for adding an immediate value (a constant) to a register and storing the result in a destination register.
   - It operates on a source register and an immediate value (constant), and the result is stored in a destination register.
   - Example:
     ```assembly
     addi x3, x1, 5  # x3 = x1 + 5
     ```

In summary, the primary difference is that `add` performs addition between two registers, while `addi` performs addition between a register and an immediate constant. This allows for more flexible arithmetic operations in RISC-V, with `add` being used for general register-to-register addition, and `addi` being used for adding an immediate value to a register.

## :round_pushpin: in RISC-V give an example of jalr instruction?

In RISC-V, the `jalr` instruction (Jump and Link Register) is used for performing a jump (branch) to a target address specified in a register while simultaneously saving the return address (address of the next instruction to execute) in another register. Here's an example of the `jalr` instruction in RISC-V assembly language:

```assembly
jalr x1, x2, 0
```

In this example:
- `x2` contains the target address you want to jump to.
- `x1` is the register where the return address (the address of the next instruction to execute) will be saved. In this case, `x1` will hold the address of the instruction immediately following the `jalr` instruction.
- The `0` is an offset value, which is typically set to zero for a simple absolute jump.

The `jalr` instruction will jump to the address stored in `x2`, and the address of the instruction after the `jalr` instruction will be saved in `x1`. This is useful for implementing function calls and subroutine jumps in RISC-V assembly code.