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
RUN echo "#! /bin/bash" >> /root/run.sh \      
    && echo "# 启动SSH服务(端口22)" >> /root/run.sh \     
    && echo "/etc/init.d/ssh start" >> /root/run.sh \
    && echo "# 启动JupyterLab服务(端口80)" >> /root/run.sh \
    && echo "jupyter-lab --allow-root --ip=0.0.0.0 --port 80" >> /root/run.sh \
    && chmod +x /root/run.sh

# 环境变量固化（确保ssh登录应该生效的环境变量）
RUN echo "export JULIA_PATH=$JULIA_PATH" >> /etc/profile \      
    && echo "export PATH=$PATH" >> /etc/profile 

#   创建服务容器: Gridap + SSH（端口22）+ JupyterLab（端口80） 
#docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 9222:22 -p 9280:80 chaoskey/gridaplab /root/run.sh
#   创建服务容器: Gridap + JupyterLab（端口80）
#docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 9280:80 chaoskey/gridaplab jupyter-lab --allow-root --ip=0.0.0.0 --port 80
#   创建服务容器: Gridap + SSH（端口22）  【推荐，JupyterLab可在VSCode中根据需要启动】
#docker run -d --name gridaplab -v /mnt/e/work:/root/work -w /root/work/sci/gridap -p 9222:22 chaoskey/gridaplab /etc/init.d/ssh start -D

#   进入gridaplab服务容器的bash
#docker exec -ti gridaplab bash

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
#ssh root@127.0.0.1 -p 9222

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host scimllab
#    HostName 127.0.0.1
#    User root
#    Port 9222
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"



