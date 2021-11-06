# Angr 模版

## 通用

```python
import angr
import claripy


def main():
    """
    模版
    """

    '''
    加载镜像：
    创建一个Angr工程,可以追加参数：load_options={"auto_load_libs": False}
    auto_load_libs 设置是否自动载入依赖的库，如果设置为 True 的话会自动载入依赖的库
    然后分析到库函数调用时也会进入库函数，这样会增加分析的工作量，也有能会跑挂
    '''
    p = angr.Project("hack")

    '''
    带参数：
    [如果参数长度不固定，参数约束太大时，设置参数反而很慢]
    args=['./hack', flag]
    flag_chars = [claripy.BVS('flag_%d' % i, 8) for i in range(32)]
    flag = claripy.Concat(*flag_chars)
    state = p.factory.full_init_state(add_options=angr.options.unicorn, args=['./hack', flag])
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
    sm.explore(find=0x400000 + 0x12ab, avoid=[0x400000 + 0x12b4])

    # 返回当前状态输入 dumps(0)表示输入
    if sm.found:
        print(sm.found[0].se.eval(flag, cast_to=bytes))
        print(sm.found[0].posix.dumps(1))
        print(sm.found[0].posix.dumps(0))

    print("完成")


if __name__ == '__main__':
    main()

```

## 注意

```python
#对于 c++ 的程序，如果调用了 c++ 的函数，使用 full_init_state
state = p.factory.full_init_state(add_options=angr.options.unicorn)
```

