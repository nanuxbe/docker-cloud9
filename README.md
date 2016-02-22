# docker-cloud9
Cloud9 within a docker image. Modified to use the v3 Cloud9 SDK and be friendly to Django + Ember development

# Base Docker Image
ubuntu:trusty

# Installation

## Usage

Firstly clone this git repo locally. Then build the docker image

    `cd docker-cloud9`
    `docker build . --tag=c9sdk`

Now run the docker image:

    `docker run -d -p 8181:8181 -p 4200:4200 -p 8000:8000 -p 49152:49152 -h djember-c9 c9sdk`
    
To ensure persistence add a volume via *-v /your/workspace/path/:/workspace/* :

    `docker run -d -p 8181:8181 -p 4200:4200 -p 8000:8000 -p 49152:49152 -h djember-c9 -v /path_to_your_workspace/:/workspace/ c9sdk`

The container can be stopped and started thereafter.
    
### More Info

Based on work by kdelfour and greigdp
