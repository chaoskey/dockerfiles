#! /bin/bash 

##################
#     指定参数执行
##################

if [ $1"x" == "x11_audiox" ]
then
    # 窗口&音频转发
    read -p "确认已经启动 窗口&音频 转发服务？ [按任意键继续]"
    export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
    export PULSE_SERVER=tcp:$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}')
    export SDL_VIDEO_X11_VISUALID=$(glxinfo | grep -A 4 Visuals | grep -E -o  '0x[0-9]{3}')
fi

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
            sudo /etc/init.d/ssh start
        else
            sudo /etc/init.d/ssh start $2
        fi
    fi
fi

if [ $1"x" == "jupyterlabx" -o $1"x" == "x" ]
then
    ps -ef | grep jupyter | grep -v grep | grep -v run.sh
    if [ $? -ne 0 ]
    then
        # 启动JupyterLab服务(端口80)
        jupyter-lab --ip=0.0.0.0 --port 80
    fi
fi



