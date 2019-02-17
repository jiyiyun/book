一、Linux Shell 通配符、元字符、转义符
---

```txt
字符                  含义                        实例
*                  匹配0个或多个字符
?                    匹配任意1个字符
[list]               匹配list中任意一个字符        a[xyz]b 只能是xyz中的一个字符
[!list]              匹配 除了list中任意单一字符    a[!0-9]b 排除0-9 
[c1-c2]              匹配c1-c2中任意单一字符
                     如：[0-9][a-z][A-Z]
{string1,string2,...}匹配string1或string2(或更多)
                     其一字符串
```

二、shell元字符
---

```txt
字符    说明
IFS    由<space> <tab> <enter>三者之一产生
CR     由<enter>产生
=      设定变量
$      作为变量或运算替换(不能与shell prompt搞混了)
>      重定向stdout
<      重导向stdin
|      管道
&      重导向file descriptor,或将命令置于后台执行
()     将其内的命令置于nested subshell执行，或用于运算或命令替换
{}     将其内的命令置于non-named function中执行，或用在变量替换的界定范围
;      在前一个命令结束时，而忽略其返回值，继续执行下一个命令
&&     在前一个命令结束时，若返回值为true，继续执行下一条命令
||     在前一个命令结束时，若返回是是false,继续执行下一条命令
！     执行history列表中的命令，例如1068  ls   执行 !1068 就执行ls
```
三、shell转义符
---

```txt
字符  名称    含义
``   反引号   又叫硬转义，其内所有shell元字符，通配符都被关掉，里面不能有单引号
""   双引号   也叫软转义，其内只允许出现特定的shell元字符$用于参数替换，``用于命令替换
\    反斜杠   转义，去除其后面紧跟的元字符或通配符的特殊意义，例如expr 3 \* 4

双引号 只经过参数扩展、命令代换和算术代换就可以送入执行步骤
而单引号转义符直接会被送入执行步骤
```

四、shell中常用特殊变量
---

```txt
变量     含义
$0      当前脚本文件名
$n      传递给脚本或函数的参数，n是数字，传递的第一个参数$1，传递的第n个参数$n
$#      传递给脚本或者函数的参数个数
$*      传递给脚本或者函数的所有参数，把所有参数当作一个整体
$@      传递给脚本或者函数的所有参数，每个参数默认以空格分开
$?      上个命令的退出状态，或函数的返回值，成功返回0，失败返回其它数值
$$      当前shell的进程ID，对于脚本，就是脚本所在进程的ID

$* 和 $@ 都是将参数一个一个返回
"$*"将所有参数当做一个整体字符串返回 , "$@"将参数一个一个返回


!!      执行上一个命令
!n      n为数字，用history命令查看命令序列号，n就是序列号
```

五、常用判断参数
---

```txt
-a file exists.
-b file exists and is a block special file.
-c file exists and is a character special file.
-d file exists and is a directory.
-e file exists (just the same as -a).
-f file exists and is a regular file.
-g file exists and has its setgid(2) bit set.
-G file exists and has the same group ID as this process.
-k file exists and has its sticky bit set.
-L file exists and is a symbolic link.
-n string length is not zero.
-o Named option is set on.
-O file exists and is owned by the user ID of this process.
-p file exists and is a first in, first out (FIFO) special file or named pipe.
-r file exists and is readable by the current process.
-s file exists and has a size greater than zero.
-S file exists and is a socket.
-t file descriptor number fildes is open and associated with a terminal device.
-u file exists and has its setuid(2) bit set.
-w file exists and is writable by the current process.
-x file exists and is executable by the current process.
-z string length is zero.
```

六、判断命令
---

```txt
命令     含义      英文释义
-eq     等于      equate
-ne     不等于    not equate
-gt     大于      great
-lt     小于      litter
ge      大于等于   great  equate
le      小于等于   litter equate

shell 中-a 和-o 都有两个意思，多条件判断时当and 和or用
if [ $a -ge 0 -a $a -le 100  ];then 
0<=a<=100

```
七、字符类
---

```txt
alnum  字母数字
alpha  字母
cntrl  控制(非打印)字符
digit  数字
graph  图形字符
lower  小写字母
upper  大写字母
print  可打印字符
punct  标点符号
space  空白字符
xdigit 十六进制字符 
[0-9][a-z][A-Z]
```
八、Linux shell 中$() ` `，${}，$[] $(())，[ ] (( )) [[ ]]作用与区别
---

```txt
1 $()
在bash shell中，$() 与` (反引号,tab键上面那个) 都是用来做命令替换用(command substitution)的
例如 version=$(uname -r) 和version=`uname -r` 都是version得到内核版本号

各自优缺点
1) ` (反引号,tab键上面那个)，可以在全部unix shell中通用，若写成shell script，其移植性比较高。但是反引号容易看错或者打错。
2) $()并不是所有shell都支持

2 ${} 变量替换
${}用于变量替换，一般情况下，$var 与${var}没啥不一样，但是用${}会比较精确的界定变量名称的范围，比如

rich@R:~$ A=B
rich@R:~$ echo $AB

rich@R:~$ echo ${A}B
BB
rich@R:~$

3 $[] $(())
它们是一样的，都是进行数学运算的。支持+ - * / % 分别为加 减 乘 除 取模 ，但是注意bash只能做整数运算，对于浮点数是当作字符串处理的
rich@R:~$ a=1;b=2;c=3
rich@R:~$ echo $(( a+b*c ))
7
rich@R:~$ echo $(( (a+b)/c ))
1
rich@R:~$ echo $(( (a*c)%b ))
1
在$((  ))中的变量名称，可以在其前面加$符号来替换，也可以不用，如：
rich@R:~$ echo $(( $a + $b * $c ))
7

4 [] 中括号
即为test命令的一种形式，但是注意：
1)必须在[  ]内部两边加空格，否则报错
rich@R:~$ echo $[ a + b + c ]
6
2)test命令使用标准数学比较符号来表示字符串比较，而用文本符号来表示数值的比较
3) 大于符号或小于符号必须要转义，否则会被解释成重定向

5 (()) 及  [[]]
它们分别是[]的针对数学比较表达式和字符串表达式的加强版，其中(())不需要再将表达式里面的大小符号转义，除了可以使用标准的数学运算符外，还增加一下符号

符号   描述
val++  后增
val--  后减
++val  先增
--val  先减
!      逻辑求反
~      位求反
**     幂运算
<<     左位移
>>     右位移
&      位布尔和
|      位布尔或
&&     逻辑和
||     逻辑或

源文章https://blog.csdn.net/ai_xiangjuan/article/details/82082391
```
九、正则匹配
---

```txt
一、校验数字的表达式
 1 数字：^[0-9]*$
 2 n位的数字：^\d{n}$
 3 至少n位的数字：^\d{n,}$
 4 m-n位的数字：^\d{m,n}$
 5 零和非零开头的数字：^(0|[1-9][0-9]*)$
 6 非零开头的最多带两位小数的数字：^([1-9][0-9]*)+(.[0-9]{1,2})?$
 7 带1-2位小数的正数或负数：^(\-)?\d+(\.\d{1,2})?$
 8 正数、负数、和小数：^(\-|\+)?\d+(\.\d+)?$
 9 有两位小数的正实数：^[0-9]+(.[0-9]{2})?$
10 有1~3位小数的正实数：^[0-9]+(.[0-9]{1,3})?$
11 非零的正整数：^[1-9]\d*$ 或 ^([1-9][0-9]*){1,3}$ 或 ^\+?[1-9][0-9]*$
12 非零的负整数：^\-[1-9][]0-9"*$ 或 ^-[1-9]\d*$
13 非负整数：^\d+$ 或 ^[1-9]\d*|0$
14 非正整数：^-[1-9]\d*|0$ 或 ^((-\d+)|(0+))$
15 非负浮点数：^\d+(\.\d+)?$ 或 ^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$
16 非正浮点数：^((-\d+(\.\d+)?)|(0+(\.0+)?))$ 或 ^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$
17 正浮点数：^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$ 或 ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$
18 负浮点数：^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$ 或 ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$
19 浮点数：^(-?\d+)(\.\d+)?$ 或 ^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$

二、校验字符的表达式
 1 汉字：^[\u4e00-\u9fa5]{0,}$
 2 英文和数字：^[A-Za-z0-9]+$ 或 ^[A-Za-z0-9]{4,40}$
 3 长度为3-20的所有字符：^.{3,20}$
 4 由26个英文字母组成的字符串：^[A-Za-z]+$
 5 由26个大写英文字母组成的字符串：^[A-Z]+$
 6 由26个小写英文字母组成的字符串：^[a-z]+$
 7 由数字和26个英文字母组成的字符串：^[A-Za-z0-9]+$
 8 由数字、26个英文字母或者下划线组成的字符串：^\w+$ 或 ^\w{3,20}$
 9 中文、英文、数字包括下划线：^[\u4E00-\u9FA5A-Za-z0-9_]+$
10 中文、英文、数字但不包括下划线等符号：^[\u4E00-\u9FA5A-Za-z0-9]+$ 或 ^[\u4E00-\u9FA5A-Za-z0-9]{2,20}$
11 可以输入含有^%&',;=?$\"等字符：[^%&',;=?$\x22]+
12 禁止输入含有~的字符：[^~\x22]+

三、特殊需求表达式
 1 Email地址：^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
 2 域名：[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?
 3 InternetURL：[a-zA-z]+://[^\s]* 或 ^http://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$
 4 手机号码：^(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])\d{8}$ (由于工信部放号段不定时，所以建议使用泛解析 ^([1][3,4,5,6,7,8,9])\d{9}$)
 5 电话号码("XXX-XXXXXXX"、"XXXX-XXXXXXXX"、"XXX-XXXXXXX"、"XXX-XXXXXXXX"、"XXXXXXX"和"XXXXXXXX)：^(\(\d{3,4}-)|\d{3.4}-)?\d{7,8}$ 
 6 国内电话号码(0511-4405222、021-87888822)：\d{3}-\d{8}|\d{4}-\d{7} 
 7 18位身份证号码(数字、字母x结尾)：^((\d{18})|([0-9x]{18})|([0-9X]{18}))$
 8 帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
 9 密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)：^[a-zA-Z]\w{5,17}$
10 强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-10之间)：^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[\da-zA-Z]{8,10}$
11 日期格式：^\d{4}-\d{1,2}-\d{1,2}
12 一年的12个月(01～09和1～12)：^(0?[1-9]|1[0-2])$
13 一个月的31天(01～09和1～31)：^((0?[1-9])|((1|2)[0-9])|30|31)$ 
14 钱的输入格式：
15    1.有四种钱的表示形式我们可以接受:"10000.00" 和 "10,000.00", 和没有 "分" 的 "10000" 和 "10,000"：^[1-9][0-9]*$ 
16    2.这表示任意一个不以0开头的数字,但是,这也意味着一个字符"0"不通过,所以我们采用下面的形式：^(0|[1-9][0-9]*)$ 
17    3.一个0或者一个不以0开头的数字.我们还可以允许开头有一个负号：^(0|-?[1-9][0-9]*)$ 
18    4.这表示一个0或者一个可能为负的开头不为0的数字.让用户以0开头好了.把负号的也去掉,因为钱总不能是负的吧.下面我们要加的是说明可能的小数部分：^[0-9]+(.[0-9]+)?$ 
19    5.必须说明的是,小数点后面至少应该有1位数,所以"10."是不通过的,但是 "10" 和 "10.2" 是通过的：^[0-9]+(.[0-9]{2})?$ 
20    6.这样我们规定小数点后面必须有两位,如果你认为太苛刻了,可以这样：^[0-9]+(.[0-9]{1,2})?$ 
21    7.这样就允许用户只写一位小数.下面我们该考虑数字中的逗号了,我们可以这样：^[0-9]{1,3}(,[0-9]{3})*(.[0-9]{1,2})?$ 
22    8.1到3个数字,后面跟着任意个 逗号+3个数字,逗号成为可选,而不是必须：^([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(.[0-9]{1,2})?$ 
23    备注：这就是最终结果了,别忘了"+"可以用"*"替代如果你觉得空字符串也可以接受的话(奇怪,为什么?)最后,别忘了在用函数时去掉去掉那个反斜杠,一般的错误都在这里
24 xml文件：^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\.[x|X][m|M][l|L]$
25 中文字符的正则表达式：[\u4e00-\u9fa5]
26 双字节字符：[^\x00-\xff]    (包括汉字在内，可以用来计算字符串的长度(一个双字节字符长度计2，ASCII字符计1))
27 空白行的正则表达式：\n\s*\r    (可以用来删除空白行)
28 HTML标记的正则表达式：<(\S*?)[^>]*>.*?</\1>|<.*? />    (网上流传的版本太糟糕，上面这个也仅仅能部分，对于复杂的嵌套标记依旧无能为力)
29 首尾空白字符的正则表达式：^\s*|\s*$或(^\s*)|(\s*$)    (可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式)
30 腾讯QQ号：[1-9][0-9]{4,}    (腾讯QQ号从10000开始)
31 中国邮政编码：[1-9]\d{5}(?!\d)    (中国邮政编码为6位数字)
32 IP地址：\d+\.\d+\.\d+\.\d+    (提取IP地址时有用)
33 IP地址：((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))

源文章http://www.cnblogs.com/zxin/archive/2013/01/26/2877765.html
```

十、linux 文件权限 s 权限和 t 权限解析
---

```txt
常用权限
linux系统内有档案有三种身份 u:拥有者  g:群组   o:其他人
这些身份对于文档常用的有下面权限：
r：读权限，用户可以读取文档的内容，如用cat，more查看
w：写权限，用户可以编辑文档
x：该目录具有可以被系统执行的权限

特殊权限
[root@www ~]# ls -ld /tmp ; ls -l /usr/bin/passwd /usr/bin/locate /var/lib/mlocate/mlocate.db
drwxrwxrwt 7 root root 4096 Sep 27 18:23 /tmp
-rwsr-xr-x 1 root root 22984 Jan 7 2007 /usr/bin/passwd
-rwx--s--x 1 root slocate 23856 Mar 15 2007 /usr/bin/locate
-rw-r----- 1 root slocate 3175776 Sep 28 04:02 /var/lib/mlocate/mlocate.db

其它权限  强制位(s权限) 粘滞位(t权限)

Set UID:
当 s 这个标志出现在文件拥有者的 x 权限上时,如上 /usr/bin/passwd 这个文件的权限状态，此时就被称为 Set UID，简称为 SUID 的特殊权限。基本上SUID有这样的限制与功能：

SUID 权限仅对二进位程序(binary program)有效(不能够用在 shell script 上面)
运行者对於该程序需要具有 x 的可运行权限
本权限仅在运行该程序的过程中有效 (run-time)
运行者将具有该程序拥有者 (owner) 的权限

这个权限存在很大的风险，普通用户临时拥有root权限，一般情况下是绝对不允许出现的

SGID:
与 SUID 不同的是，SGID 可以针对文件或目录来配置！

如果是对文件来说， SGID 有如下的功能：
SGID 对二进位程序有用,程序运行者对於该程序来说，需具备 x 的权限
运行者在运行的过程中将会获得该程序群组的权限
如果针对的是目录,SGID 有如下的功能：

使用者若对於此目录具有 r 与 x 的权限时，该使用者能够进入此目录；
使用者在此目录下的有效群组(effective group)将会变成该目录的群组；

Sticky Bit:
这个 Sticky Bit, SBIT 目前只针对目录有效作用是：

当使用者对於此目录具有 w, x 权限，亦即具有写入的权限时；
当使用者在该目录下创建文件或目录时，仅有自己与 root 才有权力删除该文件
换句话说：当甲这个使用者於 A 目录是具有群组或其他人的身份，并且拥有该目录 w 的权限， 这表示『甲使用者对该目录内任何人创建的目录或文件均可进行 "删除/更名/搬移" 等动作。』 不过，如果将 A 目录加上了 SBIT 的权限项目时， 则甲只能够针对自己创建的文件或目录进行删除/更名/移动等动作，而无法删除他人的文件。

s权限： 设置使文件在执行阶段具有文件所有者的权限，相当于临时拥有文件所有者的身份.
典型的文件是passwd. 如果一般用户执行该文件, 则在执行过程中, 该文件可以获得root权限,
从而可以更改用户的密码.
root@richard-PC:~# ls -al /usr/bin/passwd 
-rwsr-xr-x 1 root root 59640 8月  13 21:22 /usr/bin/passwd

设置suid：将相应的权限位之前的那一位设置为4；
设置guid：将相应的权限位之前的那一位设置为2；
两者都置位：将相应的权限位之前的那一位设置为4+2=6。

注意：在设置s权限时文件属主、属组必须先设置相应的x权限，否则s权限并不能正真生效（chmod命令不进行必要的完整性检查，即使不设置x权限就设置s权限，chmod也不会报错，当我们ls -l时看到rwS，大写S说明s权限未生效）

t权限
t权限：要删除一个文档，您不一定要有这个文档的写权限，但您一定要有这个文档的上级目录的写权限。也就是说，您即使没有一个文档的写权限，但您有这个文档的上级目录的写权限，您 也能够把这个文档给删除，而假如没有一个目录的写权限，也就不能在这个目录下创建文档。 

怎样才能使一个目录既能够让任何用户写入文档，又不让用户删除这个目录下他人的文档，t权限就是能起到这个作用。t权限一般只用在目录上，用在文档上起不到什么作用。 

在一个目录上设了t权限位后，（如/home，权限为1777)任何的用户都能够在这个目录下创建文档，但只能删除自己创建的文档(root除外)，这就对任何用户能写的目录下的用户文档 启到了保护的作用。

可以通过chmod +t filename 来设置t权限
```
隐藏属性
---

```txt
除了基本r, w, x权限外,在Linux的Ext2/Ext3文件系统下,我们还可以配置其他的系统隐藏属性. 不过要先强调的是,底下的chattr命令只能在Ext2/Ext3的文件系统上面生效, 其他的文件系统可能就无法支持这个命令了.底下我们就来谈一谈如何配置与检查这些隐藏的属性吧！
chattr (配置文件隐藏属性)
[root@www ~]# chattr [+-=][ASacdistu] 文件或目录名称
选项与参数：
+ ：添加某一个特殊参数,其他原本存在参数则不动.
- ：移除某一个特殊参数,其他原本存在参数则不动.
= ：配置一定,且仅有后面接的参数
A ：当配置了 A 这个属性时,若你有存取此文件(或目录)时,他的存取时间 atime将不会被修改,可避免I/O较慢的机器过度的存取磁碟.这对速度较慢的计算机有帮助
S ：一般文件是非同步写入磁碟的(原理请参考第五章sync的说明),如果加上 S 这个属性时,当你进行任何文件的修改,该更动会『同步』写入磁碟中.
a ：当配置 a 之后,这个文件将只能添加数据,而不能删除也不能修改数据,只有root 才能配置这个属性. 
c ：这个属性配置之后,将会自动的将此文件『压缩』,在读取的时候将会自动解压缩,但是在储存的时候,将会先进行压缩后再储存(看来对於大文件似乎蛮有用的！)
d ：当 dump 程序被运行的时候,配置 d 属性将可使该文件(或目录)不会被 dump 备份
i ：这个 i 可就很厉害了！他可以让一个文件『不能被删除、改名、配置连结也无法写入或新增数据！』对於系统安全性有相当大的助益！只有 root 能配置此属性
s ：当文件配置了 s 属性时,如果这个文件被删除,他将会被完全的移除出这个硬盘空间,所以如果误删了,完全无法救回来了喔！
u ：与 s 相反的,当使用 u 来配置文件时,如果该文件被删除了,则数据内容其实还存在磁碟中,可以使用来救援该文件喔！
注意：属性配置常见的是 a 与 i 的配置值,而且很多配置值必须要身为 root 才能配置

范例：请尝试到/tmp底下创建文件,并加入 i 的参数,尝试删除看看.
[root@www ~]# cd /tmp
[root@www tmp]# touch attrtest <==创建一个空文件
[root@www tmp]# chattr +i attrtest <==给予 i 的属性
[root@www tmp]# rm attrtest <==尝试删除看看
rm: remove write-protected regular empty file `attrtest'? y
rm: cannot remove `attrtest': Operation not permitted <==操作不许可
# 看到了吗？连 root 也没有办法将这个文件删除呢！赶紧解除配置！

范例：请将该文件的 i 属性取消！
[root@www tmp]# chattr -i attrtest
这个命令是很重要的,尤其是在系统的数据安全上面！由於这些属性是隐藏的性质,所以需要以 lsattr 才能看到该属性！其中,个人认为最重要的当属 +i 与 +a 这个属性了.+i 可以让一个文件无法被更动,对於需要强烈的系统安全的人来说, 真是相当的重要的！里头还有相当多的属性是需要 root 才能配置的呢！

此外,如果是 log file 这种的登录档,就更需要 +a 这个可以添加,但是不能修改旧有的数据与删除的参数了

lsattr (显示文件隐藏属性)
[root@www ~]# lsattr [-adR] 文件或目录

选项与参数：
-a ：将隐藏档的属性也秀出来；
-d ：如果接的是目录,仅列出目录本身的属性而非目录内的档名；
-R ：连同子目录的数据也一并列出来！
[root@www tmp]# chattr +aij attrtest
[root@www tmp]# lsattr attrtest
----ia---j--- attrtest

https://www.cnblogs.com/kzang/articles/2673790.html
```
```txt
NAME
       chattr - change file attributes on a Linux file system

SYNOPSIS
       chattr [ -RVf ] [ -v version ] [ -p project ] [ mode ] files...

DESCRIPTION
       chattr changes the file attributes on a Linux file system.

       The format of a symbolic mode is +-=[aAcCdDeijPsStTu].

       The  operator  '+'  causes  the  selected attributes to be added to the
       existing attributes of the files; '-' causes them to  be  removed;  and
       '=' causes them to be the only attributes that the files have.

       The  letters 'aAcCdDeijPsStTu' select the new attributes for the files:
       append only (a), no atime updates (A), compressed (c), no copy on write
       (C), no dump (d), synchronous directory updates (D), extent format (e),
       immutable (i), data journalling  (j),  project  hierarchy  (P),  secure
       deletion  (s),  synchronous  updates  (S),  no tail-merging (t), top of
       directory hierarchy (T), and undeletable (u).

       The following attributes are read-only, and may be listed by  lsattr(1)
       but  not  modified by chattr: encrypted (E), indexed directory (I), and
       inline data (N).

       Not all flags are supported or utilized by all  filesystems;  refer  to
       filesystem-specific man pages such as btrfs(5), ext4(5), and xfs(5) for
       more filesystem-specific details.

OPTIONS
       -R     Recursively change attributes of directories and their contents.

       -V     Be verbose with chattr's output and print the program version.

       -f     Suppress most error messages.

       -v version
              Set the file's version/generation number.

       -p project
              Set the file's project number.
```

```txt
问：
1、现在要实现一个功能，file.log文件只能往里面添加，不允许删除，怎么设置？
   答：chattr +a file.log
2、在一个共享目录下，每个用户只能修改删除自己创建的，不能修改删除其它用户创建的文件，怎么实现？
   答：给目录添加t位属性 chmod +t filename
```


atime mtime ctime
---

```txt
在Linux下一个文件也有三种时间属性：（与windows不同的是linux没有创建时间，而多了个访问时间）
1>访问时间（access time 简写为atime）
2>修改时间（modify time 简写为mtime）
3>状态修改时间(change time 简写为ctime)

关于Linux底下三种时间的简单介绍：
atime:（access time）显示的是文件中的数据最后被访问的时间，比如系统的进程直接使用或通过一些命令
       和脚本间接使用。（执行一些可执行文件或脚本）
mtime: （modify time）显示的是文件内容被修改的最后时间，比如用vi编辑时就会被改变。（也就是Block的内容）
ctime: （change time）显示的是文件的权限、拥有者、所属的组、链接数发生改变时的时间。当然当内容
       改变时也会随之改变（即inode内容发生改变和Block内容发生改变时）
查看这三种时间,使用的命令为：stat filename
原文：https://blog.csdn.net/wodeqingtian1234/article/details/53975744 

rich@R:~$ stat github/book_note/Linux_Shell通配符元字符转义符文件权限.md 
  文件：github/book_note/Linux_Shell通配符元字符转义符文件权限.md
  大小：14635     	块：32         IO 块：4096   普通文件
设备：801h/2049d	Inode：803943      硬链接：1
权限：(0644/-rw-r--r--)  Uid：( 1000/    rich)   Gid：( 1000/    rich)
最近访问：2019-01-22 17:38:38.223488467 +0800
最近更改：2019-01-12 10:36:31.096884300 +0800
最近改动：2019-01-12 10:36:31.096884300 +0800
创建时间：-
```

last用户登录记录
---

```txt
rich@R:~$ last
rich     tty1         :0               Tue Jan 22 17:30   still logged in
reboot   system boot  4.15.0-29deepin- Tue Jan 22 17:29   still running
rich     tty1         :0               Sun Jan 20 09:15 - 12:06  (02:51)
reboot   system boot  4.15.0-29deepin- Sun Jan 20 09:14 - 12:06  (02:52)
rich     tty1         :0               Sat Jan 19 17:17 - 20:15  (02:58)

```

设置ssh相关参数
---

```txt
#Port 22
#PermitRootLogin prohibit-password
#PermitEmptyPasswords no
#MaxAuthTries 6
#MaxSessions 10
#ClientAliveInterval 0    设置ssh保持时间
#ClientAliveCountMax 3    设置允许超时的次数
```
```txt
ssh超时断开设置
$TMOUT系统环境变量：
#vi /etc/profile
在最后一行增加
export TMOUT=1800（单位秒）
```