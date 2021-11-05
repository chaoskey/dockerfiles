#  注意: 官方镜像dolfinx/lab版本太老有问题，只能从dolfinx/dolfinx开始   20211104注
FROM dolfinx/dolfinx:latest

# 安装jupyterlab支持
RUN pip install jupyterlab

# 安装SSH服务端
RUN apt-get update \
    && apt-get install -y openssh-server

# SSH无密码登录(创建容器后，必须上传您的密钥)
RUN chmod +w /etc/ssh/sshd_config \
    && sed -i "s@PasswordAuthentication yes@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sed -i "s@#PasswordAuthentication no@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && chmod -w /etc/ssh/sshd_config

# 安装PyVista支持
RUN pip install pyvista 

# 安装Xvfb支持
RUN apt-get install -y libgl1-mesa-glx xvfb

# 安装 ipyvtklink itkwidgets 支持
# 注意: 这部分增加近3G，并且还无法进一步精简
RUN apt-get purge nodejs npm \
    && apt-get install -y nodejs npm \
    && pip install ipyvtklink itkwidgets \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-matplotlib jupyterlab-datawidgets itkwidgets \
    && apt-get remove -y nodejs npm \
    && apt-get -y clean \
    && apt-get -y autoclean \
    && apt-get -y autoremove

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
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/profile

# 删除父镜像的ENTRYPOINT
# 在创建容器时，用参数确定要执行的命令和相应的端口映射
ENTRYPOINT []

#   创建服务容器: FEniCSx + SSH（端口22）+ JupyterLab（端口80） 
#docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9422:22 -p 9480:80 chaoskey/fenicsxlab /root/run.sh
#   创建服务容器: FEniCSx + JupyterLab（端口80）
#docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9480:80 chaoskey/fenicsxlab jupyter-lab --allow-root --ip=0.0.0.0 --port 80
#   创建服务容器: FEniCSx + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
#docker run -d --name fenicsxlab -v /mnt/e/work:/root/work -w /root/work/sci/fenicsx -p 9422:22 chaoskey/fenicsxlab /etc/init.d/ssh start -D

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







