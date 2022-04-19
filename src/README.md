# Introduction

{% simplemindmap type="markdown",style={"height":"200px"} %} 

```markdown
- 密码攻击
  - RSA
    - n可分解
    	curl http://factordb.com/api?query=n
    - e过大或过小
      - Wiener's Attack
    - e非常大且接近n
      - Boneh and Durfee attack
    - e小且明文不大
        - 低加密指数攻击
    - e相同且k组(k>=e)相同明文加密的密文
    	  - 低加密指数广播攻击(中国剩余定理)
    - p、q相差较大或较小
    	  - 分解n(推荐yafu工具)
    - 模不互素gcd(n1,n2)!=1
    	  - 分解n
    - n<256bit
    	  - 分解n（推荐工具rsatool2v17) 
    - n与明文相同
    	  - 共模攻击
    - n与明文相同
    	  - 共模攻击
    - 泄漏部分明文
    - p、q泄漏部分
    - 私钥太小 d<N^0x292
    - 已知n、e、c可构造任意c1且知它解密后 m1 的末尾某些位的性质
    - 已知dp或dq（dp = d mod p-1，dq = d mod q-1）
    - 已知解密系统且`2*m<n`
 	  - 已知d相同，选择不同p,q多次加密同一明文
 - AES/DES/SM4
    - padding oracle attack
    - bit flipping Attack
 - 古典密码
    - 替换密码
     - 推荐词频分析工具:https://quipqiup.com/
    - 凯撒密码
    - 仿射密码
    - 吉利维密
    - OneTimePad
    - base64隐写
 - Hash算法
    - hash长度扩展攻击
    - 爆破
 	
```

{% endsimplemindmap %}
