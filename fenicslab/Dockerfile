FROM quay.io/fenicsproject/stable:latest

##############################
#                    软件安装
##############################

RUN apt-get update

# http://www.lesfleursdunormal.fr/static/informatique/soya3d/index_en.html

# 【Soya3依赖】OpenGL (possibly Mesa)
RUN apt-get install -y build-essential libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev mesa-utils

# 【Soya3依赖】OpenAL (http://openal.org) for sound support
RUN apt-get install -y libopenal-dev

# 【Soya3依赖】GLEW (The OpenGL Extension Wrangler Library, http://glew.sf.net)
RUN apt-get install -y libglew-dev

# 【Soya3依赖】SDL 2.0 (http://libsdl.org)
RUN apt-get install -y libsdl2-dev libsdl2-image-dev  

# 【Soya3依赖】Cerealizer (http://www.lesfleursdunormal.fr/static/informatique/cerealizer/index_en.html)
RUN pip install Cerealizer

# 【Soya3依赖】Cal3D 0.10.0 (http://cal3d.sourceforge.net ; cal3d is sufficient, cal3d_viewer, data,... are not needed)
RUN apt-get install -y libcal3d12-dev

# 【Soya3依赖】libFreeType2 (http://www.freetype.org)
RUN apt-get install -y libfreetype6-dev \
    && mv -f /usr/include/freetype2/freetype/*  /usr/include/freetype2/ \
    && rm  -df  /usr/include/freetype2/freetype \
    && ln -s /usr/include/freetype2 /usr/include/freetype

# 【Soya3依赖】额外补充 
RUN apt-get install -y libvorbis-dev

# 安装Soya3
RUN pip install Soya3

# 窗口&音频转发
RUN apt-get install -y  x11-apps pulseaudio

# 安装SSH服务端
RUN sudo apt-get install -y openssh-server

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
ADD run.sh /home/fenics/run.sh
RUN chmod +x /home/fenics/run.sh

# 完善欢迎信息
RUN echo "" >> /home/fenics/WELCOME \      
    && echo "如果希望ssh登录，请上传密钥到~/.ssh 文件夹中，然后" >> /home/fenics/WELCOME \
    && echo "    cd ~/.ssh" >> /home/fenics/WELCOME \
    && echo "    cat id_rsa.pub > authorized_keys" >> /home/fenics/WELCOME \        
    && echo "" >> /home/fenics/WELCOME \     
    && echo "如果希望窗口&音频转发，执行" >> /home/fenics/WELCOME \
    && echo "    source /home/fenics/run.sh x11_audio" >> /home/fenics/WELCOME \
    && echo "    尝试执行: dolfin-plot BDM tetrahedron 3" >> /home/fenics/WELCOME \
    && echo "" >> /home/fenics/WELCOME \
    && echo "如果希望启动JupyterLab服务，执行" >> /home/fenics/WELCOME \
    && echo "    /home/fenics/run.sh jupyterlab" >> /home/fenics/WELCOME \
    && echo "" >> /home/fenics/WELCOME \
    && echo "如果希望启动SSH服务，执行" >> /home/fenics/WELCOME \
    && echo "    /home/fenics/run.sh sshd" >> /home/fenics/WELCOME \
    && echo "" >> /home/fenics/WELCOME

#   创建服务容器: FEniCS + SSH（端口22）+ JupyterLab（端口80） 【同时启动SSH+JupyterLab服务，根据需要启用 窗口&音频转发】
#docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 9122:22 -p 9180:80 -p 8100:8000 chaoskey/fenicslab /home/fenics/run.sh
#   创建服务容器: FEniCS + JupyterLab（端口80）  【只启动JupyterLab服务，根据需要启用 窗口&音频转发 或 SSH服务】
#docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 9122:22 -p 9180:80 -p 8100:8000 chaoskey/fenicslab "jupyter-lab --ip=0.0.0.0 --port 80"
#   创建服务容器: FEniCS + SSH（端口22）  【推荐，只启动SSH服务，根据需要用启用 窗口&音频转发 或 JupyterLab服务】
#docker run -d --name fenicslab -v /mnt/e/work:/home/fenics/work -w /home/fenics/work/sci/fenics -p 9122:22 -p 9180:80 -p 8100:8000 chaoskey/fenicslab "sudo /etc/init.d/ssh start -D"


#   进入fenicslab服务容器的bash
#docker exec -ti -u fenics fenicslab bash

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
#ssh fenics@127.0.0.1 -p 9122

# VSCode客户端配置(配置好后，VSCode选用即可)
# C:\Users\joistw\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
#Host fenicslab
#    HostName 127.0.0.1
#    User fenics
#    Port 9122
#    IdentityFile "C:\Users\joistw\.ssh\id_rsa"







