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
```

七、linux 文件权限 s 权限和 t 权限解析
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
man chattr
       chattr changes the file attributes on a Linux file system.
       The format of a symbolic mode is +-=[aAcCdDeijPsStTu].

       The  operator '+' causes the selected attributes to be added to the existing attributes of the files; '-' causes them to be removed; and '=' causes them to be the only attributes that the files have.
       The letters 'aAcCdDeijPsStTu' select the new attributes for the files: append only (a), no atime  updates(A),  compressed (c), no copy on write (C), no dump (d), synchronous directory updates (D), extent format (e), immutable (i), data journalling (j), project hierarchy (P), secure deletion (s), synchronous updates (S), no tail-merging (t), top of directory hierarchy (T), and undeletable (u).
       The  following  attributes  are  read-only,  and  may  be listed by lsattr(1) but not modified by chattr: encrypted (E), indexed directory (I), and inline data (N).
       Not all flags are supported or utilized by all filesystems; refer to filesystem-specific man  pages  such as btrfs(5), ext4(5), and xfs(5) for more filesystem-specific details.

A  file  with the 'a' attribute set can only be open in append mode for writing.  Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability can set or clear this attribute.

A file with the 'i' attribute cannot be modified: it cannot be deleted or renamed, no link can be created to  this  file,  most of the file's metadata can not be modified, and the file can not be opened in write mode.  Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability  can  set  or  clear this attribute.
```

```txt
问：
1、现在要实现一个功能，file.log文件只能往里面添加，不允许删除，怎么设置？
   答：chattr +a file.log
2、在一个共享目录下，每个用户只能修改删除自己创建的，不能修改删除其它用户创建的文件，怎么实现？
   答：给目录添加t位属性 chmod +t filename
```
