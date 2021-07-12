FROM debian:buster
MAINTAINER joistwang <joistwang@sina.com>

RUN apt-get update

# 安装Python
RUN apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev curl \
    && curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz \
    && tar -xf Python-3.8.2.tar.xz \
    && cd Python-3.8.2 \
    && ./configure --enable-optimizations \
    && make -j "$(nproc)" \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.8.2 \
    && rm Python-3.8.2.tar.xz \
    && ln -s /usr/local/bin/python3.8 /usr/bin/python3 \
    && ln -s /usr/local/bin/pip3.8 /usr/bin/pip3 \ 
    && apt-get remove -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev \
    && apt-get autoremove -y

# 安装JupyterLab
RUN pip3 install jupyterlab pysqlite3 \
    && sed -i "s@from pysqlite2@from pysqlite3@g" /usr/local/lib/python3.8/site-packages/jupyter_server/services/sessions/sessionmanager.py

