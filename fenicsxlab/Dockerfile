FROM dolfinx/dolfinx:latest

##############################
#                    安装区域
#
#    由于itkwidgets和vscode都不适用于JupyterLab3
#    所以，从dolfinx/dolfinx开始安装JupyterLab2
##############################

WORKDIR /tmp/

# 安装SSH服务端
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 安装JupyterLab2
RUN pip3 install --no-cache-dir jupyterlab==2.3.2

# 支持为JupyterLab安装DOLFINx复数模式的内核
ADD complex-kernel.json /usr/local/share/jupyter/kernels/python3-complex/kernel.json

# v0.1

# 安装 PyVista依赖
# 安装 PyVista(3D可视化)  
# 安装 ipyvtklink（vtk的Jupyter小部件，vtkRenderWindow这个渲染窗口可以和VTK Python、 ParaView或PyVista 配合使用）
RUN apt-get -qq update \
    && apt-get remove -y python3-pil \
    && apt-get -y install --no-install-recommends  libgl1-mesa-dev xvfb \
    && apt-get autoremove -y \
    && pip3 install --no-cache-dir pyvista ipyvtklink  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# v0.2

# JupyterLab2的插件安装需要Node.js的支持
RUN apt-get -qq update \
    && wget -qO - https://deb.nodesource.com/setup_16.x | bash \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# v0.3

# 安装 itkwidgets （交互式Jupyter小部件，可2D和3D可视化图像、点集和网格）
# 支持 JupyterLab2
# 不支持 JupyterLab3  vscode的jupyter插件
RUN pip3 install --no-cache-dir itkwidgets \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager ipycanvas ipyevents jupyter-matplotlib jupyterlab-datawidgets itkwidgets \
    && rm -rf /usr/local/share/.cache/*

# v0.4

# 安装进度条
RUN apt-get -qq update \
    && apt-get remove -y python3-pygments \
    && apt-get autoremove -y \
    && pip3 install --no-cache-dir tqdm pygments \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# v0.5

# 安装 h5py支持
ENV HDF5_MPI="ON" \
    HDF5_DIR="/usr/lib/x86_64-linux-gnu/hdf5/mpich/"
RUN CC=mpicc pip3 install --no-cache-dir --no-binary=h5py h5py

# v0.6

# 其它常用软件
RUN pip3 install --no-cache-dir pandas seaborn

# v0.7

##############################
#                    配置区域
##############################

# SSH无密码登录(创建容器后，必须上传您的密钥)
RUN chmod +w /etc/ssh/sshd_config \
    && sed -i "s@PasswordAuthentication yes@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sed -i "s@#PasswordAuthentication no@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && chmod -w /etc/ssh/sshd_config

# 启动脚本run.sh
ADD .run /root/.run
RUN chmod +x /root/.run
# 重复执行包含指定[关键词]的最近一条命令
ADD .bh /root/.bh
RUN chmod +x /root/.bh

# 环境变量固化（确保ssh登录应该生效的环境变量）
# 添加欢迎词
RUN echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH" >> /etc/profile \      
    && echo "export OPENBLAS_NUM_THREADS=$OPENBLAS_NUM_THREADS" >> /etc/profile \      
    && echo "export PATH=$PATH" >> /etc/profile \      
    && echo "export PYTHONPATH=$PYTHONPATH" >> /etc/profile \      
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/profile  \      
    && echo "export HDF5_MPI=$HDF5_MPI" >> /etc/profile  \      
    && echo "export HDF5_DIR=$HDF5_DIR" >> /etc/profile  \
    && echo "alias bh='source /root/.bh'" >> /root/.bashrc \
    && echo "alias run='source /root/.run'" >> /root/.bashrc \
    && echo "cat /root/WELCOME" >> /root/.bashrc

# v0.8

# 欢迎词
ADD WELCOME /root/WELCOME

WORKDIR /root/local

# 删除父镜像的ENTRYPOINT
# 在创建容器时，通过参数启动需要的程序
ENTRYPOINT []

# 参数注释:
#  守护		 -d
#  容器命名		--name fenicsxlab
#  目录映射		-v /mnt/e/work/sci/fenicsx:/root/shared
#  工作目录		-w /root/local 【如果没有这个参数，则以此目录为默认工作目录】
#  端口映射		-p 9422:22 -p 9480:80 -p 8400:8000    【sshd服务端口，JupyterLab端口，绘图端口】

# 将工作目录 和 目录映射 独立开来， 避免实时访问宿主机器导致性能下降
# 平时在 工作目录（local）工作，  必要时手工复制 local 到 shared（宿主机器目录）
# 不定时手工执行: cp -rf /root/local/* /root/shared/

#   创建服务容器: 没启动任何服务  【根据登录欢迎词选择启动服务】 
# docker run -d --name fenicsxlab -v /mnt/e/work/sci/fenicsx:/root/shared -p 9422:22 -p 9480:80 -p 8400:8000 chaoskey/fenicsxlab
#   创建服务容器: 默认启动SSH服务 【根据登录欢迎词选择启动其它服务】
# docker run -d --name fenicsxlab -v /mnt/e/work/sci/fenicsx:/root/shared -p 9422:22 -p 9480:80 -p 8400:8000 chaoskey/fenicsxlab /root/.run sshd -D

#   进入fenicslab服务容器的bash
# docker exec -ti fenicsxlab bash

#   直接进入bash【不创建容器】
# docker run -it --rm chaoskey/fenicsxlab bash

# Podman也可用
# 1）将`docker`换成`podman`； 
# 2）将`chaoskey/fenicsxlab` 换成 `docker.io/chaoskey/fenicsxlab`

#################################
# SSH服务端配置(上传密钥)
#################################

#PC端生成公私钥（如果已有，可忽略此步）
# ssh-keygen

# 把生成的公钥~\.ssh\id_rsa.pub 拷贝到docker容器的~/.ssh 文件夹中

#cd ~/.ssh
#cat id_rsa.pub > authorized_keys

#################################
# SSH客户端配置
#################################

# SSH客户端命令行登录
#ssh root@localhost -p 9422

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host fenicsxlab
#    HostName localhost
#    User root
#    Port 9422
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"







