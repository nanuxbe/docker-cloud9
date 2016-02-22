FROM ubuntu:trusty
# Modified to use the new cloud9 v3 SDK release


# ------------------------------------------------------------------------------
# Install base
RUN apt-get update -qy
RUN apt-get install -qy --force-yes git vim build-essential g++ curl libssl-dev apache2-utils software-properties-common unzip wget sudo tmux hostname

# ------------------------------------------------------------------------------
# Install extra python packages
RUN add-apt-repository -y ppa:fkrull/deadsnakes
RUN apt-get update -qy
RUN apt-get install -qy --force-yes python2.7-dev python3.5 python3.5-dev python-pip python-virtualenv postgresql-server-dev-9.3 libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev libxml2-dev libxslt1-dev

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -qy --force-yes nodejs


# Add bower and ember-cli
RUN npm install -g bower ember-cli

# ------------------------------------------------------------------------------
# Install NVM
# RUN git clone https://github.com/creationix/nvm.git /.nvm
# RUN echo ". /.nvm/nvm.sh" >> /etc/bash.bashrc
# RUN /bin/bash -c '. /.nvm/nvm.sh && \
#     nvm install v0.10.18 && \
#     nvm use v0.10.18 && \
#     nvm alias default v0.10.18'

# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh
RUN sed -i 's/standalone: true/appHostname: "localhost:4200", standalone:true/g' /c9sdk/settings/standalone.js
RUN sed -i 's/https/http/g' /c9sdk/plugins/c9.ide.preview/preview.js
RUN export 

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Add user
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /etc/skel/.bashrc
RUN useradd -ms /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R user /c9sdk
RUN chown -R user /workspace
# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 8181
EXPOSE 8000 
EXPOSE 4200
EXPOSE 49152

# ------------------------------------------------------------------------------
# Start c9sdk, define default command.
USER user
RUN curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | bash
WORKDIR /workspace
CMD ["node", "/c9sdk/server.js", "-l", "0.0.0.0", "-a", ":", "-w", "/workspace/"]
