# docker-cloud9
Cloud9 within a docker image.

# Base Docker Image
[dockerfile/supervisor](https://registry.hub.docker.com/u/dockerfile/supervisor/)

# Installation

## Usage

    docker run -it -d -p 3131:3131 mkodockx/docker-cloud9
    
To ensure persistence add a volume via *-v /your/workspace/path/:/workspace/* :

    docker run -it -d -p 3131:3131 -v /your/workspace/path/:/workspace/ mkodockx/docker-cloud9
    
### More Info

Based on work by kdelfour