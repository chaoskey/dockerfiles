FROM dolfinx/lab:latest

RUN apt-get update

# 安装SSH服务端
RUN apt-get install -y openssh-server

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
#ssh fenics@127.0.0.1 -p 9422

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host fenicsxlab
#    HostName 127.0.0.1
#    User fenics
#    Port 9422
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"







