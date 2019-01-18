tar打包
---

```txt
-c  创建tar文件
-f  归档文件名
$tar -cf output.tar [SOURCES_FILE]

-t 列出归档文件中包含文件

-v 冗长模式，verbose
-r 可以将新文件追加到已有归档文件末尾

-x 可以将归档文件提取当当前目录
-C 提取到其它指定目录


--delete从归档文档里删除文件

压缩归档文件
gzip格式
bzip格式

-j 指定bunzip2格式
-z 指定gzip格式
--lzma 指定lzma格式

--exclude [PATTERN] 将通配符模式的文档排除在归档过程之外
$tar -cf arch.tar * --exclude "*.txt"

使用cpio归档
cpio类似于tar 可以归档多个文件和目录，保留文件属性[权限，所有权]
cpio 和tar不同点
cpio 通过stdin获取输入文件名，并将归档文件写入stdout,我们将stdout重定向到文件中来保存cpio的输出
$ls file* |cpio -ov >archive.cpio 
列出cpio归档文档中的文件
$cpio -it < archive.cpio
从cpio归档文件中提取文件
$cpio -id < archive.cpio

gzip和gunzip可以用于压缩和解压缩
$gzip FILE_NAME

$gzip FILE_NAME.gz

可以使用--fast或--best选项指定压缩级别
压缩率有9级，1压缩率最低，压缩最快，9压缩最慢，压缩比最高
$gzip -t TEST.img
gzip默认使用第6级

bzip2和gzip类似，不同点压缩比高压缩慢
$bzip2 FILE_NAME
解压缩bzip2文件
$bunzip2 FILE_NAME.bz2

生成tar.bz2文件方法和tar.gz类似
$tar -xjvf archive.tar.bz2
-j 表示该文档文件是以bzip2格式压缩的

lzma 压缩率高于gzip和bzip2
$lzma FILE_NAME

解压缩
$unlzma FILE_NAME.lzma

pbzip2可以使用多个CPU核心多线程压缩
$sudo apt-get install pbzip2

压缩单个文件
$pbzip2 myfile.tar

-d 进行解压缩
pbzip -d myfile.tar.bz2

手动指定处理器数量-p
pbzip2 -p4 myfile.tar

压缩比-1 到-9 ，-1速度最快，-9压缩比最高
 
创建压缩文件系统
squashfs程序能够创造出一种具有超高压缩率的只读文件系统，可以将2G～3G文件压缩到700MB,Linux CD
就是使用squashfs创建的

$sudo apt-get intstall squashfs-tools
或
$yum install squashfs-tools

$mksquashfs SOURCES compressedfs.squashfs
SOURCES可以是通配符，文件，或目录
利用-o loop环回挂载

$mount -o loop compressedfs.squashfs /mnt/squash


rsync备份快照
rsync相对于cp可以增量备份，仅复制增量新文件，支持远程数据压缩加密
$rsync -av source_path destination_path

-a 表示归档操作
-v [verbose]表示在stdout上打印详细进度

将数据备份到远程服务器
$rsync -av source_dar username@host:PATH

将远程数据同步到本地
$rsync -av username@host:PATH destination

rsync使用SSH连接远程主机，必须使用user@host这种格式
-z 传输过程中压缩数据，节省带宽
$rsync -avz source destination

--exclude PATTERN 排除文件

更新rsync备份时，删除不存在的文件
默认情况下，rsync并不会在目的端删除那些源端已经不存在的文件，如果要删除，可以使用
rsync 的--delete选项

$rsync -avz SOURCE DESTINATION --delete

定期备份crontab
$crontab -ev


```