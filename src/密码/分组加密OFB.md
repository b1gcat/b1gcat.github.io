> ​	OFB模式的全称是Output Feedback模式，中文翻译为输出反馈。该模式的主要特点是相对于CFB模式，参与密码流产生过程的不是前面分组的密文，而是初使化向量本身，这样就可以事先生成好所有的密码流序列，再与明文或密文做XOR运算，实现并行加解密。



## 加解密过程

![img](/Users/b1gcat/Desktop/hack/book/b1gcat.github.io/src/密码/img.assets/ofb.png)



