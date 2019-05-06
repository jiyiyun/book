配置标准交换机　配置分布式交换机

4.1.2　ESXi主机网络组件介绍
1. Standard Switch 标准交换机，简称vSS　是由ESXi主机虚拟出来的交换机，在安装完成ESXi后，系统会创建一个标准交换机vSwitch0，这个虚拟交换机的主要功能是提供管理、虚拟机与外界通信等功能，在生产环境，一般根据需要，创建多个标准交换机对各种流量进行分离，提供冗余及负载均衡。例如创建vSwitch1用于iSCSI，vSwitch2用于vMotion
2. Distributed Switch 分布式交换机，简称vDS ,vDS是横跨多台ESXi主机的虚拟交换机，简化了管理人员的配置。如果使用vSS需要在每台ESXi主机进行网络配置，如果ESXi主机数量非常多，使用vDS是更好的选择，分布式交换机上创建了多个端口组并划分了VLAN，可以根据实际情况在分布式交换机创建多个端口组用于各种用途。
3. vSwitch Port　虚拟交换机端口，ESXi上创建的vSwitch属于二层交换机，默认端口是120个，6.0版本最大4088个
4. Port Group 端口组　在一个vSwitch中可以创建一个或者多个Port Group，且针对不同的Port Group进行VLAN,以及流量控制等方面的配置。然后将虚拟机划入不同的Port Group,这样可以提供不同优先级的网络使用率
5. Virtual Machine Port Group　虚拟机端口组　在ESXi系统安装完成系统自动创建的vSwitch0上默认创建一个虚拟机端口组，用于虚拟机外部通信使用，在生产环境中一般会将管理网络与虚拟机端口组进行分离
6. VMkernel Port　在ESXi主机网络中是一个特殊的端口，运行特殊流量的端口比如管理流量,iSCSI流量,NFS流量，vMotion流量，与端口组不同的是，VMkernel Port必须配置IP地址

