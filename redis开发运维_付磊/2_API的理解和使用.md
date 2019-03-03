redis提供了5种数据结构，理解每种数据结构的特点对于开发运维很重要，同时也要掌握redis单线程的处理机制，会使数据结构和命令的选择事半功倍。

redis全局命令、数据结构和内部编码、单线程命令处理机制

redis 5 种数据结构，它们是键值对中的值，对于键来说有一些通用的命令

1. 查看所有键
  keys *

2. 键的总数
  dbsize
  dbsize命令返回当前数据库中键的总数
  dbsize命令在计算键总数的时候不会遍历所有键，而是直接获取redis内置键总数变量，所以dbsize命令的时间复杂度是O(1),而keys命令会遍历所有键，它的时间复杂度是O(n),当redis保存了大量键时，线上环境禁止使用keys *

3. 检查键是否存在
 exists key

4. 删除键
 del key [key ...]
返回结果是成功删除的个数，如果键不存在，则返回0

5. 键过期
 expire key seconds
redis支持对键添加时间过期，当超过过期时间后删除键
127.0.0.1:6380> set expire_time test
OK
127.0.0.1:6380> expire expire_time 10
(integer) 1
127.0.0.1:6380> get expire_time
(nil)
可以使用ttl命令查询键剩余时间，它有3中返回值
- 大于等于0的整数：剩余过期时间
- -1:键没有设置过期时间
- -2:键不存在
127.0.0.1:6380> set expire time
OK
127.0.0.1:6380> expire expire 20
(integer) 1
127.0.0.1:6380> ttl expire
(integer) 15
127.0.0.1:6380> ttl expire
(integer) 6
127.0.0.1:6380> ttl expire
(integer) -2                 #键已经过期删除
127.0.0.1:6380> get expire
(nil)                        #键已经不存在

6. 键的数据结构类型
 type key
127.0.0.1:6380> rpush mylist a b c d e f g
(integer) 7
127.0.0.1:6380> type mylist
list
127.0.0.1:6380> lrange mylist 0 -1
1) "a"
2) "b"
3) "c"
4) "d"
5) "e"
6) "f"
7) "g"
获取list片段LRANGE key start stop ,0表示第一个索引，-1表示最后一个索引

2.1.2 数据结构和内部编码
---

type命令返回的就是当前键的数据类型，它们分别是string(字符串)、 hash(哈希)、 list(列表)、 set(集合)、 zset(有序集合)。这些只是redis对外的数据结构。

每种数据结构都有自己的底层内部编码实现，而且是多种实现，这样redis在合适场景选择合适内部编码

每种数据结构都有两种以上的内部编码实现，例如list数据结构包含了linkedlist和ziplist两种内部编码，同时有些内部编码，例如zip可以作为多种外部数据结构的内部实现，通过object encoding命令查看内部编码
```txt
127.0.0.1:6380> object encoding hello
"embstr"
127.0.0.1:6380> object encoding mylist
"quicklist"
```

2.1.3 单线程架构
---

redis使用单线程架构和I/O多路复用模型来实现高性能的内存数据库服务。
1. 单线程模型
因为redis是单线程来处理命令的，所以一条命令从客户端到达服务端不会被立即执行，所有命令都会进入一个队列中，然后逐个执行。多个客户端命令顺序不确定，但可以确定的是不会有两条命令被同时执行。redis 使用了I/O复用技术来解决I/O问题。
2. 为什么单线程还这么快？
- 纯内存访问，redis把所有数据都放在内存中，内存的响应时长大概为100ns,这是redis每秒万级别访问的重要基础。
- 非阻塞I/O,redis使用epoll作为I/O多路复用技术，再加上redis自身的事件处理模型将epoll中的连接、读写、关闭都转换为事件，不在网络I/O上浪费过多时间。
- 单线程避免了线程切换和竟态产生的消耗。
单线程有几个好处
1. 单线程可以简化数据结构和算法的实现
2. 单线程避免了线程切换和竟态产生的消耗
但是单线程会有一个问题，对于每个命令执行时间是有要求的。如果某个命令执行时间过长，会造成其它命令的阻塞。对于redis这种高性能服务是致命的，所以redis是面向快速执行场景的数据库。

2.2 字符串string
---

字符串类型是redis最基础的数据结构。首先键key都是字符串类型，其它几种数据结构都是在字符串类型基础上构建的，字符串类型的值可以是字符串(简单字符串、复杂字符串(例如JSON、XML))、数字(整数,浮点数)、二进制(图片,音频，视频)，但值最大不能超过512MB

2.2.1 命令
1. 常用命令
- 设置值set key

```txt
set key value [ex seconds] [px milliseconds] [nx|xx]

127.0.0.1:6380> set redis good
OK
```
set命令有几个选项：
ex seconds:为键设置秒级过期时间
px milliseconds 为键设置毫秒级过期时间
nx 键必须不存在，才可以设置成功，用于添加
xx 与nx相反，键必须存在，才可以设置成功，用于更新

除set外，redis还提供setex 和setnx两个命令
```txt
setex key seconds value
setnx key value

它们的作用和ex ,nx选项是一样的，以下例子说明set setnx setxx区别
127.0.0.1:6380> exists test
(integer) 0                 #不存在
127.0.0.1:6380> set test set
OK                          #设置test 值为set
127.0.0.1:6380> get test
"set"
127.0.0.1:6380> setnx test 001
(integer) 0                 #setnx 设置失败
127.0.0.1:6380> get test
"set"
127.0.0.1:6380> set test 001 xx
OK                          #set xx 设置成功
127.0.0.1:6380> get test
"001"
setnx 和setxx在实际中应用场景：如果多个客户端同时执行setnx key value,根据setnx特性只有一个客户端能设置成功，setnx可以作为分布式锁的一种实现方案
```
2. 获取值get key
```txt
127.0.0.1:6380> get hello
"world"
127.0.0.1:6380> get abc
(nil)                   #键不存在，返回nil(空)
```

3. 批量设置mset
```txt
127.0.0.1:6380> mset a 1 b 2 c 3 d 4
OK
```
4. 批量获取mget
```txt
127.0.0.1:6380> mget a b c d
1) "1"
2) "2"
3) "3"
4) "4"
mget批量获取时,不存在的键,值为nil(空)
127.0.0.1:6380> mget a b c d e
1) "1"
2) "2"
3) "3"
4) "4"
5) (nil)
如果没有批量获取mget，那么n个键要用n次get命令，具体耗时
n次get时间 = n次网络时间+n次命令时间
mget
n次get时间 = 1次网络时间+n次命令时间
```
5. 计数incr key
incr命令用于对值进行自增操作，返回结果分为3种情况
值不是整数，返回错误
```txt
127.0.0.1:6380> get hello
"world"
127.0.0.1:6380> incr hello
(error) ERR value is not an integer or out of range
```
值是整数，返回自增结果
键不存在，按照值为0自增，返回结果1
```txt
127.0.0.1:6380> exists key
(integer) 0
127.0.0.1:6380> incr key
(integer) 1
127.0.0.1:6380> incr key
(integer) 2
127.0.0.1:6380> get key
"2"
```
除了incr命令，redis还提供了decr(自减),incrby(步进，自增指定数字)、decrby(步减，自减指定数字)，incrbyfloat(自增浮点数)

2.不常用命令
---
1. 追加值append key value
```txt
127.0.0.1:6380> get test
"001"
127.0.0.1:6380> append test append
(integer) 9
127.0.0.1:6380> get test
"001append"
```
2. 字符串长度strlen key
```txt
127.0.0.1:6380> strlen test
(integer) 9
```
