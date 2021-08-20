FROM ubuntu:20.04
MAINTAINER joistwang <joistwang@sina.com>

# 安装openfoam9 安装不成功，卡在apt-get -y install openfoam9中的区域选择这步，选择18（chinese）后长时间没反应，不得步放弃
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install wget gnupg \
    && apt-get -y install software-properties-common \
    && sh -c "wget -O - https://dl.openfoam.org/gpg.key | apt-key add -" \
    && add-apt-repository http://dl.openfoam.org/ubuntu \
    && apt-get update \
    && apt-get -y install openfoam9 \
    && echo "source /opt/openfoam9/etc/bashrc" >> ~/.bashrc

# (echo "18";sleep 1;echo "70") | apt-get -y install openfoam9