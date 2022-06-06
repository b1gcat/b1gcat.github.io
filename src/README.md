# Introduction

## 我的Kali环境

```bash
dpkg --add-architecture i386 
apt-get update
apt-get install libc6:i386 gcc-multilib binwalk gdbserver vim hashcat libssl-dev curl git wget make unzip g++ pkg-config procps strace ltrace
wget https://github.com/radareorg/radare2/releases/download/5.6.8/radare2-dev_5.6.8_amd64.deb
dpkg -i radare2-dev_5.6.8_amd64.deb
r2pm -ci r2ghidra
echo "echo 0 >/proc/sys/kernel/randomize_va_space" >> /etc/profile
```



## 密码攻击

## 古典密码

| 算法          | 攻击手段                                               |
| ------------- | ------------------------------------------------------ |
| 替换密码      | 词频分析 https://quipqiup.com/                         |
| 凯撒密码      |                                                        |
| rot5/13/18/47 |                                                        |
| 仿射密码      | 解方程组 加密公式：密文 = (明文 * 乘数 + 位移数) Mod p |
| 吉利维密      | https://guballa.de/vigenere-solver                     |
| OneTimePad    | Key重用攻击                                            |
| base64隐写    |                                                        |

## 对称加密

| 算法      | 攻击手段              |
| --------- | --------------------- |
| CBC块加密 | padding oracle attack |
| CBC块加密 | bit flipping Attack   |

## HASH

| 攻击手段     | 备注     |
| ------------ | -------- |
| hash长度扩展 | hashpump |
| 爆破         | hashcat  |

### RSA攻击

| 攻击手段                                                    | 推荐工具                                                  |
| :---------------------------------------------------------- | --------------------------------------------------------- |
| 在线分解n                                                   | curl http://factordb.com/api?query=n                      |
| e过大或过小                                                 | Wiener's Attack                                           |
| e非常大且接近n                                              | Boneh and Durfee attack                                   |
| e小且明文不大                                               | 低加密指数攻击                                            |
| e相同且k组(k>=e)相同明文加密的密文                          | 低加密指数广播攻击(中国剩余定理)                          |
| p、q相差较大或较小                                          | 分解n(推荐yafu工具)                                       |
| 模不互素gcd(n1,n2)!=1                                       | 分解n                                                     |
| n<256bit                                                    | 分解n（推荐工具rsatool2v17)                               |
| n相同且明文也相同                                           | 共模攻击                                                  |
| 泄漏部分明文                                                |                                                           |
| p、q泄漏部分                                                |                                                           |
| 私钥太小 d<N^0x292                                          | 已知n、e、c可构造任意c1且知它解密后 m1 的末尾某些位的性质 |
| 已知dp或dq（dp = d mod p-1，dq = d mod q-1）                |                                                           |
| 已知解密系统且`2*m<n`                                       | 选择密文攻击                                              |
| 已知d相同，选择不同p,q多次加密同一明文                      | Common Private Exponent Attack                            |
| 已知n、e 、c 可构造任意c1且知它解密后 m1 的末尾某些位的性质 | Least Significant Bit Oracle Attack                       |
