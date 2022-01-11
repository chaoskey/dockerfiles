FROM chaoskey/julialab:latest

# [1] 安装 Gridap@v0.15.5 + GridapGmsh + GridapODEs
#       【指定Gridap版本，是因为Gridap@v0.16目前有问题】
# [2] 常用第三方库
# [3] 给get_cell_shapefuns取一个别名get_fe_basis
# [4] 给get_trial_fe_basis取一个别名get_trial_fe_basis
# [5] 导出新的别名 【因为Gridap@v0.16改了名字，但Gridap@v0.16目前有问题，不建议安装
#                    教程中又改用了新的名字，为了和教程一致，
#                    我采用在Gridap@v0.15.5基础上修改源码的方案】
# [6] 重新预编译,并Build
RUN julia -e 'using Pkg; pkg"add Gridap@v0.15.5 GridapGmsh GridapODEs;"' \
    && julia -e 'using Pkg; pkg"add Plots LineSearches FillArrays ForwardDiff; gc --all;"' \
    && echo "const get_fe_basis = get_cell_shapefuns" >> /root/.julia/packages/Gridap/EZQEK/src/Exports.jl \
    && echo "const get_trial_fe_basis = get_cell_shapefuns_trial" >> /root/.julia/packages/Gridap/EZQEK/src/Exports.jl \    && echo "export get_fe_basis, get_trial_fe_basis" >> /root/.julia/packages/Gridap/EZQEK/src/Exports.jl \
    && julia -e 'using Pkg; pkg"precompile; build;"'

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
    && echo "cat /root/WELCOME" >> /root/.bashrc 

# 欢迎词
ADD WELCOME /root/WELCOME

WORKDIR /root/local

# 参数注释:
#  守护		 -d
#  容器命名		--name gridaplab
#  目录映射		-v /mnt/e/work/sci/gridap:/root/shared
#  工作目录		-w /root/local  【如果没有这个参数，则以此目录为默认工作目录】
#  端口映射		-p 9222:22 -p 9280:80 【sshd服务端口，JupyterLab端口】

# 将工作目录 和 目录映射 独立开来， 避免实时访问宿主机器导致性能下降
# 平时在 工作目录（local）工作，  必要时手工复制 local 到 shared（宿主机器目录）
# 不定时手工执行: cp -rf /root/local/* /root/shared/

#   创建服务容器: 没启动任何服务  【根据登录欢迎词选择启动服务】 
# docker run -td --name gridaplab -v /mnt/e/work/sci/gridap:/root/shared -p 9222:22 -p 9280:8888 chaoskey/gridaplab
#   创建服务容器: 默认启动SSH服务 【根据登录欢迎词选择启动其它服务】
# docker run -d --name gridaplab -v /mnt/e/work/sci/gridap:/root/shared -p 9222:22 -p 9280:8888 chaoskey/gridaplab /root/.run sshd -D

#   进入gridaplab服务容器的bash
#docker exec -ti gridaplab bash

#   直接进入bash【不创建容器】
# docker run -it --rm chaoskey/gridaplab bash

# Podman也可用
# 1）将`docker`换成`podman`； 
# 2）将`chaoskey/gridaplab` 换成 `docker.io/chaoskey/gridaplab`

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
#ssh root@localhost -p 9222

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host scimllab
#    HostName localhost
#    User root
#    Port 9222
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"



