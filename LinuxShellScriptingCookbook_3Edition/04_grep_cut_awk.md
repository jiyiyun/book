正则表达式
---

```txt
位置标记锚点position marker anchor
正则表达式   描述
^          指定匹配正则表达式的文本必须起始字符串的首部
$          匹配字符串的尾部

标识符
正则表达式  描述
A描述      匹配该字符
*         匹配任意一个字符
[]        匹配括号中任意一个字符
[^]       非中括号中的字符

数量修饰符
正则表达式   描述
？          匹配之前的项1次或0次
+           多于1次
*           0次或多次
{n}         匹配之前项n次
(n,)        匹配至少n次
(n,m)       最小n次最大m次

mount -o loop  指明要挂载的是环回文件，而不是设备
挂载光盘
#mount -o loop linux.iso /mnt/iso

用dd命令创建iso镜像
dd if=/dev/cdrom of=image.iso




```