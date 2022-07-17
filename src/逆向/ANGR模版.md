# Angr 模版

## 通用

```python
import angr
import angr
import claripy
import sys


def main():
    print("*** solving ***:", sys.argv[1])
    p = angr.Project(sys.argv[1], load_options={"auto_load_libs": False})

    '''
    带参数：
    flag_chars = [claripy.BVS('flag_%d' % i, 8) for i in range(32)]
    flag = claripy.Concat(*flag_chars)

    #对于 c++ 的程序，如果调用了 c++ 的函数，使用 full_init_state
    state = p.factory.full_init_state(add_options=angr.options.unicorn, args=[sys.argv[1], flag])
    '''
    state = p.factory.entry_state()

    '''
    添加约束
    for c in flag_chars:
        state.solver.add(c > 32)
        state.solver.add(c < 127)
    '''

    # 在入口准备开始符号执行
    sm = p.factory.simgr(state)

    '''
    遍历可能的路径并找到成功的那条路径
    最终想找到的路径是0x804868B，要避开的路径是0x804869E，这里可以写多个avoid，用[]
    '''
    sm.explore(find=0x80485e0, avoid=[0x80485f2])

    if sm.found:
      # print(sm.found[0].solver.eval(flag, cast_to=bytes)
      # print(sm.found[0].posix.dumps(sys.stdout.fileno())
        print(sm.found[0].posix.dumps(sys.stdin.fileno()))
    else:
        print("Not found")
    print("Done")


if __name__ == '__main__':
    main()


```



