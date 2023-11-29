# GCC Compiler for RISC-V


# References

- [ ] [Docker image for the RISC-V GNU compiler toolchain](https://pulp-platform.org/community/showthread.php?tid=282)

create a shell script for the RISC V compiler executable. You can name the file "riscv32-unknown-elf-gcc" which is the exact name of the RISC V compiler executable inside the Docker container. Put the following content inside of it.

```bash
#!/bin/sh
docker run --rm --entrypoint riscv32-unknown-elf-gcc --volume $PWD:/hostdir coderitter/pulp-riscv-gnu-toolchain "$@"
```

This call to "docker run" will create a temporary Docker container with the current directory mounted into Docker container. It then executes the RISC V compiler executable and forwards any parameters which were made when the script was executed.

The last step is to set the permission of the file so that is executable.

```bash
chmod a+x riscv32-unknown-elf-gcc
```

Now you can use the script as if the compiler itself was installed in your host system.

```bash
./riscv32-unknown-elf-gcc -std=c99 -march=rv32imfdcxpulpv2 src -o build/firmware
```
