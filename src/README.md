# Introduction



## 我的Kali环境

```bash
docker run -idt -h kali --name kali --privileged -p12306:12306 kalilinux/kali-rolling
dpkg --add-architecture i386 
apt-get update
apt-get install libc6:i386 gcc-multilib binwalk gdbserver vim libssl-dev curl git wget make unzip g++ pkg-config procps strace ltrace
#install rizin
https://github.com/rizinorg/rizin/releases/

echo "echo 0 >/proc/sys/kernel/randomize_va_space" >> /etc/profile
```



## 跳板机

```bash
apt-get upgrade
apt-get install curl wget wim proxychains4

curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod 755 msfinstall 
./msfinstall

#Cobaltstrike
#go
https://studygolang.com/dl
#jdk

#设置环境变量.bashrc
export GOROOT=/root/go
export GOPATH=/opt/gosrc
export PAGH=$PATH:/root/go/bin
export GOPROXY=https://goproxy.cn,direct
```


## 武器库

### 信息收集
* https://github.com/0x727/ShuiZe_0x727

### 扫描器
* https://github.com/chaitin/xray 一款功能强大的安全评估工具
* https://github.com/Weik1/Artillery  Artillery 插件化 JAVA 漏洞扫描器（Weblogic、Tomcat、Spring...）
* https://github.com/zan8in/afrog

### fuzz
* https://github.com/ffuf/ffuf
* https://github.com/maurosoria/dirsearch


### 字典
* https://github.com/rootphantomer/Blasting_dictionary
* https://github.com/TheKingOfDuck/fuzzDicts
* https://github.com/danielmiessler/SecLists
* https://github.com/conwnet/wpa-dictionary


### payload
* https://github.com/swisskyrepo/PayloadsAllTheThings 
* https://github.com/fofapro/vulfocus
* https://github.com/Mr-xn/Penetration_Testing_POC
* https://github.com/vulhub/vulhub

### 内网
* https://www.secureauth.com/labs/open-source-tools/impacket/
* https://github.com/b1gcat/anti-av
