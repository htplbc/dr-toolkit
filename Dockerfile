# Pull base image.
FROM mongo:4.2-bionic

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y tzdata locales


# Set the timezone
RUN echo "Etc/UTC" | tee /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Set the locale for UTF-8 support
RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
    locale-gen && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# AWS CLI needs the PYTHONIOENCODING environment varialbe to handle UTF-8 correctly:
ENV PYTHONIOENCODING=UTF-8

# AWS CLI allows three output modes : json, text, table
ENV AWS_DEFAULT_OUTPUT json

# man and less are needed to view 'aws <command> help'
# ssh allows us to log in to new instances
# vim is useful to write shell scripts
# python* is needed to install aws cli using pip install

RUN apt-get install -y \
    less \
    man \
    ssh \
    postgresql \
    python3 \
    python3-pip \
    vim \
    vim-nox \
    zip

RUN adduser --home /home/aws --disabled-login --gecos '' aws

USER aws
WORKDIR /home/aws

RUN \
    pip3 install awscli && \
    echo 'complete -C aws_completer aws' >> .bashrc


# Define mountable directories.
VOLUME ["/data/db"]