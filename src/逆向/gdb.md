# GDB总结

>git clone https://github.com/longld/peda.git ~/peda
>echo "source ~/peda/peda.py" >> ~/.gdbinit
>echo "DONE! debug your program with gdb and enjoy"



## 1.追踪系统函数

```bash
gdb -ex 'set environment LD_DEBUG=all' -ex 'catch syscall open' -ex 'r' hide_and_seek	

忽略信号
(gdb) handle xxx pass
```

## 2.多进程调试

```bash
set follow-fork-mode [parent|child]
```

## 3.查看内存

```bash
x/nfu 0x40000

Examine the contents of memory.
Examine the contents of memory and specify formatting.
n: number of display items to print
f: specify the format for the output
u: specify the size of the data unit (eg. byte, word, ...)

Example: x/4dw var
```

## 4.脚本

```bash
set pagination off
set confirm off

set follow-fork-mode parent

# break at the end of block 1
b *0x401440
commands
silent
printf "\nNew round\n"
printf "addr = 0x%08x\n", *(int*)($fp-0x2fc)
c
end


c
```

