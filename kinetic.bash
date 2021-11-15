#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

nvidia-docker run -it \
        --volume=$XSOCK:$XSOCK:rw \
        --volume=$XAUTH:$XAUTH:rw \
        -v /home/mloay/Documents/git:/home/git \
        --env="XAUTHORITY=${XAUTH}" \
        --env="DISPLAY" \
        --env="UID=`id -u $who`" \
        --env="UID=`id -g $who`" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    mloay/nvidia-ros-kinetic:latest \
    bash
