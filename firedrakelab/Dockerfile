FROM firedrakeproject/firedrake

# 安装SSH服务端
RUN sudo apt-get update \
    && sudo apt-get install -y openssh-server

USER firedrake

# 安装jupyterlab支持
RUN bash -c ". /home/firedrake/firedrake/bin/activate && pip install jupyterlab"

ENV PATH=/home/firedrake/firedrake/bin:$PATH
ENV OMP_NUM_THREADS=1

# 启动脚本run.sh
RUN echo "#! /bin/bash" >> /home/firedrake/run.sh \      
    && echo "# 启动SSH服务(端口22)" >> /home/firedrake/run.sh \     
    && echo "sudo /etc/init.d/ssh start" >> /home/firedrake/run.sh \
    && echo "# 启动JupyterLab服务(端口80)" >> /home/firedrake/run.sh \
    && echo "jupyter-lab --ip=0.0.0.0 --port 80" >> /home/firedrake/run.sh \
    && sudo chmod +x /home/firedrake/run.sh

# 构建firedrakelab镜像
# docker build -t chaoskey/firedrakelab firedrakelab

# firedrakelab临时运行
# docker run -it --rm chaoskey/firedrakelab bash

# firedrakelab容器: JupyterLab服务(9080)+SSH服务(9022)
# docker run -d --name firedrakelab -v /mnt/e/work:/home/firedrake/work -w /home/firedrake/work/sci/firedrake -p 9022:22 -p 9080:80 chaoskey/firedrakelab /home/firedrake/run.sh
# docker exec -ti -u firedrake firedrakelab bash

#################################
# SSH服务端配置
#################################

#PC端生成公私钥
# ssh-keygen

# 把生成的公钥~\.ssh\id_rsa.pub 拷贝到docker容器的~/.ssh 文件夹中

#cd ~/.ssh
#cat id_rsa.pub > authorized_keys

# 修改为：PasswordAuthentication no
#sudo vim $PREFIX/etc/ssh/sshd_config

#exit

# 重启容器
#docker restart firedrakelab

#################################
# SSH客户端配置
#################################

# SSH客户端命令行登录
#ssh firedrake@127.0.0.1 -p 9022

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host firedrakelab
#    HostName 127.0.0.1
#    User firedrake
#    Port 9022
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"


