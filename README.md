# 基于Docker的科学计算环境

## FEniCSx

FEniCSx: 是下一代FEniCS的开源计算平台，用于求解偏微分方程 (PDE)。

 [The FEniCSx tutorial](https://jorgensd.github.io/dolfinx-tutorial/)  和  [FEniCS Project](https://fenicsproject.org/) 

在FEniCSx官方镜像（dolfinx/dolfinx）基础上添加了JupyterLab+PyVista+Xvfb+ipyvtklink+itkwidgets+SSH支持。

注意: 

- 由于官方镜像dolfinx/lab采用了JupyterLab3，但itkwidgets不支持JupyterLab3[2021-11-09确认]。所以从dolfinx/dolfinx + JupyterLab2 重新构建镜像。

- 新构建的镜像支持浏览器访问JupyterLab2,  但在VsCode中启动Jupyter服务运行会出错（目前未解决）。

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

1)  dolfinx/dolfinx  => **chaoskey/fenicsxlab**
2)  firedrakeproject/firedrake  => **chaoskey/firedrakelab**
3)  quay.io/fenicsproject/stable  => **chaoskey/fenicslab**
4)  debian:buster  => chaoskey/pythonlab  => chaoskey/julialab  => **chaoskey/gridaplab**
5)  debian:buster  => chaoskey/pythonlab  => chaoskey/julialab  => **chaoskey/scimllab**

## 容器管理

**设置Docker国内镜像**

```text
# sudo vim /etc/docker/daemon.json
{
 "registry-mirrors" : [
         "https://registry.docker-cn.com",
         "https://hub-mirror.c.163.com",
         "https://mirror.baidubce.com",
         "https://reg-mirror.qiniu.com",
         "https://dockerhub.azk8s.cn",
         "https://docker.mirrors.ustc.edu.cn",
         "https://mirror.ccs.tencentyun.com",
         "https://<您的ID>.mirror.swr.myhuaweicloud.com",
         "https://<您的ID>.mirror.aliyuncs.com",
         "http://<您的ID>.m.daocloud.io"
 ]
}
```

**容器管理**

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

# 参数注释:
#  守护		 -d 
#  容器命名		--name fenicslab
#  目录映射		-v /mnt/e/work/sci/fenics:/home/fenics/shared
#  工作目录		-w /home/fenics/local  【如果没有这个参数，则以此目录为默认工作目录】
#  端口映射		-p 9122:22 -p 9180:80 -p 8100:8000 【sshd服务端口，JupyterLab端口，绘图端口】

# 建议不定时手工执行: cp -rf /home/fenics/local/* /home/fenics/shared/

#   创建fenicsxlab容器: FEniCSx + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name fenicsxlab -v /mnt/e/work/sci/fenicsx:/root/shared -p 9422:22 -p 9480:80 -p 8400:8000 chaoskey/fenicsxlab /root/run.sh
#   创建fenicsxlab容器: FEniCSx + JupyterLab（端口80）
docker run -d --name fenicsxlab -v /mnt/e/work/sci/fenicsx:/root/shared -p 9422:22 -p 9480:80 -p 8400:8000 chaoskey/fenicsxlab /root/run.sh jupyterlab
#   创建fenicsxlab容器: FEniCSx + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name fenicsxlab -v /mnt/e/work/sci/fenicsx:/root/shared -p 9422:22 -p 9480:80 -p 8400:8000 chaoskey/fenicsxlab /root/run.sh sshd -D

#   创建firedrakelab容器: Firedrake + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name firedrakelab -v /mnt/e/work/sci/firedrake:/home/firedrake/shared -p 9022:22 -p 9080:80 -p 8000:8000 chaoskey/firedrakelab /home/firedrake/run.sh
#   创建firedrakelab容器: Firedrake + JupyterLab（端口80）
docker run -d --name firedrakelab -v /mnt/e/work/sci/firedrake:/home/firedrake/shared -p 9022:22 -p 9080:80 -p 8000:8000 chaoskey/firedrakelab /home/firedrake/run.sh jupyterlab
#   创建firedrakelab容器: Firedrake + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name firedrakelab -v /mnt/e/work/sci/firedrake:/home/firedrake/shared -p 9022:22 -p 9080:80 -p 8000:8000 chaoskey/firedrakelab /home/firedrake/run.sh sshd -D

#   创建fenicslab容器: FEniCS + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name fenicslab -v /mnt/e/work/sci/fenics:/home/fenics/shared -p 9122:22 -p 9180:80 -p 8100:8000 chaoskey/fenicslab /home/fenics/run.sh
#   创建fenicslab容器: FEniCS + JupyterLab（端口80）
docker run -d --name fenicslab -v /mnt/e/work/sci/fenics:/home/fenics/shared -p 9122:22 -p 9180:80 -p 8100:8000 chaoskey/fenicslab "jupyter-lab --ip=0.0.0.0 --port 80"
#   创建fenicslab容器: FEniCS + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name fenicslab -v /mnt/e/work/sci/fenics:/home/fenics/shared -p 9122:22 -p 9180:80 -p 8100:8000 chaoskey/fenicslab "sudo /etc/init.d/ssh start -D"

#   创建gridaplab容器: Gridap + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name gridaplab -v /mnt/e/work/sci/gridap:/root/shared -p 9222:22 -p 9280:80 chaoskey/gridaplab /root/run.sh
#   创建gridaplab容器: Gridap + JupyterLab（端口80）
docker run -d --name gridaplab -v /mnt/e/work/sci/gridap:/root/shared -p 9222:22 -p 9280:80 chaoskey/gridaplab /root/run.sh jupyterlab
#   创建gridaplab容器: Gridap + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name gridaplab -v /mnt/e/work/sci/gridap:/root/shared -p 9222:22 -p 9280:80 chaoskey/gridaplab /root/run.sh sshd -D

#   创建scimllab容器: SciML + SSH（端口22）+ JupyterLab（端口80） 
docker run -d --name scimllab -v /mnt/e/work/sci/sciml:/root/shared -p 9322:22 -p 9380:80 chaoskey/scimllab /root/run.sh
#   创建scimllab容器: SciML + JupyterLab（端口80）
docker run -d --name scimllab -v /mnt/e/work/sci/sciml:/root/shared -p 9322:22 -p 9380:80 chaoskey/scimllab /root/run.sh jupyterlab
#   创建scimllab容器: SciML + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
docker run -d --name scimllab -v /mnt/e/work/sci/sciml:/root/shared -p 9322:22 -p 9380:80 chaoskey/scimllab /root/run.sh sshd -D

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
ssh root@localhost -p 9422
ssh firedrake@localhost -p 9022
ssh fenics@localhost -p 9122
ssh root@localhost -p 9222
ssh root@localhost -p 9322

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
Host fenicslab
    HostName localhost
    User root
    Port 9422
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host firedrakelab
    HostName localhost
    User firedrake
    Port 9022
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host fenicslab
    HostName localhost
    User fenics
    Port 9122
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host gridaplab
    HostName localhost
    User root
    Port 9222
    IdentityFile "C:\Users\joistw\.ssh\id_rsa"
Host scimllab
    HostName localhost
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
