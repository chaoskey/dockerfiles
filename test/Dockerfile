FROM chaoskey/gridaplab:latest
MAINTAINER joistwang <joistwang@sina.com>

RUN julia -e 'using Pkg; pkg"remove Gridap GridapGmsh GridapODEs; add https://github.com/gridap/Gridap.jl.git#v0.16.3 https://github.com/gridap/GridapGmsh.jl.git#v0.4.2 https://github.com/gridap/GridapODEs.jl.git#v0.6.0; gc --all; precompile; build;"'




