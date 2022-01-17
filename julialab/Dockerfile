FROM chaoskey/pythonlab:latest
MAINTAINER joistwang <joistwang@sina.com>

# 安装Julia
# https://mirrors.ustc.edu.cn/julia-releases/bin/linux/x64/1.6/julia-1.6.5-linux-x86_64.tar.gz
RUN apt-get install -y wget \
    && mkdir /usr/local/julia \
    && wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.5-linux-x86_64.tar.gz \   
    && tar -xzf julia-1.6.5-linux-x86_64.tar.gz -C /usr/local/julia --strip-components 1 \
    && rm julia-1.6.5-linux-x86_64.tar.gz

# 环境变量设置: Julia
ENV JULIA_PATH=/usr/local/julia
ENV PATH=/usr/local/julia/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 为Jupyter添加Julia内核
RUN julia -e 'ENV["JUPYTER"] = "/usr/local/bin/jupyter"; using Pkg; Pkg.update(); Pkg.add("IJulia");'

