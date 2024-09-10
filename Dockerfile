FROM ubuntu:22.04

# Update system and add the packages required for Yocto builds.
# Use DEBIAN_FRONTEND=noninteractive, to avoid image build hang waiting
# for a default confirmation [Y/n] at some configurations.

ENV DEBIAN_FRONTEND=noninteractive
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

RUN \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt update
RUN apt install apt-transport-https ca-certificates tofrodos gawk xvfb gcc git make \
    net-tools libncurses5-dev zsh zlib1g-dev libssl-dev flex bison libselinux1 gnupg \
    wget diffstat chrpath socat autopoint libtool tar unzip texinfo gcc-multilib bc \
    build-essential libsdl1.2-dev libglib2.0-dev gzip vim cmake lzop ntpdate autoconf \
    proxychains xinetd aria2 libncursesw5 swig libsqlite3-dev sudo locales curl pip \
    gettext doxygen dos2unix python3 u-boot-tools mono-devel mono-complete python3-distutils \
    pseudo python3-sphinx g++-multilib libc6-dev-i386 jq git-lfs zstd pigz liblz4-tool  \
    cpio file lz4 -y

RUN curl -s "https://raw.githubusercontent.com/carloscn/script/master/down_tool_chains/down_toolchain_11.3.rel1.sh" | bash
RUN rm -rfv *.tar.xz

# Set up locales
RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Yocto needs 'source' command for setting up the build environment, so replace
# the 'sh' alias to 'bash' instead of 'dash'.
RUN rm /bin/sh && ln -s bash /bin/sh

# Install repo
RUN curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo > /bin/repo && chmod a+x /bin/repo

RUN pip install cryptography paramiko pyelftools

RUN sudo dpkg-reconfigure dash

# Add your user to sudoers to be able to install other packages in the container.
RUN groupadd build -g 1000
RUN useradd -ms /bin/bash -p build build -u 1028 -g 1000 && \
        usermod -aG sudo build && \
        echo "build:build" | chpasswd

# Yocto builds should run as a normal user.
USER build

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" || true

RUN git config --global --add safe.directory /home/build/yocto/yocto-build/sources/bitbake && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-arago  && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-arm  && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-edgeai  && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-openembedded  && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-qt5 && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-ti && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-tisdk && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/meta-virtualization && \
    git config --global --add safe.directory /home/build/yocto/yocto-build/sources/oe-core

ARG DOCKER_WORKDIR
WORKDIR ${DOCKER_WORKDIR}