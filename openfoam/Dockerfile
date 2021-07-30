FROM ubuntu:20.04
MAINTAINER joistwang <joistwang@sina.com>

# 安装openfoam9
RUN sh -c "wget -O - https://dl.openfoam.org/gpg.key | apt-key add -" \
    && add-apt-repository http://dl.openfoam.org/ubuntu \
    && apt-get update \
    && apt-get -y install openfoam9