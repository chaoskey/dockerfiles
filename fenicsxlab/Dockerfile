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
RUN pip3 install --no-cache-dir tqdm pygments --upgrade

# v0.5

# 安装 h5py + meshio
ENV HDF5_MPI="ON" \
    HDF5_DIR="/usr/lib/x86_64-linux-gnu/hdf5/mpich/"
RUN CC=mpicc pip3 install --no-cache-dir --no-binary=h5py h5py meshio

# v0.6

##############################
#                    配置区域
##############################

# SSH无密码登录(创建容器后，必须上传您的密钥)
RUN chmod +w /etc/ssh/sshd_config \
    && sed -i "s@PasswordAuthentication yes@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sed -i "s@#PasswordAuthentication no@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && chmod -w /etc/ssh/sshd_config

# 启动脚本run.sh
RUN echo "#! /bin/bash" >> /root/run.sh \      
    && echo "# 启动SSH服务(端口22)" >> /root/run.sh \     
    && echo "/etc/init.d/ssh start" >> /root/run.sh \
    && echo "# 启动JupyterLab服务(端口80)" >> /root/run.sh \
    && echo "jupyter-lab --allow-root --ip=0.0.0.0 --port 80" >> /root/run.sh \
    && chmod +x /root/run.sh

# 环境变量固化（确保ssh登录应该生效的环境变量）
RUN echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH" >> /etc/profile \      
    && echo "export OPENBLAS_NUM_THREADS=$OPENBLAS_NUM_THREADS" >> /etc/profile \      
    && echo "export PATH=$PATH" >> /etc/profile \      
    && echo "export PYTHONPATH=$PYTHONPATH" >> /etc/profile \      
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/profile  \      
    && echo "export HDF5_MPI=$HDF5_MPI" >> /etc/profile  \      
    && echo "export HDF5_DIR=$HDF5_DIR" >> /etc/profile

# 删除父镜像的ENTRYPOINT
# 在创建容器时，通过参数启动需要的程序
ENTRYPOINT []

#   创建服务容器: FEniCSx + SSH（端口22）+ JupyterLab（端口80） 
#docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9422:22 -p 9480:80 chaoskey/fenicsxlab /root/run.sh
#   创建服务容器: FEniCSx + JupyterLab（端口80）
#docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9480:80 chaoskey/fenicsxlab jupyter-lab --allow-root --ip=0.0.0.0 --port 80
#   创建服务容器: FEniCSx + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
#docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9422:22 -p 9480:80 chaoskey/fenicsxlab /etc/init.d/ssh start -D

#   进入fenicslab服务容器的bash
#docker exec -ti fenicsxlab bash

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
#ssh root@127.0.0.1 -p 9422

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host fenicsxlab
#    HostName 127.0.0.1
#    User root
#    Port 9422
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"







