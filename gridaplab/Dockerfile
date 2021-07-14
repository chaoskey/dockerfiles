FROM chaoskey/julialab:latest
MAINTAINER joistwang <joistwang@sina.com>

# 安装Gridap GridapGmsh
RUN julia -e 'using Pkg; pkg"add Gridap GridapGmsh;"'

# Gridap教程用到的第三方库
RUN julia -e 'using Pkg; pkg"add Plots LineSearches FillArrays;  precompile;"'


