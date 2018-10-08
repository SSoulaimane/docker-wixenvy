FROM justmoon/wix

ENV LANG=C.UTF-8
USER root
RUN apt-get update && \
    apt-get -y install \
    locales \
    rsync \
    openssh-server \
    sudo \
    procps \
    wget \
    unzip \
    mc \
    ca-certificates \
    curl \
    software-properties-common \
    python-software-properties \
    bash-completion && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -a -G users,sudo,root wix && \
    usermod -p "*" wix && \
    sudo update-ca-certificates -f && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 22 8000 8080 4403

USER wix

CMD sudo /usr/bin/ssh-keygen -A && \
    sudo /usr/sbin/sshd -D && \
    sudo su - && \
    tail -f /dev/null
