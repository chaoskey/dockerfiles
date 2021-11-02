# 基于Docker的科学计算环境

## FEniCSx

FEniCSx: 是下一代FEniCS的开源计算平台，用于求解偏微分方程 (PDE)。

 [The FEniCSx tutorial](https://jorgensd.github.io/dolfinx-tutorial/)  和  [FEniCS Project](https://fenicsproject.org/) 

在FEniCSx官方镜像基础上添加了SSH支持。

## Firedrake

Firedrake: 是一种类似FEniCS的开源计算平台，用于求解偏微分方程 (PDE)。

 [Firedrake Project](https://www.firedrakeproject.org/)

在Firedrake官方镜像基础上添加了JupyterLab+SSH支持。

## FEniCS

FEniCS: 是一种开源计算平台，用于求解偏微分方程 (PDE)。

 [FEniCS Project](https://fenicsproject.org/)

在Fenics官方镜像基础上添加了Soya3+SSH支持，并且修改一些Bug

关于“FEniCS的窗口转发&音频转发配置”参考最后的**附录**

## Gridap

Gridap: 用Julia编写的基于有限元法的偏微分方程求解工具。

[Gridap (github.com)](https://github.com/gridap)

## SciML

SciML: 科学计算与机器学习的开源软件.

 [SciML: Open Source Software for Scientific Machine Learning](https://sciml.ai/)

## 基础镜像依赖关系

1)  firedrakeproject/firedrake  => **chaoskey/firedrakelab**

2)  quay.io/fenicsproject/stable  => **chaoskey/fenicslab**

3)  debian:buster  => chaoskey/pythonlab  => chaoskey/julialab  => **chaoskey/gridaplab**

4)  debian:buster  => chaoskey/pythonlab  => chaoskey/julialab  => **chaoskey/scimllab**

## 容器管理

```shell
# 拉取镜像
docker pull chaoskey/fenicsxlab
docker pull chaoskey/firedrakelab
docker pull chaoskey/fenicslab
docker pull chaoskey/gridaplab
docker pull chaoskey/scimllab

########################
# 创建容器
########################

#   创建fenicsxlab容器: FEniCSx + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9422:22 -p 9480:80 chaoskey/fenicsxlab /root/run.sh
#   创建fenicsxlab容器: FEniCSx + JupyterLab（端口80）
docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9480:80 chaoskey/fenicsxlab jupyter-lab --allow-root --ip=0.0.0.0 --port 80
#   创建fenicsxlab容器: FEniCSx + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9422:22 chaoskey/fenicsxlab /etc/init.d/ssh start -D

#   创建firedrakelab容器: Firedrake + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name firedrakelab -v /mnt/e/work:/home/firedrake/work -w /home/firedrake/work/sci/firedrake -p 9022:22 -p 9080:80 chaoskey/firedrakelab /home/firedrake/run.sh
#   创建firedrakelab容器: Firedrake + JupyterLab（端口80）
docker run -d --name firedrakelab -v /mnt/e/work:/home/firedrake/work -w /home/firedrake/work/sci/firedrake -p 9080:80 chaoskey/firedrakelab jupyter-lab --ip=0.0.0.0 --port 80
#   创建firedrakelab容器: Firedrake + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name firedrakelab -v /mnt/e/work:/home/firedrake/work -w /home/firedrake/work/sci/firedrake -p 9022:22 chaoskey/firedrakelab sudo /etc/init.d/ssh start -D

#   创建fenicslab容器: FEniCS + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 9122:22 -p 9180:80 chaoskey/fenicslab /home/fenics/run.sh
#   创建fenicslab容器: FEniCS + JupyterLab（端口80）
docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 9180:80 chaoskey/fenicslab jupyter-lab --ip=0.0.0.0 --port 80
#   创建fenicslab容器: FEniCS + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 9122:22 chaoskey/fenicslab "sudo /etc/init.d/ssh start -D"

#   创建gridaplab容器: Gridap + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 9222:22 -p 9280:80 chaoskey/gridaplab /root/run.sh
#   创建gridaplab容器: Gridap + JupyterLab（端口80）
docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 9280:80 chaoskey/gridaplab jupyter-lab --allow-root --ip=0.0.0.0 --port 80
#   创建gridaplab容器: Gridap + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 9222:22 chaoskey/gridaplab /etc/init.d/ssh start -D

#   创建scimllab容器: SciML + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name scimllab -v /mnt/e/work:/root/work -w /root/work/sci/sciml -p 9322:22 -p 9380:80 chaoskey/scimllab /root/run.sh
#   创建scimllab容器: SciML + JupyterLab（端口80）
docker run -d --name scimllab -v /mnt/e/work:/root/work -w /root/work/sci/sciml -p 9380:80 chaoskey/scimllab jupyter-lab --allow-root --ip=0.0.0.0 --port 80
#   创建scimllab容器: SciML + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name scimllab -v /mnt/e/work:/root/work -w /root/work/sci/sciml -p 9322:22 chaoskey/scimllab /etc/init.d/ssh start -D

# 参数注释:
#  守护		 -d 
#  容器命名		--name <容器名> 
#  目录映射		-v /mnt/e/work:/root/work
#  工作目录		-w /root/work/sci/gridap
#  端口映射		-p 127.0.0.1:9999:9999

# 容器 停止/启动/执行命令
docker stop <容器ID>
docker start <容器ID>
docker exec -ti <容器ID> <命令>
docker exec -ti fenicsxlab bash
docker exec -ti -u firedrake firedrakelab bash
docker exec -ti -u fenics fenicslab bash
docker exec -ti gridaplab bash
docker exec -ti scimllab bash

# 无容器运行
docker run -it --rm <镜像名:版本号>  <命令>

# 查看容器日志
docker logs <容器ID>
```

##  SSH客户端和VSCode远程配置

```shell
#################################
# SSH服务端配置(上传密钥)
#################################

#PC端生成公私钥（如果已有，可忽略此步）
ssh-keygen

# 把生成的公钥~\.ssh\id_rsa.pub 拷贝到docker容器的~/.ssh 文件夹中

cd ~/.ssh
cat id_rsa.pub > authorized_keys

#################################
# SSH客户端配置
#################################

# SSH客户端命令行登录
ssh root@127.0.0.1 -p 9422
ssh firedrake@127.0.0.1 -p 9022
ssh fenics@127.0.0.1 -p 9122
ssh root@127.0.0.1 -p 9222
ssh root@127.0.0.1 -p 9322

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
Host fenicslab
    HostName 127.0.0.1
    User root
    Port 9422
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host firedrakelab
    HostName 127.0.0.1
    User firedrake
    Port 9022
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host fenicslab
    HostName 127.0.0.1
    User fenics
    Port 9122
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host gridaplab
    HostName 127.0.0.1
    User root
    Port 9222
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host scimllab
    HostName 127.0.0.1
    User root
    Port 9322
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
```

## 附录: FEniCS的窗口转发&音频转发配置

#### 1） 转发窗口服务端

安装：xming https://sourceforge.net/projects/xming/files/latest/download

每次启动都要配置，建议通过“XLaunch”快捷方式启动
启动“XLaunch”后的第三步务必勾选：no Access Control

#### 2）音频转发配置

安装:  PulseAudio https://www.freedesktop.org/wiki/Software/PulseAudio/

配置１：若不想录制与发送麦克风的录音，关闭此选项。【每次麦克风录制完，服务会失效，得重启。】
```
pulseaudio\etc\pulse\default.pa　（Line 42）
FROM    load-module module-waveout sink_name=output source_name=input
TO  load-module module-waveout sink_name=output source_name=input record=0
```

配置２：配置监听IP
```
pulseaudio\etc\pulse\default.pa　（Line 61）
FROM    #load-module module-native-protocol-tcp
TO  load-module module-native-protocol-tcp listen=0.0.0.0 auth-anonymous=1
```

配置３：设置服务端不退出【默认机制是客户端断开20秒后此服务端就退出】
```
pulseaudio\etc\pulse\daemon.conf （Line 39）
FROM    ; exit-idle-time = 20
TO  exit-idle-time = -1
```

启动服务：pulseaudio.exe --daemonize

杀死服务：tskill pulseaudio

前面两个服务启动后，可以执行试试：
```
dolfin-plot BDM tetrahedron 3
```
