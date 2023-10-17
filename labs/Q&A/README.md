# Q&A

## :cat:GPT in RISC-V what is the difference between add and addi instructions?

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
