<!-- MASTER-ONLY: DO NOT MODIFY THIS FILE

Copyright (C) Telecom Paris
Copyright (C) Renaud Pacalet (renaud.pacalet@telecom-paris.fr)

This file must be used under the terms of the CeCILL. This source
file is licensed as described in the file COPYING, which you should
have received as part of this distribution. The terms are also
available at:
http://www.cecill.info/licences/Licence_CeCILL_V1.1-US.txt
-->

Frequently asked questions

---

[TOC]

---

# GitLab authentication with `ssh` 

The following assumes that you use default names and locations for your `ssh` keys.
If you do not use the default you probably know what you are doing and do not need this FAQ.

## The `git` server asks for a password when I try to clone the repository, or when I try to push, pull, fetch, etc. how can I avoid this?

There are several possible reasons:

1. You tried to **clone** the repository using the `https` protocol (`https://gitlab.eurecom.fr/renaud.pacalet/ca.git`) and your OS does not provide a `git` credential manager to handle the password for you.
  Try again with the `ssh` protocol:

   ```bash
   $ git clone git@gitlab.eurecom.fr:renaud.pacalet/ca.git
   ```

1. You already successfully cloned the repository but you did it using the `https` protocol (`https://gitlab.eurecom.fr/renaud.pacalet/ca.git`) and your OS does not provide a `git` credential manager to handle the password for you.
   Check the protocol:

   ```bash
   $ cd path/to/the/clone
   $ git remote -v
   origin   https://gitlab.eurecom.fr/renaud.pacalet/ca.git (fetch)
   origin   https://gitlab.eurecom.fr/renaud.pacalet/ca.git (push)
   ```

  If it is `https`, either set up a `git` credential manager or change the protocol for `ssh`:

   ```bash
   $ git remote set-url origin git@gitlab.eurecom.fr:renaud.pacalet/ca.git
   $ git remote -v
   origin   git@gitlab.eurecom.fr:renaud.pacalet/ca.git (fetch)
   origin   git@gitlab.eurecom.fr:renaud.pacalet/ca.git (push)
   ```

1. You used the `ssh` protocol but you did not add your `ssh` public key to your GitLab account.
  If you do not have a `ssh` key pair yet (see  _How do I know if I have a `ssh` key pair?_) generate one (see _How to generate a ssh key pair?_).
  Add the public part of your key pair to your GitLab account (see _How do I add my `ssh` public key to my GitLab account?_).

1. You do not have a `ssh` agent running or your shell does not know about it.
  Check:

    ```bash
    $ ssh-add -l
    Could not open a connection to your authentication agent.
    ```

   If you do not have a running `ssh` agent, launch one:

    ```bash
    $ eval $(ssh-agent -s)
    ```

1. You have a running `ssh` agent but you did not add your private key to the agent.
  Do it:

    ```bash
    $ ssh-add
    ```

  > Note: if your private key is protected you will have to enter your passphrase to unlock it.

## How do I know if I already have a `ssh` key pair?

Your `ssh` key pairs are normally stored in a sub-directory of your home directory named `.ssh`.
Each key pair is stored in two files: `KEY.pub` for the public part and `KEY` for the private part, where `KEY` is some name.
To check what `ssh` keys you have simply list the content of this sub-directory:

```bash
$ ls ~/.ssh
authorized_keys  id_ed25519      id_rsa      known_hosts
config           id_ed25519.pub  id_rsa.pub
```

In this list we see 2 key pairs: `id_ed25519`/`id_ed25519.pub` and `id_rsa`/`id_rsa.pub`.

## How to generate a `ssh` key pair?

`ssh-keygen` is the command that generates `ssh` key pairs.
During the key pair generation you will be asked to enter the name of the file in which to save the key; hit <kbd>Enter</kbd> to accept the default.
You will also be asked to type twice a passphrase to protect the private key.
If you enter en empty passphrase (by just typing the <kbd>Enter</kbd> key) your private key will not be passphrase-protected.
As it is stored under your home directory with restricted access permissions, and as what you will do with your GitLab account is probably not critical, this is a reasonable choice that will save yourself the burden of remembering a passphrase and having to type it from time to time.
But if you are concerned about security, or intend to store valuable assets on your GitLab account, feel free to enter a non-empty passphrase.
Example of key pair generation under GNU/Linux (`ed25519` is the kind of key pair currently recommended by security experts over the default `rsa`):

```bash
$ ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/homes/mary/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /homes/mary/.ssh/id_ed25519
Your public key has been saved in /homes/mary/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:OlWKH9VRKKM3TJYfSgkO9VzZRyegHlrFbs913FTigFo mary@megantic
The key's randomart image is:
+--[ED25519 256]--+
|      ..o. =**+.=|
|       o oE==+.o+|
|        .OO*...+.|
|       .oB=.+   =|
|      . S..o o ..|
|       + .    o  |
|      o .        |
|       .         |
|                 |
+----[SHA256]-----+
```

Your public key is in `~/.ssh/id_ed25519.pub` and your private key is in `~/.ssh/id_ed25519`.
Of course, as the names indicate, you can (and must) disclose the former but you must keep the latter secret.
This is why `ssh` complains if your private key files have too open access permissions.

## How do I add my `ssh` public key to my GitLab account?

Visit the [_SSH Keys_ section of your _User Settings_](https://gitlab.eurecom.fr/-/profile/keys), log in with your LDAP-Eurecom credentials if asked to.
Copy the **content** of `~/.ssh/KEY.pub` (where `KEY` is the base name of the key you want to use) to the clipboard, paste it in the `Key` text box and click on the `Add Key` button.

# Working on personal computer

## Can I install RARS on my laptop?

Yes, it should be easy, see the [RARS Github project].
It should work on any java-capable computer (Window, macOS, GNU/Linux).

## Can I install the RISC-V toolchain on my laptop?

It should be possible but be careful: it is huge (almost 7 GB), takes time to download, and is not easy to configure and build.
As it does not need a graphical user interface, an easy alternative is to use the toolchain installed on Eurecom GNU/Linux desktop computers through ssh and to download the compilation results with scp.

If you insist see the [Github project of the RISC-V toolchain].

## Can I clone the git repository on my laptop?

Yes, likely.
How to do it depends on your OS, git client, preferred authentication method$\dots$

Under Windows I recommend installing [Git for Windows] and using the bash emulator that comes with it (even if there is also a graphical user interface).

Under macOS I recommend installing decently recent GNU/Linux utilities (bash, git$\dots$) with, e.g., [MacPorts] or [Homebrew].
The versions of these that come with macOS are frequently outdated.

Under any GNU/Linux OS, bash, the ssh client and the git client should be available by default.

Then, open a bash terminal and type the following commands.
Replace `USERNAME` by your username on Eurecom computers, and `EMAIL` by your full official EURECOM e-mail address (`firstname.name@eurecom.fr`):

```bash
$ git clone git@gitlab.eurecom.fr:renaud.pacalet/ca.git ~/Documents/ca
$ cd ~/Documents/ca
$ git checkout "USERNAME"
$ git pull
$ git merge origin/master
$ git config user.name "USERNAME"
$ git config user.email "EMAIL"
```

# Shell configuration

## How can I avoid having to source the `/packages/LabSoC/bin/labs-functions` script every time I open a new terminal?

When you source the `/packages/LabSoC/bin/labs-functions` script the `rars` and `c2rv` definitions will work only in the current tab of the current terminal.
If you open a new terminal or tab you will need to source again the `/packages/LabSoC/bin/labs-functions` script.
On Eurecom's GNU/Linux computers you can make the definitions permanent by adding the following lines at the end of the `~/.bashrc+` file:

```bash
rars() { /usr/java/bin/java -jar /packages/LabSoC/bin/rars.jar & }
c2rv() { /packages/LabSoC/riscv/bin/riscv32-unknown-linux-gnu-gcc -march=rv32im -mabi=ilp32 -S "$@"; }
```

Note that, depending on your configuration you may have to launch a new terminal or even to log out and log in before it takes effect.

On other computers there is likely a way to achieve the same.
If you are using `bash` as your command line interface simply add the following lines at the end of the `~/.bashrc` file (no trailing `+` sign in the file name):

```bash
rars() { java -jar PATH-TO-RARS-JAR & }
c2rv() { PATH-TO-RISCV32-UNKNOWN-LINUX-GNU-GCC -march=rv32im -mabi=ilp32 -S "$@"; }
```

Where `PATH-TO-RARS-JAR` is the path to the RARS jar archive you installed and `PATH-TO-RISCV32-UNKNOWN-LINUX-GNU-GCC` is the path to the RISC-V `gcc` cross-compiler you installed.

If you are using a different command line interface read its documentation.

[RARS Github project]: https://github.com/TheThirdOne/rars
[Github project of the RISC-V toolchain]: https://github.com/riscv-collab/riscv-gnu-toolchain
[Git for Windows]: https://gitforwindows.org/
[MacPorts]: https://www.macports.org/
[Homebrew]: https://brew.sh/

<!-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0: -->
