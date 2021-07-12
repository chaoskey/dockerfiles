FROM quay.io/fenicsproject/stable:latest
MAINTAINER joistwang <joistwang@sina.com>

RUN apt-get update

# http://www.lesfleursdunormal.fr/static/informatique/soya3d/index_en.html

# OpenGL (possibly Mesa)
RUN apt-get install -y build-essential libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev mesa-utils

# OpenAL (http://openal.org) for sound support
RUN apt-get install -y libopenal-dev

# GLEW (The OpenGL Extension Wrangler Library, http://glew.sf.net)
RUN apt-get install -y libglew-dev

# SDL 2.0 (http://libsdl.org)
RUN apt-get install -y libsdl2-dev libsdl2-image-dev  

# Cerealizer (http://www.lesfleursdunormal.fr/static/informatique/cerealizer/index_en.html)
RUN pip install Cerealizer

# Cal3D 0.10.0 (http://cal3d.sourceforge.net ; cal3d is sufficient, cal3d_viewer, data,... are not needed)
RUN apt-get install -y libcal3d12-dev

# libFreeType2 (http://www.freetype.org)
RUN apt-get install -y libfreetype6-dev \
    && mv -f /usr/include/freetype2/freetype/*  /usr/include/freetype2/ \
    && rm  -df  /usr/include/freetype2/freetype \
    && ln -s /usr/include/freetype2 /usr/include/freetype

# 额外补充
RUN apt-get install -y libvorbis-dev

# 安装Soya3
RUN pip install Soya3

RUN apt-get install -y  x11-apps pulseaudio

RUN echo "export DISPLAY=\$(grep -m 1 nameserver /etc/resolv.conf | awk '{print \$2}'):0.0" >> /etc/profile \      
    && echo "export PULSE_SERVER=tcp:\$(grep -m 1 nameserver /etc/resolv.conf | awk '{print \$2}')" >> /etc/profile \     
    && echo "export SDL_VIDEO_X11_VISUALID=\$(glxinfo | grep -A 4 Visuals | grep -E -o  '0x[0-9]{3}')" >> /etc/profile

# 修改dolfin-plot源码
# 修改ffc/plot.py源码
RUN cp /usr/local/bin/dolfin-plot  /usr/local/bin/dolfin-plot_bak \
    && chmod +w /usr/local/bin/dolfin-plot \
    && sed -i "s@env\s\+python@env python3@g" /usr/local/bin/dolfin-plot \
    && sed -i '/print "/ { :begin; /print\s\+"\+[^"]\+"\+\s*\(\%\s*.\+\)\?\s*$/! { $! { N; b begin }; }; }; s/print\s\+\("\+[^"]\+"\+\s*\(\%\s*.\+\)\?\)\s*$/print(\1)/g' /usr/local/bin/dolfin-plot \
    && chmod -w /usr/local/bin/dolfin-plot \
    && cp /usr/local/lib/python3.6/dist-packages/ffc/plot.py /usr/local/lib/python3.6/dist-packages/ffc/plot.py_bak \
    && chmod +w /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && sed -i "s@import soya@import soya3 as soya@g" /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && sed -i "s@from soya@from soya3@g" /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && sed -i "/# Handle exit/ { :begin; /# Handle exit.*idler.idle()/! { $! { N; b begin }; }; }; s/# Handle exit.*idler.idle()/try:\n        soya.MainLoop(scene).main_loop()\n    except:\n        pass\n/g" /usr/local/lib/python3.6/dist-packages/ffc/plot.py \
    && chmod -w /usr/local/lib/python3.6/dist-packages/ffc/plot.py

# 修改源码plotting.py
# NotImplementedError: It is not currently possible to manually set the aspect on 3D axes
RUN sed -i "s@ax.set_aspect('equal')@    ax.set_aspect('equal')@g" /usr/local/lib/python3.6/dist-packages/dolfin/common/plotting.py

# 支持glx visual
RUN echo "export SDL_VIDEO_X11_VISUALID=\$(glxinfo | grep -A 4 Visuals | grep -E -o  '0x[0-9]{3}')" >> /etc/profile


