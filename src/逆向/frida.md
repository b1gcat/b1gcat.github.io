# Frida 模版

## 快速使用

```bash
	1、启动frida—server
	bin="frida-server15010.x8664"
	adb kill-server
	adb devices 
  adb push frida/server/${bin}  /data/local/tmp/frida-server
  adb shell chmod +x /data/local/tmp/frida-server
  adb shell /data/local/tmp/frida-server -l 0.0.0.0
  
  2、查找hook的activity
    adb shell dumpsys activity | grep "mResumed"
    
  3、启动
  frida -U -f com.xxx.xxx --no-pause -l sample.js
```

### hook java sample.js

```javascript
console.log("Script loaded successfully ");
Java.perform(function x() {
    console.log("Inside Java perform");
    var m = Java.use("ctf.stratumauhhur.libdroid.a");

    //如果a被多个重载，需要设置overload以及参数类型
    //public void ctf.stratumauhhur.libdroid.a.a(android.view.View)
  	//overload('java.lang.String')
    m.a.overload('android.view.View').implementation = function (view) {
    	  console.log("hooked");
      	//打印成员变量
        //string类型:m.flag.value
        //[B:
      		//var bs = Java.use("com.android.okhttp.okio.ByteString");
      		//console.log(bs.of(m.flag.value).hex())
      	//[B>类型
      		//var buffer =Java.array("byte",m.f.value);
        	//console.log(buffer);
        //未知类型:JSON.stringify(m.flag)
        return this.a(view);
    }; });
```

### hook so sample.js

```javascript
console.log("Script loaded successfully ");

//so Hook
var ptr_func = Module.getBaseAddress('liblibdroid.so').add(0x970);
Interceptor.attach(ptr_func,
    {
        onEnter: function (args) {
            //onEnter: 进入该函数前要执行的代码，其中args是传入的参数
            //一般so层函数第一个参数都是JniEnv，第二个参数是jclass，从第三个参数开始是我们java层传入的参数
           console.log("enter")
           //console.log(hexdump(args[0]));
           console.log(Memory.readByteArray(args[0],256));
           //args[0].readCString() // 读字符串
					 //args[0].readPointer() // 读指针值
        	 //args[2] = ptr(1000) // 参数修改为1000
        },
        onLeave: function (retval) {
           //onLeave: 该函数执行结束要执行的代码，其中retval参数即是返回值
           // retval.replace(100); //替换返回值为100
          console.log("leave:"+retval);
        }
    });
```

## Python启动

```python
import frida
import sys

def read_js(file):
    with open(file) as fp:
        return fp.read()


def on_message(message, data):
    if message["type"] == "send":
        print("[+] {}".format(message["payload"]))
    else:
        print("[-] {}".format(message))


device = frida.get_usb_device()
# frida-ps -U

pid = device.spawn(['ctf.stratumauhhur.libdroid'])
print("[+] Got PID %d" % pid)
session = device.attach(pid)
#session = remote_device.attach("包名字")

script = session.create_script(read_js("./agent.js"))

# Callback function
script.on('message', on_message)
script.load()

device.resume(pid)

sys.stdin.read()
print("[+] Done")
```



## Trace

```javascript
function print_c_stack(context, str_tag) {
    console.log('');
    console.log("=============================" + str_tag + " Stack strat=======================");       
    console.log(Thread.backtrace(context, Backtracer.ACCURATE).map(DebugSymbol.fromAddress).join('\n'));
    console.log("=============================" + str_tag + " Stack end  ======================="); 
}

function showStacks3(str_tag) {
    var Exception = Java.use("java.lang.Exception");
    var ins = Exception.$new("Exception");
    var straces = ins.getStackTrace();

    if (undefined == straces || null == straces) {
        return;
    }

    console.log("=============================" + str_tag + " Stack strat=======================");
    console.log("");

    for (var i = 0; i < straces.length; i++) {
        var str = "   " + straces[i].toString();
        console.log(str);
    }

    console.log("");
    console.log("=============================" + str_tag + " Stack end=======================\r\n");
    Exception.$dispose();
}
```



