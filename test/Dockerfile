FROM chaoskey/gridaplab:latest
MAINTAINER joistwang <joistwang@sina.com>

RUN echo "const get_fe_basis = get_cell_shapefuns" >> /root/.julia/packages/Gridap/EZQEK/src/Exports.jl \
    && echo "const get_trial_fe_basis = get_cell_shapefuns_trial" >> /root/.julia/packages/Gridap/EZQEK/src/Exports.jl \
    && echo "export get_fe_basis, get_trial_fe_basis" >> /root/.julia/packages/Gridap/EZQEK/src/Exports.jl \
    && julia -e 'using Pkg; pkg"precompile; build;"'


