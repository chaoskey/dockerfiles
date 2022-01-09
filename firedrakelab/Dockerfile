FROM firedrakeproject/firedrake

# 安装SSH服务端
RUN sudo apt-get update \
    && sudo apt-get install -y openssh-server

# SSH无密码登录(创建容器后，必须上传您的密钥)
RUN sudo chmod +w /etc/ssh/sshd_config \
    && sudo sed -i "s@PasswordAuthentication yes@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sudo sed -i "s@#PasswordAuthentication no@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sudo chmod -w /etc/ssh/sshd_config

USER firedrake

# 安装jupyterlab支持
RUN bash -c ". /home/firedrake/firedrake/bin/activate && pip install jupyterlab"

ENV PATH=/home/firedrake/firedrake/bin:$PATH
ENV OMP_NUM_THREADS=1

# 环境变量固化（确保ssh登录应该生效的环境变量）
RUN echo "export OMP_NUM_THREADS=$OMP_NUM_THREADS" >> /home/firedrake/.profile \      
    && echo "export PATH=$PATH" >> /home/firedrake/.profile  \
    && echo "cat /home/firedrake/WELCOME" >> /home/firedrake/.bashrc

# v0.3

# 添加欢迎词
ADD WELCOME /home/firedrake/WELCOME

# 启动脚本run.sh
ADD run.sh /home/firedrake/run.sh
RUN sudo chmod +x /home/firedrake/run.sh

WORKDIR /home/firedrake/local

# 构建firedrakelab镜像
# docker build -t chaoskey/firedrakelab firedrakelab

# firedrakelab临时运行
# docker run -it --rm chaoskey/firedrakelab bash

# 参数注释:
#  守护		 -d
#  容器命名		--name firedrakelab
#  目录映射		-v /mnt/e/work/sci/firedrake:/home/firedrake/shared
#  工作目录		-w /home/firedrake/local 【如果没有这个参数，则以此目录为默认工作目录】
#  端口映射		-p 9022:22 -p 9080:80 -p 8000:8000 【sshd服务端口，JupyterLab端口，绘图端口】

# 将工作目录 和 目录映射 独立开来， 避免实时访问宿主机器导致性能下降
# 平时在 工作目录（local）工作，  必要时手工复制 local 到 shared（宿主机器目录）
# 不定时手工执行: cp -rf /home/firedrake/local/* /home/firedrake/shared/

#   创建服务容器: Firedrake + SSH（端口22）+ JupyterLab（端口80） 【同时启动SSH+JupyterLab服务】
#docker run -d --name firedrakelab -v /mnt/e/work/sci/firedrake:/home/firedrake/shared -p 9022:22 -p 9080:80 -p 8000:8000 chaoskey/firedrakelab /home/firedrake/run.sh
#   创建服务容器: Firedrake + JupyterLab（端口80） 【只启动JupyterLab服务，根据需要启动SSH服务】
#docker run -d --name firedrakelab -v /mnt/e/work/sci/firedrake:/home/firedrake/shared -p 9022:22 -p 9080:80 -p 8000:8000 chaoskey/firedrakelab /home/firedrake/run.sh jupyterlab
#   创建服务容器: Firedrake + SSH（端口22）  【推荐，只启动SSH服务，根据需要启动JupyterLab服务】
#docker run -d --name firedrakelab -v /mnt/e/work/sci/firedrake:/home/firedrake/shared -p 9022:22 -p 9080:80 -p 8000:8000 chaoskey/firedrakelab /home/firedrake/run.sh sshd -D

# 进入firedrakelab服务容器的bash
#docker exec -ti -u firedrake firedrakelab bash

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
#ssh firedrake@localhost -p 9022

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host firedrakelab
#    HostName localhost
#    User firedrake
#    Port 9022
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"


