<!-- MASTER-ONLY: DO NOT MODIFY THIS FILE

Copyright © Telecom Paris
Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)

This file must be used under the terms of the CeCILL. This source
file is licensed as described in the file COPYING, which you should
have received as part of this distribution. The terms are also
available at:
https://cecill.info/licences/Licence_CeCILL_V2.1-en.html
-->

The ILP32 ABI, the 'io' application, syscall-based IO

---

[TOC]

---

As for any lab do not forget to write a report in [Markdown syntax] in the `REPORT.md` file.
Remember that the written reports and source code are personal work (plagiarism is not accepted).
Do all assignments yourself and try to understand each of them.
You can of course discuss with others, exchange ideas, ask others for help, help others...
It is even warmly recommended, but at the end your report and source code must be your personal work.
They are due the day **before** the written exam at 23:59.
After this deadline the git repository will become read-only and there will be no possibility any more to add or modify something.

The following assumes a student named Mary Shelley.

## Set-up

1. Open a terminal, change the working directory to the `ca` clone, check the current status:

    ```bash
    $ cd ~/Documents/ca
    $ git status
    On branch shelley
    Your branch is up to date with 'origin/shelley'.
    
    nothing to commit, working tree clean
    ```

1. If the current branch is not your personal branch, switch to your personal branch and check again the current status:

    ```bash
    $ git checkout shelley
    $ git status
    ...
    ```

1. If your branch is not up to date with `origin/shelley` or there is something to commit or the working tree is not clean, add, commit and/or pull until everything is in order.

1. Pull, merge with `origin/master`, change the working directory to this lab's directory and list the directory's content:

    ```bash
    $ git pull --no-edit
    $ git merge --no-edit origin/master
    $ cd labs/2-syscall-io
    $ ls
    README.md
    REPORT.md
    io.s
    ```

   `README.md` is the file you are currently looking at, `REPORT.md` is the empty file in which you will write your lab report and the `io.s` file is the RISC-V source code of an application.

## Introduction

In this lab we will discover what an "Application Binary Interface" (ABI) is, why it is needed, understand some aspects of the "Integer, Long and Pointers 32 bits" (ILP32) ABI, and use it for our own coding.
We will work with software functions to read data from the keyboard and to print data to the console.
We will simulate them using the RARS simulator, debug them if needed, and observe the internals of the simulated RISC-V processor during execution.

There are usually 3 ways to launch an action with RARS:
- Select an entry in a menu.
- Click on an icon.
- Use a keyboard shortcut (shortcuts are indicated near the menu entry with the same effect).

In the following directions we use the menu entries method with the `[M -> E]` syntax to designate the `E` entry of the `M` menu; feel free to use the method you prefer.

## A note on the way characters and text strings are represented

In the computer system that RARS emulates characters are encoded as numeric values between 0 and 127: the [ASCII code].
Even if 7 bits would be enough, when stored in memory a character occupies one full byte with a 0 as most significant bit.
The 32 first ASCII codes (0 to 31) and the last (127) correspond to control characters; all other codes correspond to printable characters.
To see the correspondence between characters and ASCII codes, switch to your opened terminal and type `man ascii` (use up/down arrows or page up/page down keys to navigate, type `q` when done).

Text strings are sequences of characters and they are encoded as sequences of numeric values between 0 and 127.
Functions and system calls that process a text string stored in memory frequently need to know not only where the string starts (the memory address of its first byte) but also where it stops.
This can be done in different ways:
- by providing also the length,
- by providing also the memory address of the last byte,
- by using a special ASCII code to terminate the string.

When a special ASCII code is used to signal the end of a string it is usually `NUL` (ASCII code 0).
The `PrintString` system call that we will use later to print text strings expects a `NUL` at the end of the string.

## The assembler

The A letter in RARS stands for Assembler.
This is a software that resembles a compiler: it takes the textual assembly source code of our application and produces a binary version of it, ready to be executed by the computer, that we call the _executable_ for short.
On real computer systems the executable is usually stored in a file and it is this file that you invoke by clicking on its icon or by typing its name in the command line interface when you want to execute the application.
In our small simulated RISC-V computer the executable is not stored in a file but the principle is the same.

The executable is a representation of the memory layout; in order to run the application the executable is parsed, _segments_ of it are loaded at specified addresses into the computer's memory, and the computer's program counter is set to the address of the first instruction.
In this lab we will focus on two segments: the data segment that contains our application's data and the code segment that contains its instructions.
**Important**: the code segment is also sometimes called the _text_ segment for historical reasons; do not mix up with text strings.
With RARS by default the data segment starts at address `0x10010000` in memory and the code segment starts at address `0x00400000`.

The assembler can be seen as a kind of dual track recorder where one track would be the data segment and the other would be the code segment.
It parses our source code and progressively adds items to one or the other of the segments until they are complete.
Only one of the two segments can be updated at a time: the _current_ segment; at the beginning of the assembling the current segment is the code segment.
While parsing our source code the assembler manages 2 internal variables, `vcode` (initialized with `0x00400000`) and `vdata` (initialized with `0x10010000`); they are the recording heads of the dual track recorder and they always point to the next available free memory address in their respective segment.
The assembler reads our assembly source code line by line and depending of what was read it can either:
- change the current segment (`.text` and `.data` directives),
- store the current memory address, that is, the current value of `vcode` or `vdata` depending on the current segment, and give it a name for later reuse (label declarations),
- add an item to the current segment and increment the corresponding `vcode` or `vdata` variable accordingly (almost everything else).

## Launch RARS, settings, help

Launch RARS (just type `rars` in your terminal), open the `Settings` menu and configure it according the following picture:

![RARS settings](../../doc/data/rars-settings.png)

Open the help window (`[Help -> Help]`) and select its `RISCV` tab.
In the `RISCV` tab we will use the `Basic instructions`, `Extended (pseudo) instructions`, `Directives` and `Syscalls` sub-tabs.
Ignore the other sub-tabs, we don't need them for now.
In this lab, to simplify the coding, we will use pseudo instructions, that is, instructions that don't really exist; the assembler will convert them in one or more real instructions with the same effect.

## Assignments

The application that we will study in this lab is structured in separate functions.
In order to understand how to write functions in assembly code, the conventions to use, and the role of the _stack_ in all this, first read the following sections of the [FAQ]:

- [How to write functions and call them in assembly code?]
- [What is the ILP32 ABI for the RV32IM ISA?]
- [What are the stack, the stack frames and the stack pointer?]

Our application is a loop that:

1. Print a message asking to enter a character.
1. Read a character from the keyboard.
1. Print another message followed by the entered character.
1. Print a good bye message and exit if the entered character was a `Q`.
1. Else, go back to 1.

In this first version we will use the RARS syscalls to read and print characters and to print messages.

1. Open the `io.s` file with the RARS editor, study the code and try to understand it.
   In order to understand what the various syscalls are doing and how they are called, you will need the `Syscalls` tab of the help window of RARS.

1. Observe how the various functions are written, how they are called, how their input parameters and output results are passed between callers and callees, how the return addresses are handled, how the stack frames are managed and what they are used for.
   Does the code comply with the ILP32 ABI?

1. Assemble `io.s` and simulate.
   After entering (and displaying) several characters reset the simulation (`[Run -> Reset]`) and start executing step-by-step (`[Run -> Step]`).
   After stepping over the `ReadChar` syscall do not forget to enter a character.
   Before each step, try to understand what instruction will be executed and what its effect should be.
   Cross-check your guessing by looking at the content of the registers (including the Program Counter - PC) before and after the step.

1. Edit `io.s` and modify the code to add a `puti` function that prints the integer in register `a0`.
   Also add a `print_ascii_message` in the `data` segment with value `\nThe ASCII code of the character you entered is: `.
   Modify the `main` function to print `print_ascii_message` instead of `print_char_message`, and to use `puti` instead of `putc` to print the ASCII code of the entered character instead of the character itself.
   Test your modification.

1. Use your application to find the ASCII codes of characters `#`, `u` and `$`.

## Report, add, commit, push

Once you will have written your report do not forget to add, commit and push it in your personal branch.
Add also the `io.s` file.

[ASCII code]: https://en.wikipedia.org/wiki/ASCII
[Markdown syntax]: https://www.markdowntutorial.com/
[FAQ]: ../../FAQ.md
[How to write functions and call them in assembly code?]: ../../FAQ.md#how-to-write-functions-and-call-them-in-assembly-code
[What is the ILP32 ABI for the RV32IM ISA?]: ../../FAQ.md#what-is-the-ilp32-abi-for-the-rv32im-isa
[What are the stack, the stack frames and the stack pointer?]: ../../FAQ.md#what-are-the-stack-the-stack-frames-and-the-stack-pointer

<!-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0: -->
