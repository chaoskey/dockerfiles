FROM debian:buster
MAINTAINER joistwang <joistwang@sina.com>

RUN apt-get update \ 
    && apt-get install -y software-properties-common \
    && sudo add-apt-repository ppa:fenics-packages/fenics \
    && sudo apt-get update \
    && sudo apt-get install -y fenics \
