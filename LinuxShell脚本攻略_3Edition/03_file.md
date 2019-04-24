1、生成任意大小的文件dd
---

```txt

if  表示输入文件 input file
of  表示输出文件 output file
bs 表示以字节为单位块的大小block size
count 表示需要被复制的块数

注意：dd命令运行在设备底层，搞不好会把磁盘清空或毁坏数据

创建一个内容全为0的1MB大小的文件
rich@R:/tmp$ dd if=/dev/zero of=data bs=1M count=10
记录了10+0 的读入
记录了10+0 的写出
10485760 bytes (10 MB, 10 MiB) copied, 0.0260481 s, 403 MB/s
rich@R:/tmp$ du -sh data 
10M	data
```

文本文件交集intersection 和差集set difference
---

```txt
comm命令必须使用两个已经排序过的文件
comm A.txt B.txt

```
文件权限，粘滞位sticky bit
---

```txt
目录有个权限叫做粘滞位的特殊权限，设置了粘滞位，只有创建目录的用户才可以删除里面的文件
------rwt    ------rwT
粘滞位最典型的就是/tmp目录，任何人都可以在该目录创建文件，但只有所有者可以删

chmod a+t file
```

设置文件为不可修改setuid
---

```txt
chattr +i file

恢复可以修改
chattr -i file
```

touh创建文件或者修改时间戳
---

```txt
touch file

touch -a 修改atime 访问时间
touch -m 修改文件修改时间 mtime
```
