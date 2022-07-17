# Android抓包



## Root权限



### 环境

>  AndroidStdio + 模拟器Android 9.0(google apis) pie x86 ap28



### 脚本

```bash
#抓包进程号
uid=$1
#Burpsuite ***透明*** 代理地址
bp=$2
#Burpsuite的cacert.der证书
cert=$3

if [ -z "$uid" -o -z "$bp" ]; then
	echo "./$0 uid bp_addr"
	exit
fi

install_cert() {
  #格式化证书为手机格式
	openssl x509 -in cacert.der -inform DER -out burp.crt
	file=`openssl x509 -inform PEM -subject_hash_old -in burp.crt | head -1`
	file=$file".0"
	mv burp.crt $file
	#将系统证书目录mount到内存，变成可写状态，将burpsuite证书安装到系统证书目录
	adb root
	adb shell mkdir -m 700 /data/local/tmp/certs
	adb shell cp /system/etc/security/cacerts/*  /data/local/tmp/certs
	adb push $file /data/local/tmp/certs
	adb shell mount -t tmpfs tmpfs /system/etc/security/cacerts
	adb shell cp /data/local/tmp/certs/* /system/etc/security/cacerts/
	adb shell chown root:root /system/etc/security/cacerts/*
	adb shell chmod 644 /system/etc/security/cacerts/*
	adb shell chcon u:object_r:system_file:s0 		   /system/etc/security/cacerts/*
}

if [ ! -z $cert ]; then
	install_cert
fi

#转发流量（注意burpsuite要设置为透明模式）
adb shell su 0 "iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner $uid -j DNAT --to-destination $bp"

```

## 其它

### ssl-unpinning

```bash
	objection -g com.xxxx explore
	android sslpinning disable
```
