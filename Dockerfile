# Machine for codenvy.io running windows wix toolset using wine on archlinux

FROM ssoulaiman/archenvy

ENV LANG=C.UTF-8
USER root

# enable multilib repo
RUN true && tmp=$(mktemp) && \
    awk 'BEGIN {u=0} {if ($0 ~ "^\\s*#*\\s*\\[") u=0; if (!u && $0 ~ "^\\s*#+\\s*" "\\[" repo "\\]") u=1; if (u && $0 ~ "^\\s*#+\\s*(\\[|[^\\s]+\\s*=)") sub("^\\s*#+\\s*", ""); print; }' \
    repo=multilib /etc/pacman.conf >$tmp && \
    cp /etc/pacman.conf{,.bak} && \
    cat $tmp >/etc/pacman.conf && \
    pacman --noconfirm -Sy

USER user

ENV WINEPREFIX=/home/user/.wine
ENV WINEARCH=win32
# install wine
RUN sudo pacman --noconfirm -Sy wine winetricks xorg-server-xvfb && \
    wine wineboot

# install dotnet40
RUN xvfb-run winetricks -q dotnet40

# install wix
RUN sudo pacman --noconfirm -Sy wget unzip && \
    mkdir /home/user/wix && cd /home/user/wix && \
    wget 'https://github.com/wixtoolset/wix3/releases/download/wix3111rtm/wix311-binaries.zip' \
        -O wix311-binaries.zip && \
    unzip wix311-binaries.zip && \
    rm wix311-binaries.zip
