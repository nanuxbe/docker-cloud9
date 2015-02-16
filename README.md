# docker-cloud9
Cloud9 within a docker image. Modified to use the v3 Cloud9 SDK

# Base Docker Image
[dockerfile/supervisor](https://registry.hub.docker.com/u/dockerfile/supervisor/)

# Installation

## Usage

Firstly clone this git repo locally. Then build the docker image

    cd docker-cloud9
    docker build . --tag=c9sdk

Now run the docker image:

    docker run -p 8181:8181 c9sdk
    
To ensure persistence add a volume via *-v /your/workspace/path/:/workspace/* :

    docker run -p 8181:8181 -v /your/workspace/path/:/workspace/ c9sdk

The container can be stopped and started thereafter.
    
### More Info

Based on work by kdelfour
