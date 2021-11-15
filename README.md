# Docker container images with ROS, Gazebo(Kinetic), with Nvidia Support
This repository developed from nvidia/opengl and nvidia/cuda conatiners, combine these two together to create a ROS develope environment in docker


## Requirement
* Docker and Nvidia-docker(docker nvidia runtime) on the host: Check with [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
* X11 Server install:

      $ apt-get install xauth xorg openbox

## Usage

- Build an image from scratch:

      docker build -t mloay/nvidia-ros-kinetic .

## Run
use kinetic.bash
