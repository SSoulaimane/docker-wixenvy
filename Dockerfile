# Machine for codenvy.io running windows wix toolset using wine on archlinux

FROM ssoulaiman/archenvy

ENV LANG=C.UTF-8
USER root

# enable multilib repo
RUN tmp=$(mktemp) \
    awk 'BEGIN {u=0} {if ($0 ~ "^\\s*#*\\s*\\[") u=0; if (!u && $0 ~ "^\\s*#+\\s*" "\\[" repo "\\]") u=1; if (u && $0 ~ "^\\s*#+\\s*(\\[|[^\\s]+\\s*=)") sub("^\\s*#+\\s*", ""); print; }' \
    repo=multilib /etc/pacman.conf >$tmp && \
    mv /etc/pacman.conf{,.bak} && \
    mv $tmp /etc/pacman.conf && \
    pacman -Sy

USER user

ENV WINEPREFIX=/home/user/.wine
ENV WINEARCH=win32
# install wine
RUN sudo pacman -Sy wine winetricks xorg-server-xvfb && \
    wine wineboot

# install dotnet40
RUN xvfb-run winetricks -q dotnet40

# install wix
RUN sudo pacman -Sy wget unzip && \
    mkdir /home/user/wix && cd /home/user/wix && \
    wget 'https://github.com/wixtoolset/wix3/releases/download/wix3111rtm/wix311-binaries.zip' \
        -O wix311-binaries.zip && \
    unzip wix311-binaries.zip && \
    rm wix311-binaries.zip
