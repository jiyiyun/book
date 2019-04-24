chapter 2 commands
===

```txt
cat -s FILE_NAME   #输出的时候删除空白行
stat FILE_NAME     #查询文件的atime mtime ctime
getfacl FILE_NAME  #查询文件所属owner,group权限
df -i              #查询inode使用量，剩余量
ls -li  FIME_NAME  #查看文件inode值
```

find查找
---

```txt
-name
-type f 普通文件
-type d 目录
-type c 字符设备
-type b 块设备
-type s 套接字
-type l 符号链接
-type o FIFO
find 也支持逻辑操作符，-a和-and 逻辑与AND -o和-or选项逻辑或OR

find . \( -name '*.txt' -o -name '*.pdf' \) -print

-path可以限定所匹配的路径
find /home/users -path '*/slynux' -name '*.txt' -print


-regex正则匹配
最典型的就是识别email地址，通常转化为
[a-z0-9]+@[a-z0-9]+\.[a-z0-9]+.

-iregex 正则匹配的时候可以忽略大小写

排除参数!
find . ! -name "*.txt" -print 

基于目录深度的搜索
find -maxdepth
find -mindepth
find -L /proc -maxdepth 1 -name 'bundlemaker.def'
-L告诉find 命令跟随符号链接

按照时间戳搜索
-atime  最近访问时间
-mtime  文件内容最后一次修改时间
-ctime  文件元数据(权限或者所有权)最后一次改动时间
整数指具体天数，数字前面 可以用- 或者+,-表示小于，+表示大于

打印最近7内天被访问的所有文件
find . -type f -atime -7 -print

正好7天
find . -type f -atime 7 -print

大于7天
find . -type f -atime +7 -print

-amin  访问时间
-mmin  修改时间(内容)
-cmin  变化时间(权限类元数据)

find . -typef -amin +7 -print

基于文件大小搜索-size
find . -type f -size +2k
find . -type f -size -2k

基于权限匹配-perm

find . -type f -perm 644 -print
find . -type f -name "*.php" ! -perm 644 -print

基于用户匹配-USER 或UID
find . -type f -user slynux -print

利用find执行相应操作
$find . -type f -name "*.swp" -delete

-exec选项
find 命令使用一对{}代表文件名
#find . -type f -user root -exec chown slynux {} \;

-exec全部找出再处理，如果文件特别多会出现问题Argument list too long
xargs 可以找到一条处理一条
xargs命令从stdin处读取一系列参数，再执行指定的命令
xargs命令应该跟在管道符之后
$ vi xargs_example.txt
$ cat xargs_example.txt | xargs
1 2 3 4 5 6 7 8 9 10 11 12

 cat xargs_example.txt | xargs -n 3
1 2 3
4 5 6
7 8 9
10 11 12
-n 选项规定了每行元素个数
xargs工作原理
xargs接受来自stdin的输入，将数据解析成为单个元素，然后用指定的命令将这些元素作为该命令的参数
xargs默认使用空白字符分割输入，并执行/bin/echo

如果文件名包含空格(或者换行),使用空格分割输入就有问题，比如My Document
使用-d选项可以为输入数据指定自定义的分隔符

$ echo "abcXdefXghiXjklmn" |xargs -d X
abc def ghi jklmn

find的输出可以通过管道传送给xargs执行-exec选项无法处理的复杂操作，如果文件名称含有空格
find -print0选项可以使用0(NULL)来分隔查找到的元素，然后用xargs对应的-0选项进行解析

find /smbMount -iname '*.docx' -print0 | xargs -0 grep -L image

xargs有个选项-I,可以用于替换指定字符串，这个字符串会在xargs解析输入时被替换掉，
如果-I与xargs结合使用，对于每个参数，命令只会执行一次
使用-I的时候，命令会以循环的方式执行

结合find使用xargs
xargs和find配合使用的过程要注意会误删，因为xargs默认以空格分割参数
如果文件名中有空格，刚好空格前面的匹配，会造成误删

find . -type f -name "*.txt" -print | xargs rm -f
使用find 命令的-print0选项生成空字符‘\0’，作为分隔符输出，然后将其作为xarg命令输入
find . -type f -name "*.txt" -print0 | xargs -0 rm -f

注意该命令以\;结束，必须对分号进行转义，否则shell将视为find命令的结束而非chown命令的结束

$ find --help
Usage: find [-H] [-L] [-P] [-Olevel] [-D debugopts] [path...] [expression]

默认路径为当前目录；默认表达式为 -print
表达式可能由下列成份组成：操作符、选项、测试表达式以及动作：
操作符 (优先级递减；未做任何指定时默认使用 -and):
      ( EXPR )   ! EXPR   -not EXPR   EXPR1 -a EXPR2   EXPR1 -and EXPR2
      EXPR1 -o EXPR2   EXPR1 -or EXPR2   EXPR1 , EXPR2
位置选项 (总是真): -daystart -follow -regextype

普通选项 (总是真，在其它表达式前指定):
      -depth --help -maxdepth LEVELS -mindepth LEVELS -mount -noleaf
      --version -xdev -ignore_readdir_race -noignore_readdir_race
比较测试 (N 可以是 +N 或 -N 或 N): -amin N -anewer FILE -atime N -cmin N
      -cnewer 文件 -ctime N -empty -false -fstype 类型 -gid N -group 名称
      -ilname 匹配模式 -iname 匹配模式 -inum N -ipath 匹配模式 -iregex 匹配模式
      -links N -lname 匹配模式 -mmin N -mtime N -name 匹配模式 -newer 文件
      -nouser -nogroup -path PATTERN -perm [-/]MODE -regex PATTERN
      -readable -writable -executable
      -wholename PATTERN -size N[bcwkMG] -true -type [bcdpflsD] -uid N
      -used N -user NAME -xtype [bcdpfls]      -context 文本

actions: -delete -print0 -printf FORMAT -fprintf FILE FORMAT -print 
      -fprint0 FILE -fprint FILE -ls -fls FILE -prune -quit
      -exec COMMAND ; -exec COMMAND {} + -ok COMMAND ;
      -execdir COMMAND ; -execdir COMMAND {} + -okdir COMMAND ;
```

tr转换
---

```txt
tr命令可以用来字符替换，字符删除，重复字符压缩
tr只能通过stdin(标准输入)接收输入(无法通过命令行接收参数)

tr [options] set1 set2

stdin输入的字符会按照位置从set1映射到set2 
如果set1 字符和set2字符不相等，用set2会不断复制最后一位直到相等
rich@R:~$ echo “This is test” |tr 'a-z' 'A-Z'
“THIS IS TEST”

tr工作原理
在tr中利用集合的概念，轻松将字符从一个集合映射到另一个集合
加密
rich@R:~$ echo 0123456789 |tr '0-9' 'a-z'
abcdefghij
解密
rich@R:~$ echo abcdefghij |tr 'a-z' '0-9'
0123456789

tr删除字符
tr有个选项-d 可以删除需要删除的字符
$cat file.txt | tr -d '[set1]'
rich@R:~$ echo "Hello 123 world 456" |tr -d '0-9'
Hello  world 

tr字符补齐-c
tr -c [set1] [set2]
rich@R:~$ echo hello 1 char 2 next 4 | tr -d -c '0-9\n'
124

rich@R:~$ echo hello 1 char 3 next 4 | tr -c '0-9' ' '
      1      3      4 

tr压缩字符-s
tr -s '[需要被压缩的一组字符]'
rich@R:~$ echo "GNU is      not UNIX" | tr -s ' '
GNU is not UNIX

rich@R:~$ cat test.txt 
a 1
b 2
c 3
rich@R:~$ cat test.txt |tr -d [a-z] |echo "total: $[$(tr ' ' '+')]"
total: 6

alnum  字母数字
alpha  字母
digit  数字
graph  图形字符
lower  小写字母
upper  大写字母
punct  标点符号
space  空白字符

可以按照如下方式选择所需字符类
tr [:class:] [:class:]
如
tr '[:lower:]' '[:upper:]'

man tr
       -c, -C, --complement
              use the complement of SET1

       -d, --delete
              delete characters in SET1, do not translate

       -s, --squeeze-repeats
              replace each sequence of a repeated character that is listed  in
              the last specified SET, with a single occurrence of that charac‐
              ter

       -t, --truncate-set1
              first truncate SET1 to length of SET2
```

校验md5sum sha256
---

```txt
经常要校验文件的完整性
rich@R:~$ md5sum test.txt 
3f67c889b6b3f8385388d8608059fbc4  test.txt

将校验写入到指定文件
rich@R:~$ md5sum test.txt >test_md5sum.md5
md5sum -c 校验文件   检查文件的完整性
rich@R:~$ md5sum -c test_md5sum.md5
test.txt: 成功
rich@R:~$ cat test_md5sum.md5 
3f67c889b6b3f8385388d8608059fbc4  test.txt

通常光盘等大文件需要校验完整性

对目录进行校验md5deep 或sha1deep,这两个命令默认没有需要安装md5deep软件包
md5deep -rl directory_path > directory.md5
-r 递归遍历
-l 使用相对路径，默认情况下md5deep会输出绝对路径

$find directory_path -type f -print0 } xargs -0 md5sum >>directory.md5
核实
md5sum -c directory.md5
生成目录校验文件的时候一定要加-l，生成相对文件路径，
默认生成绝对路径校验，否则会造成文件路径改变校验失效

shadow-like散列(加盐散列salted hash)

$openssl passwd -l -salt SALT_STRING PASSWOD
将SALT_STRING更换为随机字符串，将PASSWORD替换成设定的密码

```

加密工具与散列 crypt gpg base64
---

```txt
crypt命令一般没有安装需要手动安装
$crypt <input_file >output_file

如果添加加密要口令
$crypt PASSPHRASE <input_file >encrypted_file
 解密
$crypt PASSPHRASE -d <encrypted_file >output_file

gpg加密GNU privacy guard
gpg -c filename
解密
gpg filename.gpg

rich@R:~$ gpg -c test.txt 
gpg: keybox '/home/rich/.gnupg/pubring.kbx' created
rich@R:~$ ls
test_md5sum.md5  test.txt test.txt.gpg
rich@R:/tmp$ gpg test.txt.gpg 
gpg: WARNING: no command supplied.  Trying to guess what you mean ...
gpg: AES256 加密过的数据
gpg: 以 1 个密码加密
rich@R:/tmp$ cat test.txt
a 1
b 2
c 3

base64加密
rich@R:/tmp$ base64 test.txt >test.txt.base64
rich@R:/tmp$ cat test.txt.base64 
YSAxCmIgMgpjIDMK
base64解密方法1
rich@R:/tmp$ base64 -d test.txt.base64 >test2.txt
rich@R:/tmp$ cat test2.txt 
a 1
b 2
c 3
base64解密方法2
rich@R:/tmp$ cat test.txt.base64 | base64 -d > test3.txt
rich@R:/tmp$ cat test3.txt 
a 1
b 2
c 3
```

行排序sort uniq去重
---

```txt
sort 和uniq可以从特定的文件或stdin中获取输入，并将输出写入stdout
$sort file1.txt file2.txt > sorted.txt
或
$sort file1.txt file2.txt -o sorted.txt

$sort -n file.txt       #-n 按数字排序
$sort -r file.txt       #-r 倒序
$sort -M month.txt      #-M 按月排序
$sort file1.txt file2.txt |uniq    #去重

工作原理

一，依照键来排序(默认是按第一列排序的，如果要按照其它列可以使用-k参数)
$sort -nrk 1 data.txt   #按照第一列排序

$sort -k 2 data.txt    #按照第2列进行排序

uniq 通常用在排序过的数据
uniq -c 统计重复的次数
uniq -d 输出重复的行
-s 指定跳过前N个字符
-w 指定用于比较的最大字符数

0值字节终止符
我们将命令输出stdout作为xargs命令输入时，最好为输出的每行添加一个0值字节符zero-byte
使用uniq命令的输入作为xargs数据源也如此，如果没有0值终止符，xargs默认使用空格分割参数
如this is a line会被当做4个不同参数，如果使用0值终止符，\0就会被当做终止符，
-z 选项可以生成0值字节终止符的输出
$uniq -z file.txt
删除file.txt中指定的文件，有-0零值终止符，文件名包含空格也可以正常删除了
$uniq -z file.txt |xargs -0 rm
```

文件分割split
---

```txt
$split -b 10k data.file

大小单位k,M,G c w

split -l 按行分割
-s  静默模式，没有打印输出
-n  分割后文件名后缀的数字个数
-f  分割后文件名前缀
-b  指定后缀模式，文件名=前缀+后缀

```

多个文件名重命名rename
---

```txt
将当前目录下的*.JPG 文件重命名为*.jpg
$rename *.JPG *.jpg


将空格替换成_
$rename 's/ /_/g'

转换文件名称大小写
$rename 'y/A_Z/a-z/' *

将所有后缀为*.mp3的文件移动到指定目录
$find path -type f -name "*.mp3" -exec mv {} target_dir \;

```
