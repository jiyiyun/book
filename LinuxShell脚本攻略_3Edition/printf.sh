#!/bin/bash

#filename printf.sh

printf "%-5s %-10s %-4s\n" No   Name   Mark
printf "%-5s %-10s %-4.2f\n" 1  Sarath   80.123456
printf "%-5s %-10s %-4.3f\n" 2  James    90.987654
printf "%-5s %-10s %-4.5f\n" 3  Jeff     88.543210
printf "%-5s %-10s %-4.9f\n" 4  Robin    50.67890

echo "1、- 负号代表左对齐，默认是右对齐"
echo "2、5 5个字符宽度的字符串，不够留空"
echo "3、s和f 代表字符串string,和浮点数float"
echo "4、\n 代表换行"
