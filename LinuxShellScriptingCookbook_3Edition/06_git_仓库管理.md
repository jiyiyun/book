1、安装git
---

```txt
$sudo yum install git-all
$sudo apt-get install git-all
```

创建新的git仓库
```txt
mkdir MyProject
cd Pyoroject

git仓库初始化
git init

git clone 远程仓库地址
git clone http://github.com/ProjectName

使用git添加提交变更
git add file
git add 命令可以将工作代码working code中的变更添加到暂存区
git commit命令会打开shell环境变量EDITOR定义好的编辑器
git commit FILE_NAME -m
-a  在提交前加入新的代码
-m  指定一条信息，不进入编辑器

git checkout 创建分支(修改bug或者测试用)
git branch 查看分支
git merge 合并分支
git status 检查git仓库状态




```