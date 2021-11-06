# Frida 模版

## Sample

```javascript
console.log("Script loaded successfully ");

//so Hook
var str_name_so = "liblibdroid.so";    //要hook的so名
var n_addr_func_offset = 0xa10;         //要hook的函数在函数里面的偏移
//加载到内存后 函数地址 = so地址 + 函数偏移
var n_addr_so = Module.findBaseAddress(str_name_so);
var n_addr_func = parseInt(n_addr_so, 16) + n_addr_func_offset;
var ptr_func = new NativePointer(n_addr_func);
var pAddr = null;
Interceptor.attach(ptr_func,
    {
        onEnter: function (args) {
            //onEnter: 进入该函数前要执行的代码，其中args是传入的参数
            //一般so层函数第一个参数都是JniEnv，第二个参数是jclass，从第三个参数开始是我们java层传入的参数
            // console.log("Hook start src ",toByte(args[3]));
            // console.log("Hook start dst",toByte(args[2]));
            pAddr = args[2];
            //打印堆栈
          	print_c_stack(this.context, "fuck");
        },
        onLeave: function (retval) {
            //onLeave: 该函数执行结束要执行的代码，其中retval参数即是返回值
            var a = Uint8ArrayToString(java2jsByte(pAddr));
            if (a.indexOf("Congratulations!") >= 0) {
                console.log("hit", a);
            }
            // send("return:"+retval); //返回值
            // retval.replace(100); //替换返回值为100
        }
    });

//java Hook
Java.perform(function x() {
    console.log("Inside Java perform");
    var m = Java.use("ctf.stratumauhhur.libdroid.a");

    //a被多个重载，通过overload
    //public void ctf.stratumauhhur.libdroid.a.a(android.view.View)
    m.a.overload('android.view.View').implementation = function (view) {
        var dst = [-2, -96, -83, -128, 32, 89, -85, 18, -41, -61, -100, -120, -6, 44, 29, -4, -127, 70, 13, -36, -23, -50, -52, 87, 120, -11, 65, 95, 82, 2, 54, -43, 51, 24, 102, 58, 64, 38, -24, 110, -74, -51, 114, -73, 60, 1, 102, -79, 79, -103, 35, 99, -107, 119, 52, 97, 105, -10, -87, 83, 64, 55, 65, 67, 79, -104, -107, 44, 122, 39, 60, -104, 104, 26, -120, -88, -73, -123, -69, 21, 79, 26, 1, 77, -55, -56, -101, 117, 120, 87, 127, -104, 13, -40, 81, -88, 34, -71, 94, 89, 77, 113, 79, 26, -127, -87, -65, 7, 41, -19, -3, -125];
        var tmp = [];
        var result = java2jsByte(m.f.value)
        console.log("start cracking...")
        //var source = m.d.value;
        var source = "1 3875"

        var pin = source;

        var test = [];

        for (var j = 0; j < 10; j++) {
            test.push(result[j]);
        }

        for (var i = 0; i < pin.length; i++) {
            var ch = pin.charCodeAt(i);
            test.push(ch & 0xff);
        }
        //   console.log(test);
        m.phoneHome(dst, test);


        //return this.a(view);
    };
});

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

//Java返回的数据类型为[]byte时，js会显示object，通过函数js可以读取[]byte
function java2jsByte(jsByte) {
    var ret;
    Java.perform(function () {
        var b = Java.use('[B')
        var buffer = Java.cast(jsByte, b);
        ret = Java.array('byte', buffer);
    });
    return ret;
}

//ArrayBuffer转String: 解决中文乱码(模板)
function ab2str(buf) {
    return new Uint16Array(buf)
    // encodedString = String.fromCodePoint.apply(null, new Uint16Array(buf));
    // // decodedString = encodeURI(encodedString);//没有这一步中文会乱码
    // // console.log(decodedString);
    // return encodedString
}
//string转ArrayBuffer(模板)
function str2ab(str) {
    var buf = new ArrayBuffer(str.length * 2); // 每个字符占用2个字节
    var bufView = new Uint16Array(buf);
    for (var i = 0, strLen = str.length; i < strLen; i++) {
        bufView[i] = str.charCodeAt(i);
    }
    return buf;
}
//字符串转Uint8Array(模板)
function stringToUint8Array(str){
    var arr = [];
    for (var i = 0, j = str.length; i < j; ++i) {
        arr.push(str.charCodeAt(i));
    }

    var tmpUint8Array = new Uint8Array(arr);
    return tmpUint8Array
}
//Uint8Array转字符串(模板)
function Uint8ArrayToString(fileData){
    console.log(fileData)
    var dataString = "";
    for (var i = 0; i < fileData.length; i++) {
        dataString += String.fromCharCode(fileData[i]);
    }

    return dataString
}
```

## 命令启动

```bash
frida -U -f com.android.chrome --no-pause -l test.js
```

## python

```bash
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


remote_device = frida.get_usb_device()
# frida-ps -U
session = remote_device.attach("Hashdays 2012")

src = read_js("./test.js")
script = session.create_script(src)
script.on("message", on_message)
script.load()
sys.stdin.read()

```

## 类型

```bash

Java Type （Java中参数类型）	Frida Type （frida脚本中参数类型）
int	int
byte	byte
short	short
long	long
float	float
double	double
char	char
<Object>（比如String、List）	<package>.<Object>（比如java.lang.String、java.util.List）
int[]	[I
byte[]	[B
short[]	[S
long[]	[J
float[]	[F
double[]	[D
char[]	[C
<Object>[]（比如String[]）	L<package>.<Object>; (比如 [Ljava.lang.String;)
```

