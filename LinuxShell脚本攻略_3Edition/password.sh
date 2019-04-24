#!/bin/bash

#file name password.sh

echo -e "Enter password:>>"
#在读取密码前禁止回显
stty -echo
read password

#允许回显
stty echo
echo
echo Password
read Password
echo -e "password = $password\nPassword = $Password"

echo -e "stty 命令的选项-echo禁止将输出发送到终端，echo则默认允许输出到终端"
echo "echo -e "启用反斜杠转义解释""
echo "echo默认把\n不解释直接输出为\n而不是换行，加-e就会对反斜杠解释"
