FROM quay.io/fenicsproject/stable:latest

##############################
#                    软件安装
##############################

RUN sudo apt-get update

# http://www.lesfleursdunormal.fr/static/informatique/soya3d/index_en.html

# 【Soya3依赖】OpenGL (possibly Mesa) 2022-1-15 剔除freeglut3-dev build-essential
# 【Soya3依赖】OpenAL (http://openal.org) for sound support
# 【Soya3依赖】GLEW (The OpenGL Extension Wrangler Library, http://glew.sf.net)
# 【Soya3依赖】SDL 2.0 (http://libsdl.org) 
# 【Soya3依赖】Cal3D 0.10.0 (http://cal3d.sourceforge.net ; cal3d is sufficient, cal3d_viewer, data,... are not needed)
# 【Soya3依赖】libFreeType2 (http://www.freetype.org)
RUN sudo apt-get install -y --no-install-recommends libgl1-mesa-dev libglu1-mesa-dev mesa-utils libopenal-dev \
    libglew-dev libsdl2-dev libsdl2-image-dev libcal3d12-dev libfreetype6-dev libvorbis-dev \
    && sudo mv -f /usr/include/freetype2/freetype/*  /usr/include/freetype2/ \
    && sudo rm  -df  /usr/include/freetype2/freetype \
    && sudo ln -s /usr/include/freetype2 /usr/include/freetype \
    && sudo apt-get clean -y \
    && sudo apt-get autoclean -y \
    && sudo apt-get autoremove -y \
    && sudo rm -rf /tmp/* /var/tmp/*

# 【Soya3依赖】Cerealizer (http://www.lesfleursdunormal.fr/static/informatique/cerealizer/index_en.html)
# 安装Soya3
RUN sudo pip install --no-cache-dir Cerealizer Soya3

# 窗口&音频转发 + SSH服务端
RUN sudo apt-get install -y --no-install-recommends x11-apps pulseaudio openssh-server \
    && sudo apt-get clean -y \
    && sudo apt-get autoclean -y \
    && sudo apt-get autoremove -y \
    && sudo rm -rf /tmp/* /var/tmp/*

##############################
#                    源码修改
##############################

# 修改dolfin-plot源码
# 修改ffc/plot.py源码
RUN cp /usr/local/bin/dolfin-plot  /usr/local/bin/dolfin-plot_bak \
    && chmod +w /usr/local/bin/dolfin-plot \
    && sed -i "s@env\s\+python@env python3@g" /usr/local/bin/dolfin-plot \
    && sed -i '/print "/ { :begin; /print\s\+"\+[^"]\+"\+\s*\(\%\s*.\+\)\?\s*$/! { $! { N; b begin }; }; }; s/print\s\+\("\+[^"]\+"\+\s*\(\%\s*.\+\)\?\)\s*$/print(\1)/g' /usr/local/bin/dolfin-plot \
    && chmod -w /usr/local/bin/dolfin-plot \
    && cp /usr/local/lib/python3.6/dist-packages/ffc/plot.py /usr/local/lib/python3.6/dist-packages/ffc/plot.py_bak \
    && chmod +w /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && sed -i "s@import soya@import soya3 as soya@g" /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && sed -i "s@from soya@from soya3@g" /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && sed -i "/# Handle exit/ { :begin; /# Handle exit.*idler.idle()/! { $! { N; b begin }; }; }; s/# Handle exit.*idler.idle()/try:\n        soya.MainLoop(scene).main_loop()\n    except:\n        pass\n/g" /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && chmod -w /usr/local/lib/python3.6/dist-packages/ffc/plot.py

# 修改源码plotting.py
# NotImplementedError: It is not currently possible to manually set the aspect on 3D axes
RUN sed -i "s@ax.set_aspect('equal')@    ax.set_aspect('equal')@g" /usr/local/lib/python3.6/dist-packages/dolfin/common/plotting.py

##############################
#                    配置区域
##############################

# SSH无密码登录(创建容器后，必须上传您的密钥)
RUN sudo chmod +w /etc/ssh/sshd_config \
    && sudo sed -i "s@PasswordAuthentication yes@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sudo sed -i "s@#PasswordAuthentication no@PasswordAuthentication no@g" /etc/ssh/sshd_config \
    && sudo chmod -w /etc/ssh/sshd_config

# 启动脚本run.sh
ADD .run /home/fenics/.run
RUN chmod +x /home/fenics/.run
# 重复执行包含指定[关键词]的最近一条命令
ADD .bh /home/fenics/.bh
RUN chmod +x /home/fenics/.bh

# 欢迎词
ADD WELCOME /home/fenics/WELCOME

# 命令别名 & 登录目录
RUN echo "alias bh='source /home/fenics/.bh'" >> /home/fenics/.bashrc \
    && echo "alias run='source /home/fenics/.run'" >> /home/fenics/.bashrc \
    && echo "cd /home/fenics/local" >> /home/fenics/.bashrc \
    && echo "su fenics" >> /root/.bashrc

WORKDIR /home/fenics/local

# 参数注释:
#  守护		 -d
#  容器命名		--name fenicslab
#  目录映射		-v /mnt/e/work/sci/fenics:/home/fenics/shared
#  工作目录		-w /home/fenics/local  【如果没有这个参数，则以此目录为默认工作目录】
#  端口映射		-p 9122:22 -p 9180:80 -p 8100:8000 【sshd服务端口，JupyterLab端口，绘图端口】

# 将工作目录 和 目录映射 独立开来， 避免实时访问宿主机器导致性能下降
# 平时在 工作目录（local）工作，  必要时手工复制 local 到 shared（宿主机器目录）
# 不定时手工执行: cp -rf /home/fenics/local/* /home/fenics/shared/

#   创建服务容器: 没启动任何服务  【根据登录欢迎词选择启动服务】
# docker run -td --name fenicslab -v /mnt/e/work/sci/fenics:/home/fenics/shared -p 9122:22 -p 9180:8888 -p 8100:8000 chaoskey/fenicslab
#   创建服务容器: 默认启动SSH服务 【根据登录欢迎词选择启动其它服务】
# docker run -d --name fenicslab -v /mnt/e/work/sci/fenics:/home/fenics/shared -p 9122:22 -p 9180:8888 -p 8100:8000 chaoskey/fenicslab "/home/fenics/.run sshd -D"

#   进入fenicslab服务容器的bash
# docker exec -ti fenicslab bash

#   直接进入bash【不创建容器】
# docker run -it --rm chaoskey/fenicslab bash

# Podman也可用
# 1）将`docker`换成`podman`； 
# 2）将`chaoskey/fenicslab` 换成 `docker.io/chaoskey/fenicslab` 
# 3) 由于run x11_audio必须在ROOT权限下运行，所以必须用sudo podman执行相关命令 

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
#ssh fenics@localhost -p 9122

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host fenicslab
#    HostName localhost
#    User fenics
#    Port 9122
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"

