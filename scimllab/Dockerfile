FROM chaoskey/julialab:latest

# 安装DifferentialEquations

RUN julia -e 'using Pkg; Pkg.add(["DifferentialEquations","Plots", "BenchmarkTools", \
    "DiffEqBayes", "SparsityDetection", "ModelingToolkit", "SparseDiffTools", \
    "DiffEqDevTools", "OrdinaryDiffEq", "ForwardDiff", "Flux"]); \
    Pkg.precompile(); Pkg.build(); Pkg.gc(); '

RUN julia -e 'using Pkg; Pkg.add(["DiffEqPhysics","Catalyst", "DiffEqCallbacks", \
    "ParameterizedFunctions", "Turing", "Distributions", "DiffEqUncertainty", \
    "StaticArrays", "Sundials", "AlgebraicMultigrid", "Optim"]); \
    Pkg.precompile(); Pkg.build(); Pkg.gc(); '

RUN julia -e 'using Pkg; Pkg.add(["Latexify","NLsolve", "RecursiveArrayTools", \
    "StochasticDiffEq", "NLopt", "CmdStan", "DynamicHMC", \
    "DoubleFloats", "TransformVariables", "Decimals", "DecFP"]); \
    Pkg.precompile(); Pkg.build(); Pkg.gc(); '

RUN julia -e 'using Pkg; Pkg.add(["Measurements","Unitful", "Cuba", \
    "KernelDensity", "MCMCChains", "CUDA", "DiffEqBase", \
    "SciMLBase", "SymbolicUtils", "Symbolics"]); \
    Pkg.precompile(); Pkg.build(); Pkg.gc(); '

# ]add Quadrature 附带预编译失败，但随后的Pkg.precompile()成功。 【通过】
RUN julia -e 'using Pkg; Pkg.add(["BoundaryValueDiffEq","DiffEqOperators", \
    "Quadrature", "DiffEqGPU"]); Pkg.precompile(); Pkg.build(); Pkg.gc(); '

# ]add DiffEqSensitivity 附带预编译 和 随后的Pkg.precompile()都失败。 【不通过】
#       改成
# ]add DiffEqSensitivity 附带预编译失败，但随后的using DiffEqSensitivity成功。 【通过】
RUN julia -e 'using Pkg; Pkg.add(["DiffEqSensitivity"]); ' \
    &&  julia -e 'using Pkg, DiffEqSensitivity; Pkg.build(); Pkg.gc(); '


RUN julia -e 'using Pkg; Pkg.add(["DiffEqFlux"]); Pkg.precompile(); Pkg.build(); Pkg.gc(); '


RUN julia -e 'using Pkg; Pkg.add(["DiffEqParamEstim"]); Pkg.precompile(); Pkg.build(); Pkg.gc(); '


# ]add NeuralPDE 附带预编译 和 随后的Pkg.precompile()都失败。 【不通过】
#       改成
# ]add NeuralPDE 附带预编译失败，但随后的using NeuralPDE成功。 【报警告通过】
# WARNING: Method definition (::Type{DiffEqFlux.DeterministicCNF{M, P, RE, D, T, A, K} where K where A where T where D where RE where P where M})(M, P, RE, D, T, A, K) where {M, P, RE, D, T, A, K} in module DiffEqFlux at deprecated.jl:70 overwritten at /root/.julia/packages/DiffEqFlux/w4Zm0/src/ffjord.jl:41.
#   ** incremental compilation may be fatally broken for this module **
# WARNING: could not import DistributionsAD._mv_categorical_logpdf into ReverseDiffX
# using NeuralPDE 很慢
RUN julia -e 'using Pkg; Pkg.add(["NeuralPDE"]); ' \
    &&  julia -e 'using Pkg, NeuralPDE; Pkg.build(); Pkg.gc(); '

# Pkg.build()时有时需要代理联网访问才能成功
# https://github.com/JuliaPackaging/Yggdrasil/releases/download/GMP-v6.1.2-1/build_GMP.v6.1.2.jl
RUN julia -e 'using Pkg; Pkg.add(["ArbNumerics"]); Pkg.gc(); '

# 升降级太多, 导致安装失败
# "StatsPlots"
# RUN julia -e 'using Pkg; Pkg.add(["StatsPlots"]); Pkg.precompile(); Pkg.build(); Pkg.gc(); '

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






