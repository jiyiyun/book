chapter 1 第一章
---

```txt
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
```

使用变量和环境变量
---

```txt
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
```

获取字符串长度length=$(#var)
---

```txt
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
```

修改bash默认提示字符串(username@hostname:~$)
---

```txt
默认的提示字符串在~/.bashrc中设置
设置history大小
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000

$ cat ~/.bashrc | grep PS1
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

PS1="PROMPT>"
尽量不要修改系统环境变量

HISTFILESIZE=2000
```

使用shell进行数学运算
---

```txt
bash 使用let () [] 工具expr 和bc执行数学运算
richard@richard-PC:/tmp$ num1=3
richard@richard-PC:/tmp$ num2=4
richard@richard-PC:/tmp$ let result=num1+num2
richard@richard-PC:/tmp$ echo $result
7
richard@richard-PC:/tmp$ let num1++
richard@richard-PC:/tmp$ echo $num1
4

richard@richard-PC:/tmp$ let num1+=6
richard@richard-PC:/tmp$ echo $num1
10
richard@richard-PC:/tmp$ echo $[ num1+num2 ]
13
richard@richard-PC:/tmp$ echo $[ $num1+11 ]
21
richard@richard-PC:/tmp$ echo $( $num1+11 )
bash: 10+11: 未找到命令

richard@richard-PC:/tmp$ echo $(($num1+11))
21

richard@richard-PC:/tmp$ expr 3+4
3+4
richard@richard-PC:/tmp$ expr 3 + 4
7
richard@richard-PC:/tmp$ expr 10 * 3
expr: 语法错误
richard@richard-PC:/tmp$ expr 10 \* 3
30
注意使用expr在乘除运算时要用转义符号\,否则一直报错
```

expr能做的运算
---

```txt
  ARG1 | ARG2       若ARG1 的值不为0 或者为空，则返回ARG1，否则返回ARG2
  ARG1 & ARG2       若两边的值都不为0 或为空，则返回ARG1，否则返回 0
  ARG1 < ARG2       ARG1 小于ARG2
  ARG1 <= ARG2      ARG1 小于或等于ARG2
  ARG1 = ARG2       ARG1 等于ARG2
  ARG1 != ARG2      ARG1 不等于ARG2
  ARG1 >= ARG2      ARG1 大于或等于ARG2
  ARG1 > ARG2       ARG1 大于ARG2

  ARG1 + ARG2       计算 ARG1 与ARG2 相加之和
  ARG1 - ARG2       计算 ARG1 与ARG2 相减之差

  ARG1 * ARG2       计算 ARG1 与ARG2 相乘之积
  ARG1 / ARG2       计算 ARG1 与ARG2 相除之商
  ARG1 % ARG2       计算 ARG1 与ARG2 相除之余数
  STR : EXP 如果EXP匹配到STR的某个模式，返回该模式匹配 
  match STR EXP 如果EXP匹配到STR的某个模式，返回该模式匹配 
  substr STR POS LEN 返回起始位置为POS（从1开始计数）、长度为LEN个字符的字符串 
  index STR CHARS 返回在STR中找到CHARS字符串的位置；否则，返回0 
  length STR 返回字符串STR的数值长度 
  + TOKEN 将TOKEN解释成字符串，即使是个关键字 
  (EXPRESSION) 返回EXPRESSION的值
```
echo let expr默认只能进行整数运算，小数浮点数要用bc
---

```txt
richard@richard-PC:/tmp$ echo "4 * 0.56"|bc
2.24
richard@richard-PC:/tmp$ echo "scale=2;22/7"|bc
3.14
richard@richard-PC:/tmp$ echo "sqrt(100)"|bc
10
richard@richard-PC:/tmp$ echo "10*10"|bc
100
richard@richard-PC:/tmp$ echo "2^10"|bc
1024
```

使用awk(可已进行浮点数计算)
---

```txt
   var=1
   var=`echo "$var 1"|awk '{printf("%g",$1*$2)}'`
   echo $var
   输出结果为2
   介绍：
   awk是一种文本处理工具，同时也是一种程序设计语言，作为一种程序设计语言，awk支持多种运算，而我们可以利用awk来进行浮点数计算，和上面bc一样，通过一个简单的管道，我们便可在程序中直接调用awk进行浮点数计算。
   注意：
   1)awk支持除微操作运算符之外的所有运算符
   2)awk内置有log、sqr、cos、sin等等函数
   3)浮点数计算实例
   var=3.14
   var=`echo "$var 2"|awk '{printf("%g",sin($1/$2))}'`
   echo $var
   输出结果为1
```

文件描述重定向
---

```txt
0  stdin   标准输入
1  stdout  标准输出
2  stderr  标准错误

richard@richard-PC:/tmp$ echo "This is a test" >temp.txt
richard@richard-PC:/tmp$ echo "This is a test" >>temp.txt
richard@richard-PC:/tmp$ cat temp.txt 
This is a test
This is a test

把报错重定向到文件中

richard@richard-PC:/tmp$ ls +
ls: 无法访问'+': 没有那个文件或目录
richard@richard-PC:/tmp$ ls + >>temp.txt 
ls: 无法访问'+': 没有那个文件或目录
richard@richard-PC:/tmp$ ls + 2>>temp.txt 
richard@richard-PC:/tmp$ cat temp.txt 
This is a test
This is a test
ls: 无法访问'+': 没有那个文件或目录


richard@richard-PC:/tmp$ ls + && pwd
ls: 无法访问'+': 没有那个文件或目录
richard@richard-PC:/tmp$ ls + || pwd
ls: 无法访问'+': 没有那个文件或目录
/tmp
由上可见
&&是有先后顺序的，前面命令报错后面不执行
||没有先后顺序，
推测出&&是逻辑与
|| 是逻辑或

richard@richard-PC:/tmp$ ls + || pwd 2>stderr.txt 1>stdin.txt
richard@richard-PC:/tmp$ ls
stderr.txt
stdin.txt

richard@richard-PC:/tmp$ cat stderr.txt 
richard@richard-PC:/tmp$ cat stdin.txt 
/tmp
错误并没有写入，原因是||号后面的都成了一个整体，

richard@richard-PC:/tmp$ ls +  2>stderr.txt 1>stdin.txt || pwd 2>>stderr.txt 1>>stdin.txt
richard@richard-PC:/tmp$ cat stderr.txt 
ls: 无法访问'+': 没有那个文件或目录
richard@richard-PC:/tmp$ cat stdin.txt 
/tmp
现在好了
```
将stdout 1 和stderr 2重定向到同一个文件中
---

```txt
ichard@richard-PC:/tmp$ ls + >allout.txt 2>&1|| date >> allout.txt 2>&1
richard@richard-PC:/tmp$ cat allout.txt 
ls: 无法访问'+': 没有那个文件或目录
2019年 01月 04日 星期五 17:39:10 CST
richard@richard-PC:/tmp$ 

不想看到或者保存stderr 2可以将其输出到/dev/null

stdout是单数据流single stream，无法同时把输出打印到屏幕同时将其保存
tee命令可以既将输出重定向到文件，又能将数据重定向到stdout以及一个或者多个文件中

command |tee file1 file2 | OtherCommand

默认情况下tee会覆盖文件，使用-a 追加模式
```

将文件重定向到命令<
---

将文件重定向到命令和重定向相反
richard@richard-PC:/tmp$ cat command.sh 

```shell
#!/bin/bash

cat<<EOF>log.txt
This is a generated file
EOF
```
richard@richard-PC:/tmp$ chmod a+x command.sh 
richard@richard-PC:/tmp$ ./command.sh 
richard@richard-PC:/tmp$ cat log.txt 
This is a generated file

出现在cat <<EOF>log.txt 与下一个EOF之间的所有文本被当作stdin数据
```

数组
---

```txt
bash 4.0以上版本才支持关联数组
richard@richard-PC:/tmp$ array_var=(test1 test2 test3 test4)
richard@richard-PC:/tmp$ echo ${array_var[0]}
test1

richard@richard-PC:/tmp$ array[0]="var1"
richard@richard-PC:/tmp$ array[1]="var2"
richard@richard-PC:/tmp$ array[2]="var3"
richard@richard-PC:/tmp$ array[3]="var4"
richard@richard-PC:/tmp$ echo $array
var1
看来默认下标是array[0],而不是整个数组
打印所有元素1
richard@richard-PC:/tmp$ echo ${array[*]}
var1 var2 var3 var4
打印所有元素2
richard@richard-PC:/tmp$ echo ${array[@]}
var1 var2 var3 var4
打印数组元素个数
richard@richard-PC:/tmp$ echo ${#array[@]}
4

别名alias
alias new_command='command sequence'
例如
alias install='sudo apt-get install'
将alias 写入.bashrc文件，每次shell进程生成时都会执行~/.bashrc中的命令

#echo 'alias cmd="command seq"' >>~/.bashrc

如果要删除别名，执行unalias

我们创建一个别名，能够删除文件，同时在backup目录里面保留副本
alias rm='cp $@ ~/backup && rm $@'

如果已有的别名已存在，新的别名将替换旧的别名

如果是特权用户，别名也会造成安全问题，避免造成损害应该对别名进行转义

不应该以特权用户运行别名化的命令，可以转义要使用的命令，忽略当前定义的别名
$ \command

字符\可以转义命令，从而执行原本命令，在不可信环境下执行特权命令时，在命令前加\
是一种良好的安全实践，攻击者可能利用别名伪装成特权命令

用alias查看当前定义的所有别名
richard@richard-PC:/tmp$ alias
alias ls='ls --color=auto'
```

采集终端信息(行数，列数，密码等)
---

```txt
tput  和 stty是 终端处理工具

richard@richard-PC:/tmp$ tput cols
61
richard@richard-PC:/tmp$ tput lines
27
richard@richard-PC:/tmp$ tput longname
xterm with 256 colors
光标移动到坐标(100,100)处
richard@richard-PC:/tmp$ tput cup 100 100
richard@richard-PC:$ cat password.sh 
```

```shell
#!/bin/bash

#file name password.sh

echo -e "Enter password:>>"
#在读取密码前禁止回显
stty -echo
read password

#允许回显
stty echo
echo
echo Password
read Password
echo -e "password = $password\nPassword = $Password"
	
echo -e "stty 命令的选项-echo禁止将输出发送到终端，echo则默认允许输出到终端"
echo "echo -e "启用反斜杠转义解释""
echo "echo默认把\n不解释直接输出为\n而不是换行，加-e就会对反斜杠解释"
```

