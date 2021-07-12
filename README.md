# 基于Docker的科学计算环境

## FEniCS

FEniCS: 是一种流行的开源计算平台，用于求解偏微分方程 (PDE)。 在Fenics官方镜像基础上添加了Soya3支持，并且修改一些Bug

## Gridap

Gridap: 用Julia编写的基于有限元法的偏微分方程求解工具。【对标用Python+C++编写的FEniCS】

## SciML

SciML: 科学计算与机器学习的开源软件套装: https://sciml.ai/。 Julia版本 【完善中...】

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

# 容器 停止/启动/执行命令
docker stop <容器ID>
docker start <容器ID>
docker exec -ti <容器ID> <命令>

# 无容器运行
docker run -it --rm <镜像名:版本号>  <命令>

# 查看容器日志
docker logs <容器ID>
```



