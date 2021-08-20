FROM firedrakeproject/firedrake
MAINTAINER joistwang <joistwang@sina.com>

USER firedrake

RUN bash -c ". /home/firedrake/firedrake/bin/activate && pip install jupyterlab"
ENV PATH=/home/firedrake/firedrake/bin:$PATH

# 构建firedrakelab镜像
# docker build -t chaoskey/firedrakelab firedrakelab

# firedrakelab临时运行
# docker run -it --rm chaoskey/firedrakelab bash

# firedrakelab容器及其bash
# docker run -d --name firedrakelab -v /mnt/e/work:/home/firedrake/work -w /home/firedrake/work/sci/firedrake -p 127.0.0.1:9988:9988 chaoskey/firedrakelab jupyter-lab --ip=0.0.0.0 --port 9988
# docker exec -ti -u firedrake firedrakelab bash
