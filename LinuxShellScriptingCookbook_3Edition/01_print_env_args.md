chapter 1 第一章
---

问：怎样查看当前使用的那个shell
richard@richard-PC:$ echo $0
/bin/bash
richard@richard-PC:$ echo $SHELL
/bin/bash
查看当前用户默认shell   cat /etc/passwd
richard:x:1000:1000::/home/richard:/bin/bash

问怎么确定当前用户是不是root身份
richard@richard-PC:$ echo $UID
1000
root用户的UID是0，当前用户UID是1000不是root
richard@richard-PC:$ who
richard  tty1         2019-01-04 08:47 (:0)


echo默认会在末尾加换行符，可以使用-n禁止换行

echo -e 对包含转义的字符串进行转义
richard@richard-PC:$ echo "1\t2\t3\t"
1\t2\t3\t
richard@richard-PC:$ echo -e "1\t2\t3\t"
1	2	3	
richard@richard-PC:$ echo  "1\n2\n3\n" 
1\n2\n3\n
richard@richard-PC:$ echo -e "1\n2\n3\n"
1
2
3

打印颜色输出
$ echo -e "\e[1;31m This is red text"
 This is red text

重置0，黑色=30，红色=31，绿色=32，黄色=33.蓝色=34，洋红=34,35，青色36，白色37

richard@richard-PC:$ echo -e "\e[1;31m This is red text \e[0m"
 This is red text
\e[1;31m是一个转义符，将颜色设置成红色
可以通过man console_codes查看相关文档

使用变量和环境变量
---

$ env 或者printenv查看当前环境变量
查看进程环境变量
richard@richard-PC:$ cat /proc/$PID/environ
richard@richard-PC:$ top

top - 11:32:27 up  2:46,  1 user,  load average: 0.18, 0.19, 
Tasks: 150 total,   1 running, 149 sleeping,   0 stopped,   0
%Cpu(s):  1.0 us,  0.3 sy,  0.0 ni, 98.6 id,  0.0 wa,  0.0 hi
MiB Mem :   3944.9 total,   1974.3 free,    614.2 used,   135
MiB Swap:      0.0 total,      0.0 free,      0.0 used.   304

PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM 
4081 richard   20   0 1676272  49352  33360 S   2.3   1.2 

richard@richard-PC:$ cat /proc/4081/environ
guid=65d0cebf152e0e39af3383c25c2ead13
SHELL=/bin/bash
GDMSESSION=deepin
USER=richard
XDG_GREETER_DATA_DIR=/var/lib/lightdm/data/richard
PATH=/usr/local/bin:/usr/bin

赋值给变量
varName=value
注意：不同
var = value   #等量关系的测试
var=value     #赋值给前面参数

shell通过空格来分割单词，要加花括号

richard@richard-PC:$ echo $PATH
/home/richard/.pyenv/shims:/home/richard/.pyenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin

获取字符串长度length=$(#var)
---

richard@richard-PC:$ var=123
richard@richard-PC:$ echo ${#var}
3

richard@richard-PC:$ echo $PATH
/home/richard/.pyenv/shims:/home/richard/.pyenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin
richard@richard-PC:$ echo ${#PATH}
124

用python检查下对不对
richard@richard-PC:$ python
Python 3.6.6 (default, Aug 15 2018, 20:31:02) 
[GCC 7.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> str="/home/richard/.pyenv/shims:/home/richard/.pyenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin"
>>> len(str)
124

richard@richard-PC:$ var=123132sfsds
richard@richard-PC:$ echo ${#var}
11


