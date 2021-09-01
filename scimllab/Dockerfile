FROM chaoskey/julialab:latest

# 安装DifferentialEquations
RUN julia -e 'using Pkg; pkg"add DifferentialEquations; precompile;"'

# 安装SSH服务端
RUN apt-get install -y openssh-server

# 启动脚本run.sh
RUN echo "#! /bin/bash" >> /root/run.sh \      
    && echo "# 启动SSH服务(端口22)" >> /root/run.sh \     
    && echo "sudo /etc/init.d/ssh start" >> /root/run.sh \
    && echo "# 启动JupyterLab服务(端口80)" >> /root/run.sh \
    && echo "jupyter-lab --allow-root --ip=0.0.0.0 --port 80" >> /root/run.sh \
    && chmod +x /root/run.sh






