3.5.3使用进程文件系统管理进程
---

```txt
proc是虚拟文件系统，通过文件系统的接口实现，用于输出系统的运行状态，它以文件系统的方式，为操作系统和应用程序
之间提供了一个界面，使程序能够方便安全的获得系统当前运行状况和内核的内部数据信息，并可以修改某些系统配置信息
另外，proc以文件系统的接口实现，用户可以像访问普通文件一样进行访问，但它只存在于内存中。


文件/目录         说明
/proc/1         关于进程1的信息目录，每个进程在/proc下有一个名为其进程号的目录 ls /proc
/proc/cpuinfo   CPU相关信息
/proc/devices   当前运行的核心配置的设备驱动的列表
/proc/filesystems  核心配置文件系统
/proc/ioports   当前使用的I/O端口
/proc/kcore     系统物理内存映像
/proc/ksyms     核心符号列表
/proc/loadavg   系统平均负载
/proc/meminfo   内存使用信息，包括物理内存和swap
/proc/modules   当前加载了那些模块
/proc/net       网络协议状态信息
/proc/stat      系统不同状态
/proc/version   核心版本
/proc/uptime    系统启动运行时间
/proc/cmdline   命令行参数

```