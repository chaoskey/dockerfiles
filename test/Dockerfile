FROM ubuntu:20.04 
MAINTAINER joistwang <joistwang@sina.com>

RUN apt-get update  
RUN DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y software-properties-common 
RUN add-apt-repository -y ppa:fenics-packages/fenics 
RUN apt-get update 
RUN apt-get install -y fenics
RUN apt-get install -y pip
RUN pip3 install jupyterlab



 
