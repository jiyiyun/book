vCenter Server是vSphere 虚拟化架构中核心管理工具。充当ESXi主机和虚拟机中心管理点的服务。

什么是SSO ：vCenter Single Sign On单点登录,在过去版本里，当用户尝试登录到基于AD授信的vCenter Server上时，用户输入用户名、密码之后，将直接去Active Directory进行校验，这样做的好处是优化了访问速度，缺点是vCenter之类的应用直接可以读取到AD信息，可能导致潜在的AD安全leak;另外vSphere构建下的周边组件越来越多，每个设备都需要和AD通信，带来的管理工作也较大，这个背景下SSO出现，要求所有基于vCenter或与vCenter有关联的组件在访问Domain前，先访问SSO，这样解决逻辑安全性之余，也降低了用户零星访问的零散性，加强了访问的几种转发，变相保障了AD的安全性

3.1.3 什么是PSC (Platform Services Controller) 平台服务控制器。使用一个或多个嵌入式控制器或单独安装的控制器来连接到vCenter Server，PSC将会提供SSO能够实现的全部功能，还能提供授权服务、证书存储服务、以及未来将会加入的其它服务。

vSphere中包含了PSC，它替换了vSphere 5.x版本中SSO功能，并拥有很多新的重要服务

3.2 vCenter版本以及运行环境选择

3.2.1 vCenter版本选择，vSphere6.0推出了两个版本，一个是windows版vCenter Server(VC);另一种是Linux版本的vCenter Server(VCSA)；两种版本都支持SQL server及Oracle作为外部数据库

vCenter Server6.0版本嵌入式数据库不再使用SQL Server Express，而是使用开源的vPostgres作为嵌入式数据库；基于Linux版本的vCenter仅支持Oracle作为外部数据库，嵌入式数据库使用的的是开源的vPostgres

嵌入式数据库和独立数据库对比
---

嵌入式数据库优点无需费用，部署简单安装vCenter时可以同时完成，缺点支持不超过5台及50台虚拟机，数据库备份恢复比较麻烦。基于Linux版本的vCenter使用vPostgres数据库可以支持到500台主机5000台虚拟机。

独立数据库 优点是具有完整数据库功能。支持5台以上ESXi或50台以上虚拟机，备份和恢复数据库方便。缺点是要单独购买数据库授权。以及后续安装配置

安装SQL Server 2012并配置数据库

使用“Microsoft SQL Server Management Studio”登录SQL Server 2012数据库，输入服务器名称“VC6-DB”单击连接按钮登录，在“数据库”单击右键，选择创建数据库


使用Oracle作为VCSA6.0数据库 Linux版本的vCenter只支持Oracle作为外部独立数据库，6.0版本对Oracle12g支持不是很好，实际还是使用稳定版本Oracle 11g作为VCSA 6.0数据库

选择数据库版本“标准版”，Oracle数据库安装完成后，使用“Database Configuration Assistant”创建VCSA6.0所需数据库

VCSA6.0所需数据库创建完成后还不能使用，需要配置网络监听程序会客户端才能连接
1. 进入“Net Configuration Assistant”创建向导，选择“监听程序配置”单选项
2. 选择“添加”监听程序
3. 配置监听程序名，默认为“LISTENER”
4. 选择监听程序使用的协议，默认为TCP
5. 配置监听程序端口号，默认使用“1521”
6. 是否配置另外一个监听程序，选择“否”

3.6 安装配置VC 6.0
---

3.6.1 配置ODBC数据源

由于windows server 2012虚拟机连接SQL Server 2012数据库需要客户端连接工具，而 windows Server 2012系统自带的连接工具不支持连接到SQL Server 2012,因此在配置ODBC数据源之前，需安装客户端连接工具，该工具在SQL Server2012安装光盘目录\2052_CHS_LP\x64\Setup\x64下，文件名“sqlncli.exe”

1. 在"Windows Server 2012虚拟机" “控制面板”-->"管理工具"找到“数据源(ODBC)”
2. 选择“SQL Server Native Client 11.0”
3. 输入数据源名称、描述及连接的服务器
4. 选择“使用用户输入登录ID和密码的SQL Server验证”
5. 勾选“更改默认数据为(D)”复选框，选择刚创建的数据库"VC6-DB"
6. ODBC的其它参数使用默认值即可
7. 单击“测试数据源(T)”按钮，测试能否连接到数据库

3.7 安装VCSA

自我总结：原理就是利用脚本文件，配置好相关参数，将ova格式模版文件导入到系统中，很多系统的部署目前都采用这种方法，简单快捷而且不易出错

安装步骤
1. 在windows 系统中解压VMware-VCSA-all-6.5.0-8307201.iso 文件
2. 进入vcsa-ui-installer文件夹，再进入win32子文件夹，双击“installer.exe” 文件
3. 设置好ESXi主机IP ，用户名和密码
4. 设置网络参数，注意这里一定要设置好系统名称和FQDN地址，设置好所有参数，以后安装好了就很难修改了
5. 最后点击Finish，安装软件将自动导入VMware-vCenter-Server-Appliance-6.5.0.20000-8307201_OVF10.ova文件
6. 安装完毕，再登录系统


3.8.2 升级VCSA5.5到VCSA6.0

升级过程中会创建一台虚拟机运行VCSA6.0，同时会将VCSA5.5的配置文件同步到VCSA6.0;升级需要使用一个临时网络以便数据迁移，临时网络的地址配置不能和源设备地址相同；升级完成后VCSA6.0依然使用原来的地址，只是虚拟机名称发生了变化

3.9.2 添加活动目录主机到vCenter Server

生产环境一般使用多个账户对vCenter进行管理，vCenter支持活动目录用户管理
1. 浏览器登录Web Client,选择“系统管理”-->“Single Sign On”-->"配置"-->单击+按钮 


