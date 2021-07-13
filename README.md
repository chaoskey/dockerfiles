# 基于Docker的科学计算环境

## FEniCS

FEniCS: 是一种开源计算平台，用于求解偏微分方程 (PDE)。

 [FEniCS Project](https://fenicsproject.org/)

在Fenics官方镜像基础上添加了Soya3支持，并且修改一些Bug

关于“FEniCS的窗口转发&音频转发配置”参考最后的附录

## Gridap

Gridap: 用Julia编写的基于有限元法的偏微分方程求解工具。

[Gridap (github.com)](https://github.com/gridap)

## SciML

SciML: 科学计算与机器学习的开源软件.

 [SciML: Open Source Software for Scientific Machine Learning](https://sciml.ai/)

## 基础镜像依赖关系

1)  quay.io/fenicsproject/stable  => **chaoskey/fenicslab**

2)  debian:buster  => chaoskey/pythonlab  => chaoskey/julialab  => **chaoskey/gridaplab**

3)  debian:buster  => chaoskey/pythonlab  => chaoskey/julialab  => **chaoskey/scimllab**

## 容器管理

```shell
# 拉取镜像
docker pull chaoskey/fenicslab
docker pull chaoskey/gridaplab
docker pull chaoskey/scimllab

# 创建容器
#     fenicslab服务容器
docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 127.0.0.1:8888:8888 chaoskey/fenicslab 'jupyter-lab --ip=0.0.0.0'
#     gridaplab服务容器
docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 127.0.0.1:9999:9999 chaoskey/gridaplab jupyter-lab --allow-root --ip=0.0.0.0 --port 9999
#     scimllab服务容器
docker run -d --name scimllab -v /mnt/e/work:/root/work -w /root/work/sci/sciml -p 127.0.0.1:7777:7777 chaoskey/scimllab jupyter-lab --allow-root --ip=0.0.0.0 --port 7777

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
docker exec -ti -u fenics fenicslab bash


# 无容器运行
docker run -it --rm <镜像名:版本号>  <命令>

# 查看容器日志
docker logs <容器ID>
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
