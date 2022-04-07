# GDB总结



## 1.追踪系统函数

```bash
gdb -ex 'set environment LD_DEBUG=all' -ex 'catch syscall open' -ex 'r' hide_and_seek
```

