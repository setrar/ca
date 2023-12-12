

# Assignments

## The time-out flag


1. Edit the io.s source file. In the data section add a declaration for a 32-bits word that we will use for the time-out flag, with a global label for easy reference:

```asm
# time-out flag
.global time_out
time_out:
.word 0
```

<img src=images/LAB5_TimerTool.png width='30%' height='30%' > </img>

<img src=images/LAB5_TimerTool-reading.png width='' height='' > </img>
