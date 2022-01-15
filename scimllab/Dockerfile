FROM chaoskey/julialab:latest

# 安装DifferentialEquations
RUN julia -e 'using Pkg; pkg"add DifferentialEquations; precompile;"'

# 安装SSH服务端
RUN apt-get update \
    && apt-get install -y openssh-server

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
RUN echo "export JULIA_PATH=$JULIA_PATH" >> /etc/profile \   
    && echo "export PATH=$PATH" >> /etc/profile  \
    && echo "alias bh='source /root/.bh'" >> /root/.bashrc \
    && echo "alias run='source /root/.run'" >> /root/.bashrc \
    && echo "cat /root/WELCOME" >> /root/.bashrc \
    && echo "cd /root/local" >> /root/.bashrc

# 欢迎词
ADD WELCOME /root/WELCOME

WORKDIR /root/local

# 参数注释:
#  守护		 -d
#  容器命名		--name scimllab
#  目录映射		-v /mnt/e/work/sci/sciml:/root/shared
#  工作目录		-w /root/local  【如果没有这个参数，则以此目录为默认工作目录】
#  端口映射		-p 9322:22 -p 9380:80 【sshd服务端口，JupyterLab端口】

# 将工作目录 和 目录映射 独立开来， 避免实时访问宿主机器导致性能下降
# 平时在 工作目录（local）工作，  必要时手工复制 local 到 shared（宿主机器目录）
# 不定时手工执行: cp -rf /root/local/* /root/shared/

#   创建服务容器: 没启动任何服务  【根据登录欢迎词选择启动服务】 
# docker run -td --name scimllab -v /mnt/e/work/sci/sciml:/root/shared -p 9322:22 -p 9380:8888 chaoskey/scimllab
#   创建服务容器: 默认启动SSH服务 【根据登录欢迎词选择启动其它服务】
# docker run -d --name scimllab -v /mnt/e/work/sci/sciml:/root/shared -p 9322:22 -p 9380:8888 chaoskey/scimllab /root/.run sshd -D

#   进入scimllab服务容器的bash
# docker exec -ti scimllab bash

#   直接进入bash【不创建容器】
# docker run -it --rm chaoskey/scimllab bash

# Podman也可用
# 1）将`docker`换成`podman`； 
# 2）将`chaoskey/scimllab` 换成 `docker.io/chaoskey/scimllab`

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
#ssh root@localhost -p 9322

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host scimllab
#    HostName localhost
#    User root
#    Port 9322
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"






