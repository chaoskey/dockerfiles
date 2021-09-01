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
RUN apt-get install -y openssh-server

# 启动脚本run.sh
RUN echo "#! /bin/bash" >> /root/run.sh \      
    && echo "# 启动SSH服务(端口22)" >> /root/run.sh \     
    && echo "sudo /etc/init.d/ssh start" >> /root/run.sh \
    && echo "# 启动JupyterLab服务(端口80)" >> /root/run.sh \
    && echo "jupyter-lab --allow-root --ip=0.0.0.0 --port 80" >> /root/run.sh \
    && chmod +x /root/run.sh

