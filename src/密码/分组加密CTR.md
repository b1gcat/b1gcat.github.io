> ​	CTR模式的全称是Counter模式，中文翻译为计数器。该模式的主要特点是相对于OFB，流密码的产生不再依赖前面的流密码，而是根据初使化向量逐分组执行+1操作，这样可以并行产生密码流，做到完完全全的真正并行计算。

## 加解密过程

![img](/Users/b1gcat/Desktop/hack/book/b1gcat.github.io/src/密码/img.assets/ctr.png)