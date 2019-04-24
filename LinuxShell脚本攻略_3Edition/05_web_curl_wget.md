5.2.2 wget
---

```txt
下载多个url
wget url1 url2 ...

工作原理
下载的文件名默认和URL中文件名会保持一致，下载日志和进度被写入stdout
可以通过-O 指定输出文件名
也可以通过-o 指定一个日志文件，这样日志信息就不会打印到stdout了

尝试次数-t
$wget -t 5 URL    #-t可以指定在放弃下载前尝试的次数
$wgeet -t 0 URL   #将-t设置为0则会不断尝试下载

下载速度限制-Q
$wget --limit-rate 20k http://example.com/file.iso

选项--quota  或-Q可以指定最大下载配额，quota，一旦用完下载立即停止。
对于多个文件，系统存储空间有限的情况下，对下载总量限制还是有必须的，否则磁盘爆满

断点续传-c
如果下载过程中被中断，可以使用-c从断点处继续下载
$wget -c URL

复制整个网站--mirror
wget像爬虫一样递归的方式遍历整个网站上所有URL，并逐个下载，使用--mirror选项
$wget --mirror --convert-links example.com
或者
$wget -r -N -l -k DEPTH URL
-r递归(recursive,递归选项) -l是只页面层级(深度),-N表示使用文件时间戳，
-k或--convert-links指wget将页面的链接地址转换为本地地址

需要认证的http或ftp页面，--user --password
需要认证断点页面使用--user  和--password提供认证信息
$wget --user username --password pass URL
也可以手动输入密码--ask-password

以纯文本形式下载页面lynx
web页面包含大量标签，JavaScript和CSS标签，bash处理文本比较块，使用lynx可以以文本方式下载web页面
#yum install lynx
或
#apt-get install lynx

--dump能够以ASCII编码形式下载web页面
$lynx URL -dump >webpage_as_text_.txt
```

cURL入门
---

```txt
cURL可以使用HTTP，HTTPS，FTP协议在客户端和服务器之间传递数据，支持POST，cookie,认证，从指定偏移处
下载部分文件，参照也referer,用户代理字符串，拓展头部，限速，文件大小限制，进度条

cURL默认会将下载输出到stdout,进度输出到stderr，不想显示进度信息可以使用--silent
$curl URL
-O 将下载数据写入文件，采用从URL解析出来的文件名，URL必须是完整的，不能是域名
$curl www.example.com/index.htm --silent -O

-o可以指定输出文件名，如果使用-o选项就可以直接使用网站域名下载主页了
$curl www.example.com -o example.index.html

--silent 不显示进度条
--progress 显示#状进度条

-C 断点续传
--cookie COOKIE_IDENTIFER 指定提供那些cookie,cookie需要以name=value形式给出，多个cookie用；分隔
$curl http://example.com --cookie "user=USERNAME;pass=PASSWORD"
--cookie-jar将cookie另存为文件
$curl URL --cookie-jar cookie_file

--user-agent 或-A 设置用户代理
$curl URL user-agent "Mozilla/5.0"
--limit-rate限定下载带宽
$curl URL --limit-rate 20k

设置下载的最大文件--max-filesize
-u USERNAME
使用-u USERNAME:PASSWORD来指定用户名和密码

tr -d '\n' 移除换行符
sed 's:</entry>:\n:g' 将每一处</entry>替换成换行符
```
5.7图片抓取下载工具image crawler
---

