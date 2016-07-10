FROM ubuntu:xenial
# Modified to use the new cloud9 v3 SDK release


# ------------------------------------------------------------------------------
# Install base
RUN apt-get update -qy
RUN apt-get install -qy --allow-downgrades --allow-remove-essential --allow-change-held-packages git vim build-essential g++ curl libssl-dev apache2-utils software-properties-common unzip wget sudo tmux hostname

# ------------------------------------------------------------------------------
# Install extra python packages
RUN add-apt-repository -y ppa:fkrull/deadsnakes
RUN apt-get update -qy
RUN apt-get install -qy --allow-downgrades --allow-remove-essential --allow-change-held-packages python2.7-dev python3.5 python3.5-dev python-pip python-virtualenv postgresql postgresql-server-dev-all postgresql-server-dev-9.5 libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev libxml2-dev libxslt1-dev libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -qy --allow-downgrades --allow-remove-essential --allow-change-held-packages nodejs

# Add cookiecutter and radon
RUN pip install cookiecutter radon

# Add bower, ember-cli and phantomjs
RUN npm install -g bower ember-cli phantomjs-prebuilt git://github.com/peterkc/es6-plato.git

# Install Cloud9
RUN git clone https://github.com/c9/core.git /c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh
RUN sed -i 's/standalone: true/appHostname: "localhost:4200", standalone:true/g' /c9sdk/settings/standalone.js
RUN sed -i 's/https/http/g' /c9sdk/plugins/c9.ide.preview/preview.js

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
