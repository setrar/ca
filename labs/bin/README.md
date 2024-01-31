# Installing RARS

- [ ] [RARS -- RISC-V Assembler and Runtime Simulator](https://github.com/TheThirdOne/rars)

- Download the latest RARS `jar`, current version `1.6`

```
wget https://github.com/TheThirdOne/rars/releases/download/v1.6/rars1_6.jar
```

- Check your running `java` version

```
sdk use java 17.0.8.1-tem
```

- Run the `jar` binary

```
java -jar ./rars1_6.jar 
```

- [ ] Run the Execution Environment

```
EE_HOME=~/Developer/CompArch/labs/bin
```

```
java -jar ${EE_HOME}/rars1_6.jar  &
```

### :b: Hexa to (whatever) conversion

- The `init.sh` script needs to be sourced in `bash`

```bash
bash
```

- Source the `init.sh` source file

```bash
source init.sh
```

- Example

```
s2i 0x0040000
```

# References

- [ ] [Get Hands-On Experience with RISC-V, Using ESP32-C3!](https://www.espressif.com/en/media_overview/news/risc-v-with-esp32-c3)
- [ ] [RARS -- RISC-V Assembler and Runtime Simulator](https://github.com/TheThirdOne/rars)
- [ ] [DIGITAL SYSTEMS, HARDWARE - SOFTWARE INTEGRATION](https://www.eurecom.fr/en/course/digitalsystems-2024spring)
- [ ] [:pushpin: s5project](https://gitlab.eurecom.fr/renaud.pacalet/s5project)
- [ ] [gitlab MD](https://docs.gitlab.com/ee/user/markdown.html)


