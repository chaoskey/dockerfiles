#! /bin/bash 


######################
#     没有指定参数，依次执行
#     亦可指定参数执行
######################

if [ $1"x" == "sshdx" -o $1"x" == "x" ]
then
    ps -ef | grep sshd | grep -v grep | grep -v run.sh
    if [ $? -ne 0 ]
    then
        # 启动SSH服务(端口22)
        if [ $2"x" == "x" ]
        then
            /etc/init.d/ssh start
        else
            /etc/init.d/ssh start $2
        fi
    fi
fi

if [ $1"x" == "jupyterlabx" -o $1"x" == "x" ]
then
    ps -ef | grep jupyter | grep -v grep | grep -v run.sh
    if [ $? -ne 0 ]
    then
        # 启动JupyterLab服务(端口80)
        jupyter-lab --allow-root --ip=0.0.0.0 --port 80
    fi
fi



