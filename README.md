<!-- MASTER-ONLY: DO NOT MODIFY THIS FILE

Copyright (C) Telecom Paris
Copyright (C) Renaud Pacalet (renaud.pacalet@telecom-paris.fr)

This file must be used under the terms of the CeCILL. This source
file is licensed as described in the file COPYING, which you should
have received as part of this distribution. The terms are also
available at:
https://cecill.info/licences/Licence_CeCILL_V2.1-en.html
-->

Labs of CompArch course

---

[TOC]

---

## Introduction

**PLEASE READ THIS FIRST, VERY CAREFULLY**

1. There is a [FAQ]; if you encounter problems with the GitLab authentication, please read it.
   If you prefer working on your personal computer and want to install the tools, please also see the [FAQ].

1. To get the full benefit of the labs you must be reasonably comfortable with GNU/Linux and the command line.
  The [Ubuntu Linux command line tutorial for beginners] is a nice starting point (about 50 minutes).
  [bootlin] wrote a very useful one-page [memento of the most useful GNU/Linux commands]; there is even a [French version](doc/command_memento_fr.pdf).
   Being able to use at least one of the text editors that can be found under GNU/Linux (`emacs`, `vim`, `nano`, `gedit`, `atom`, `sublime text`$\dots$), while not mandatory, will help a lot.
   Having some knowledge of algorithm principles and basic programming skills (in any programming language) will also be very useful.

1. File or directory names with spaces (or tabs$\dots$) are a bad idea under GNU/Linux.
  When choosing a name for a new file or directory use only alphanumeric characters, plus underscore (`_`), hyphen (`-`) and dot (`.`).

1. Do the work yourself (typing, thinking, testing$\dots$), it is much more beneficial than letting somebody else do it on your behalf.
  But of course, you can exchange ideas with others during the lab.
  It is even strongly advised.
  Helping the others and asking the others for help is highly beneficial.

1. Do not forget to write your lab reports in the `REPORT.md` file of each lab: simply explain what you do, why and with what results.
  Use the [Markdown syntax].
  To explain your source code you can add text to the `REPORT.md` file or add comments directly in the source file, as you wish.
  The lab reports and source codes are due (in your personal branch) the day **before** the written exam at 23:59 sharp.
  After this deadline the git repository will become read-only and there will be no way to add or modify anything.

1. As we all share the same git repository, it is important to keep it clean.
  In particular, please do not `git add` directories; it is the best way to add files that we do not want in the repository; `git add` only files, and only files that make sense (source code, reports$\dots$).
  Try to use the right resolution for the (carefully selected) images that you add.

1. In the lab instructions you are asked to type commands.
  These commands are frequently preceded by a `$` sign representing the prompt of the current shell.
  It is not a part of the command, do not type it.

1. If you discover a bug, a broken link, a spelling error, a missing explanation, an explanation that should be improved, etc. please inform an adviser.

## GitLab and git set-up

To help with the GitLab and git set-up a helper `bash` script is available: `/packages/LabSoC/bin/ca_init`.

> Using the default configuration is warmly recommended but the helper script is configurable so, if you know what you are doing and you do not like the defaults, you can copy it somewhere, edit it and adapt the variable declarations near the top to your own preferences (ssh key to use, path to the clone of the git repository, path of the RARS java archive and path to the directory containing the RISC-V toolchain binaries).

Log on a Eurecom GNU/Linux desktop computer (in lab rooms 52 or 53), open a terminal, source the helper script (or your modified copy) and if you are asked questions answer them:

```bash
$ source /packages/LabSoC/bin/ca_init
...
```

If there were errors please ask for help and indicate the error message.

## Define helper bash functions

To simplify the use of the tools there is another helper `bash` script: `/packages/LabSoC/bin/ca_functions`.
Source it to define two `bash` functions:

```bash
$ source /packages/LabSoC/bin/ca_functions
```

If there were errors please ask for help and indicate the error message.
Else, you should now be ready to test the installation and the tools.

## Testing the configuration

The local clone of the git repository should normally be in `~/Documents/ca`.
If you do not see the material for the labs in the clone, don't worry, they will be added later.
A number of branches have already been created such that we can all work in isolated environments and avoid conflicts.
The branch named `master` is protected and will be used to provide instructions for the labs, code templates, documentation$\dots$
Never work in the `master` branch.
There is already a branch for you and it should already be the current branch of your local clone.
Let's check this (`USERNAME` represents your username, the one you used to log in):

```bash
$ cd ~/Documents/ca
$ git status
On branch USERNAME
Your branch is up to date with 'origin/USERNAME'.
```

Remember that you will work in your personal branch.
You can check that you are on the correct branch with the `git branch` command.
From time to time, when new material will be added to it, you will be asked to merge the `master` branch in your personal branch:

```bash
$ git pull
$ git merge origin/master
```

Do not forget to add, commit and push your own work in your personal branch.
Example to add-commit-push your last modifications on `REPORT.md` and `my_code.s`:

```bash
$ git add REPORT.md my_code.s
$ git commit -m 'Add conclusion to report and fix 2 bugs in my_code.s'
$ git push
```

Check that everything is in order by adding an empty file named `got.it` to your personal branch.
First check that you really are on your personal branch:

```bash
$ cd ~/Documents/ca
$ git branch
master
* USERNAME
```

If the leading star (`*`) is on front of `USERNAME` (like above), you are on your personal branch; else switch to your personal branch and check again:

```bash
$ git checkout USERNAME
Switched to branch 'USERNAME'
Your branch is up to date with 'origin/USERNAME'.
$ git branch
master
* USERNAME
```

Then, create the empty file and add-commit-push:

```bash
$ touch got.it
$ git add got.it
$ git commit -m 'add got.it empty file'
$ git push
...
```

Let's then try to create a simple example C source file and to compile it:

```bash
$ cd /tmp
$ echo 'int main(void) {return 0;}' > foo.c
$ c2rv foo.c
$ ls foo.s
foo.s
```

If the `foo.s` assembly file was generated the compiler works.
Next, let's test the RARS simulator:

```bash
$ rars
```

If the tool launches everything is fine.
Select `File -> Exit` to quit.

## The labs

During all labs it will be convenient to have a RISC-V cheat sheet at hand.
[Erik Engheim](https://itnext.io/risc-v-instruction-set-cheatsheet-70961b4bbe8) designed a nice one (without the M extension).
A [PDF version](doc/data/RISC-V-cheatsheet.pdf) is available in the `doc/data` subdirectory.

[bootlin]: https://bootlin.com/
[memento of the most useful GNU/Linux commands]: doc/data/command_memento.pdf
[French version]: doc/data/command_memento_fr.pdf
[Markdown syntax]: https://www.markdowntutorial.com/
[Ubuntu Linux command line tutorial for beginners]: https://ubuntu.com/tutorials/command-line-for-beginners
[FAQ]: ./FAQ.md

<!-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0: -->
