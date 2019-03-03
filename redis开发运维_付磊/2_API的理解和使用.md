redis提供了5种数据结构，理解每种数据结构的特点对于开发运维很重要，同时也要掌握redis单线程的处理机制，会使数据结构和命令的选择事半功倍。

redis全局命令、数据结构和内部编码、单线程命令处理机制

redis 5 种数据结构，它们是键值对中的值，对于键来说有一些通用的命令

1. 查看所有键 keys *
2. 键的总数 dbsize

dbsize命令返回当前数据库中键的总数,dbsize命令在计算键总数的时候不会遍历所有键，而是直接获取redis内置键总数变量，所以dbsize命令的时间复杂度是O(1),而keys命令会遍历所有键，它的时间复杂度是O(n),当redis保存了大量键时，线上环境禁止使用keys *

3. 检查键是否存在 exists key
4. 删除键
```txt
 del key [key ...]
```
返回结果是成功删除的个数，如果键不存在，则返回0

5. 键过期 expire key seconds

redis支持对键添加时间过期，当超过过期时间后删除键
```txt
127.0.0.1:6380> set expire_time test
OK
127.0.0.1:6380> expire expire_time 10
(integer) 1
127.0.0.1:6380> get expire_time
(nil)
```

可以使用ttl命令查询键剩余时间，它有3中返回值

- 大于等于0的整数：剩余过期时间
- -1:键没有设置过期时间
- -2:键不存在

```txt
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
```
6. 键的数据结构类型
```txt
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
```
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
```
setnx 和setxx在实际中应用场景：如果多个客户端同时执行setnx key value,根据setnx特性只有一个客户端能设置成功，setnx可以作为分布式锁的一种实现方案

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
===

1. 追加值 append key value

```txt
127.0.0.1:6380> get test
"001"
127.0.0.1:6380> append test append
(integer) 9
127.0.0.1:6380> get test
"001append"
```
2. 字符串长度 strlen key

```txt
127.0.0.1:6380> strlen test
(integer) 9

127.0.0.1:6380> set name 小明
OK
127.0.0.1:6380> get name
"\xe5\xb0\x8f\xe6\x98\x8e"
127.0.0.1:6380> set name1 "亮亮"
OK
127.0.0.1:6380> strlen name
(integer) 6
每个中文3个字节
查询结果中的中文会显示为16进制的字符串，使用命令 redis-cli --raw就能正常显示中文
127.0.0.1:6380> get name
"\xe5\xb0\x8f\xe6\x98\x8e"
$ sudo ./redis-cli -p 6380 get name
"\xe5\xb0\x8f\xe6\x98\x8e"
$ sudo ./redis-cli --raw -p 6380 get name
小明
```
3. 设置并返回原来的值 getset key value

```txt
127.0.0.1:6380> getset test world
"001append"
127.0.0.1:6380> get test
"world"
```
4. 设置指定位置的字符 setrange key offset value

```txt
127.0.0.1:6380> set redis best
OK
127.0.0.1:6380> setrange redis 0 B
(integer) 4
127.0.0.1:6380> get redis
"Best"
```
5. 获取部分字符串 getrange key start end

```txt
127.0.0.1:6380> getrange redis 0 2
"Bes"
```
字符串类型命令时间复杂度O
---

命令  时间复杂度
- set key value            O(1)
- get key                  O(1)
- del key [key ...]        O(k) k是键的个数
- mset key [key ...]       O(k) 
- mget key [key ...]       O(k)
- incr key                 O(1)
- getrange key start end   O(n) n是字符串长度

2.2.2 内部编码
---

字符串类型的内部编码有3种

```txt
int: 8个字节长度整型
127.0.0.1:6380> set key 211
OK
127.0.0.1:6380> object encoding key
"int"

embstr: 小于等于39个字节的字符串
127.0.0.1:6380> set char "hello world!"
OK
127.0.0.1:6380> object encoding char
"embstr"

raw: 大于39个字节的字符串
127.0.0.1:6380> set string "One String more than 39 will use RAW formart This is test of RAW format"
OK
127.0.0.1:6380> object encoding string
"raw"
```
2.2.3 典型使用场景
---

1. 缓存功能

```txt
                     hit                 miss
user <===> Web服务 <=======>Redis缓存层<============> 存储层(MySQL)
                    return             write cache
```

与MySQL不同的是，redis没有命名限制，也没有对键名有强制要求(除了不能使用的特殊字符)，合理设计键名有利于防止键冲突和项目的可维护性。

比较推荐的是使用"业务名:对象名:id:[属性]"作为键名(也可不使用分号)

如果没有从redis获取到用户信息，需要从MySQL中获取，并将结果写回到redis，添加1小时(3600秒)过期时间

2. 计数

页面访问量、点赞、踩、播放次数

```txt
long incrVideoCounter(long id){
    key = "video:playCount:"+id;
    return redis.incr(key);
}
```
3. 共享Session

一个分布式Web服务将用户Session信息(例如用户登录信息)保存在各自服务器中，会造成一个问题，出于负载均衡考虑，分布式服务会将用户访问均衡到不同服务器上，用户刷新一次访问可能发现需要重新登录，这是不行的，为了解决这个问题，redis将用户Session进行集中管理，这种模式下只要保证redis是高可用可拓展的，每次用户更新或者查询登录信息都直接从redis中集中获取。

4. 限速

很多应用出于安全考虑，每次登录时需要手机输入进行验证码，从而确定是本人，短信接口为了不被频繁访问，用户每分钟获取验证码的频率不能超过n次

```txt
phoneNum = "136xxxxxxxx";
key = "shortMsg:limit:"+phoneNum;
//SET key value EX 60 NX
isExists = redis.set(key,1,"EX 60","NX");
if (isExists != null || redis.incr(key) <=5){
    //通过
}else{
    //限速
}
```

2.3 哈希 hash
===

在redis中，hash类型是指键值本身又是一个键值对结构，形如value{{field1,value1},...{fieldN,valueN}},Redis键值对和hash类型二者关系如下

```txt
    key           value
user:1:name       Tom
user:1:age        28

               -----------------
               | name  | tom   |
               -----------------
user:1         | age   | 28    |    哈希
               -----------------
                field  value
```
哈希类型中的映射关系叫做field-value,注意这里的value是指field对应的值，不是键对应的值

2.3.1 命令
---

1. 设置值 hset key field value
2. 获取值 hget key field

```txt
127.0.0.1:6380> hset user:1 name Tom
(integer) 1
127.0.0.1:6380> hget user:1 name
"Tom"
```
如果键或field不存在则抛出nil

```txt
127.0.0.1:6380> hget user:2 name
(nil)
```
3. 删除field  hdel key field [field ...]

hdel会删除一个或多个field 返回结果是成功删除field的个数
```txt
127.0.0.1:6380> hdel user:1 name
(integer) 1
127.0.0.1:6380> hdel user:1 age
(integer) 0
127.0.0.1:6380> hget user:1
(error) ERR wrong number of arguments for 'hget' command
```
4. 计算field个数 hlen key

```txt
127.0.0.1:6380> hset user:1 name Tom
(integer) 1
127.0.0.1:6380> hset user:1 age 29
(integer) 1
127.0.0.1:6380> hset user:1 city shenzhen
(integer) 1
127.0.0.1:6380> hlen user:1
(integer) 3
```

5. 批量设置或获取 field-value

```txt
hmget key field [field ...]
hmget key field value [field value ...]
```
hmset 和hmget分别批量设置和过期field-value,hmset需要的参数是key和多对field-value,hmget需要的参数是key和多个field

```txt
127.0.0.1:6380> hmset user:2 name Bill age 55 city Seattle
OK
127.0.0.1:6380> hmget user:2 name age city
1) "Bill"
2) "55"
3) "Seattle"
```
6. 判断是否存在hexists key
```txt
127.0.0.1:6380> hexists user:1 name
(integer) 1
```
7. 获取所有field  HKEYS KEY
```txt
127.0.0.1:6380> hkeys user:1
1) "name"
2) "age"
3) "city"
```
hkeys命令叫hfields更恰当，它返回的是指定hash键所有的field

8. 获取所有value   HVALS key
```txt
127.0.0.1:6380> hvals user:1
1) "Tom"
2) "29"
3) "shenzhen"
```
9. 获取所有的field-value  hgetall key
```txt
127.0.0.1:6380> hgetall user:1
1) "name"
2) "Tom"
3) "age"
4) "29"
5) "city"
6) "shenzhen"
```
10. hincrby hincrbyfloat
```txt
hincrby key field
hincrbyfloat key field

hincrby 类似于incrby,hincrbyfloat 类似于incrbyfloat,只不过作用域是field
```
11. 计算value的字符串长度(redis 3.2版本以上)
```txt
hstrlen key field

127.0.0.1:6380> hstrlen user:1 city
(integer) 8
127.0.0.1:6380> hget user:1 city
"shenzhen"
```

2.3.2 hash类型的内部编码，两种ziplist(压缩列表) hashtable(哈希表)
---

ziplist(压缩列表):当hash类型元素个数小于hash-max-ziplist-entries配置(默认512个)、同时所有值都小于hash-max-ziplist-value配置(默认64字节)时，redis会使用ziplist作为hash内部实现，ziplist使用更加紧凑的结构实现多个元素的连续存储，在节省内存方面比hashtable优秀。

hashtable(哈希表)：当hash类型无法满足ziplist的条件时，redis会使用hashtable作为内部实现，因为此时ziplist读写性能会下降，hashtable的读写时间复杂度为O(1)

```txt
127.0.0.1:6380> hmset hashkey f1 001 f2 002 
OK
127.0.0.1:6380> object encoding hashkey
"ziplist"
127.0.0.1:6380> hset hash f3 "Hashkey String lenth is more than 64 bits ,Then use hashtable format"
(integer) 1
127.0.0.1:6380> object encoding hash
"hashtable"
```
当field个数超过512，内部编码也会变成hashtable

2.3.3 hash使用场景
---

对于多个属性的元素，使用hash类型相对于字符串序列化缓存用户信息更加直观，而且在操作上会更加便捷，可以将每个用户ID定义为键后缀，多对field-value对应每个用户多个属性

hash类型和关系型数据库不同之处
- hash类型是稀疏的，而关系型数据库是结构化的，例如hash类型每个键可以有不同field,而关系型数据库一旦新增列，所有行都要为其设值(即使NULL)

- 关系数据库可以做复杂关系查询，而redis去模拟关系数据库复杂查询开发困难，维护成本高

合适场景选用合适数据库

缓存用户信息

1) 原生字符串类型：每个属性一个键

```txt
set user:1:name tom
set user:1:age 22
set user:1:city beijing
```
- 优点：简单直观，每个属性都支持更新操作
- 缺点：占用过多键，内存占有量大，同时用户信息内聚性比较差，一般不在生成环境使用

2） 序列化字符串类型：将用户信息序列化后用一个键保存
```txt
set user:1 serialize(userInfo)
```
- 优点：简化编程
- 缺点：序列化和反序列化有一定的开销，每次更新都要把全部数据取出进行反序列化-序列化到redis中

3）哈希类型：每个用户属性使用一对field-value,只用一个键保存

```txt
hmset user:1 name tom age 22 city beijing
```
- 优点：简单直观，如果使用合理可以减少内存使用
- 缺点：要控制hash在ziplist和hashtable这两种内部编码的转换，hashtable会消耗更多内存

2.4 列表list
===

列表list类型是用来存储多个有序的字符串，列表的每个字符串称为元素element,一个列表最多可以存储2^32 -1个元素，redis中可以对列表两端插入(push)和弹出(pop)，还可以获取指定范围内的元素列表，获取指定索引下标的元素等，列表是一种比较灵活的数据结构，可以充当栈和队列的角色。

1. 列表中的元素是有序的
2. 列表中元素是可以重复的

2.4.1 list相关命令
---

- 操作类型    操作
- 添加       rpush lpush linsert
- 查         lrange lindex len
- 删除       lpop rpop lrem ltrim
- 修改       lset
- 阻塞操作    blpop brpop

```txt
右插入list
127.0.0.1:6380> rpush right_listkey d c b a
(integer) 4
127.0.0.1:6380> lrange right_listkey 0 -1
1) "d"
2) "c"
3) "b"
4) "a"

左插入list
127.0.0.1:6380> lpush left_listkey d c b a
(integer) 4
127.0.0.1:6380> lrange left_listkey 0 -1
1) "a"
2) "b"
3) "c"
4) "d"
```
向某个元素前或后插入元素

```txt
linsert key before|after pivot value

127.0.0.1:6380> linsert right_listkey before b java
(integer) 5
127.0.0.1:6380> lrange right_listkey 0 -1
1) "d"
2) "c"
3) "java"
4) "b"
5) "a"
```

查找一定范围内元素 lrange key start end
- start end 代表索引号，0是第一个元素，-1是最后一个元素

查找单个元素 lindex key index

```txt
lindex key index
127.0.0.1:6380> lindex right_listkey 3
"b"
索引是从0 开始的，3就是从左到右第4个元素
```
获取列表长度 llen key

```txt
llen key

127.0.0.1:6380> llen right_listkey
(integer) 5
```
删除pop

```txt
从列表左侧弹出元素lpop key

127.0.0.1:6380> lpop right_listkey
"d"
127.0.0.1:6380> lrange right_listkey 0 -1
1) "c"
2) "java"
3) "b"
4) "a"

右侧弹出rpop key
127.0.0.1:6380> rpop right_listkey
"a"
127.0.0.1:6380> lrange right_listkey 0 -1
1) "c"
2) "java"
3) "b"
```
删除指定元素 lrem key count value

lrem命令会从列表中找到等于value的元素进行删除

- count>0 从左到右，删除最多count个元素
- count<0 从右到左，删除最多count绝对值个元素
- count=0 删除所有
```txt
127.0.0.1:6380> lrange right_listkey 0 -1
 1) "a"
 2) "a"
 3) "a"
 4) "a"
 5) "a"
 6) "5"
 7) "4"
 8) "3"
 9) "2"
10) "1"
11) "c"
12) "java"
13) "b"
127.0.0.1:6380> lrem right_listkey 4 a
(integer) 4
127.0.0.1:6380> lrange right_listkey 0 -1
1) "a"
2) "5"
3) "4"
4) "3"
5) "2"
6) "1"
7) "c"
8) "java"
9) "b"
```

按照索引范围修剪列表 ltrim key start end

```txt
127.0.0.1:6380> ltrim right_listkey 1 3
OK
127.0.0.1:6380> lrange right_listkey 0 -1
1) "5"
2) "4"
3) "3"
```
ltrim修剪后保留这部分，其余的丢弃

修改lset key index newValue

```txt
127.0.0.1:6380> lset right_listkey 1 python
OK
127.0.0.1:6380> lrange right_listkey 0 -1
1) "5"
2) "python"
3) "3"
```

阻塞操作blpop brpop
- blpop key [key ...] timeout
- brpop key [key ...] timeout

blpop和brpop是lpop和rpop的阻塞版本，它们除了弹出方式不同，使用方法相同

brpop命令包括两个参数
- key[key ...]: 多个列表的键
- timeout: 阻塞时间(单位:秒)

