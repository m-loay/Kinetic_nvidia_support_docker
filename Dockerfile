FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04

LABEL Description="ROS-Kinetic-Desktop (Ubuntu 16.04)" Vendor="TurluCode" Version="2.4"
LABEL com.turlucode.ros.version="kinetic"

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

# Install packages
RUN apt-get update && apt-get install -y \
lsb-release \
mesa-utils \
git \
subversion \
wget \
curl \
htop \
libssl-dev \
dbus-x11 \
python3 python3-dev python3-pip \
software-properties-common python-software-properties \
gdb valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Install cmake 3.15.5
RUN git clone https://gitlab.kitware.com/cmake/cmake.git && \
cd cmake && git checkout tags/v3.15.5 && ./bootstrap --parallel=8 && make -j8 && make install && \
cd .. && rm -rf cmake

# Install new paramiko (solves ssh issues)
RUN apt-add-repository universe
RUN apt-get update && apt-get install -y python-pip python build-essential && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN /usr/bin/yes | pip install --upgrade "pip < 21.0"
RUN /usr/bin/yes | pip install --upgrade virtualenv
RUN /usr/bin/yes | pip install --upgrade paramiko
RUN /usr/bin/yes | pip install --ignore-installed --upgrade numpy protobuf
RUN /usr/bin/yes | pip3 install --upgrade "pip < 20"
RUN /usr/bin/yes | pip3 install --upgrade numpy

# Locale
RUN apt-get update && apt-get install -y locales && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV QT_X11_NO_MITSHM 1



# Install ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
libpcap-dev \
gstreamer1.0-tools libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev \
ros-kinetic-desktop-full python-rosinstall python-rosinstall-generator python-wstool build-essential \
ros-kinetic-socketcan-bridge \
ros-kinetic-geodesy && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure ROS
RUN rosdep init && rosdep update 
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc

RUN sudo apt update
RUN sudo apt install -y software-properties-common apt-transport-https wget
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN sudo apt update
RUN sudo apt install -y code
