2015年2月3日，作为软件定义数据中心基础、面向混合云的虚拟化解决方案VMware vSphere6.0发布

VMware vSphere6.0两个核心组件是ESXi和vCenter Server,ESXi是用于创建和运行虚拟机设备的虚拟化平台。vCenter Server是管理平台，充当连接到网络的ESXi主机的中心管理员，将多个ESXi主机加入池中并管理这些资源

相对5.5版本更高的可扩展性

|vSphere5.5|vSphere6.0|
|:---:|:---:|
|每个集群32台主机|每个集群64台主机|
|每个集群4000个虚拟机|每个集群6000个虚拟机|
|每台主机320个CPU|每台主机480个CPU|
|每台主机4TB RAM|每台主机12TB RAM|
|每台主机512个虚拟机|每台主机1024个虚拟机|
|每个虚拟机最多64个虚拟CPU|每个虚拟机最多128个虚拟CPU|
|每个虚拟机最大1TB虚拟RAM|每个虚拟机最大4TB虚拟RAM|

提高vMotion网络的灵活性 支持vMotion网络跨越L3界限，以及使用自己的TCP/IP堆栈，跨虚拟交换机vMotion,跨vCenter Server进行vMotion

集成VMware vSphere Data Protection : VMware vSphere Essentials Plus或更高版本集成了VMware vSphere Data Protection,使用Web Client可以进行部署和管理，每个VDP最多可以包含8TB经重复数据消除的备份数据

本书实验环境使，用Open-E系统构建了FC SAN存储及iSCSI存储，使用MDS 9124作为FC SAN存储交换机

```txt
[root@localhost:~] vmware -v
VMware ESXi 6.7.0 build-10302608
```

1. 升级方法1 使用光盘镜像，迁移ESXi5.5上面的虚拟机，服务器挂载光盘，重启执行安装升级操作
2. 使用vSphere Update Manager插件： 使用vSphere Client登录vCenter单击“插件”选项，在“插件管理器”窗口中可以看到vSphere Update Manager，单击“下载并安装”按钮；安装完成后进入vSphere Update Manager界面，单击“导入ESXi镜像”按钮；要升级的5.5版本主机进入维护模式

使用vSphere Update Manager升级风险比较小，需要vCenter是6.0版本，这样才能安装6.0版本的vSphere Update Manager，并接管升级成为6.0版本的ESXi服务器

升级失败不能回滚到5.5版本 
