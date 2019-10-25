FROM ubuntu
LABEL author="Ruben Suarez <rubensa@gmail.com>"

# Tell systemd that is running inside docker
ENV container docker

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    # 
    # Basic apt configuration
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    # 
    # Install Systemd (https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/)
    && apt-get -y install systemd \
    #
    # Remove systemd non esential services (systemd, journald)
    && (for i in `find /lib/systemd/system/sysinit.target.wants/ -type f ! -name "systemd-tmpfiles-setup.service"`; do rm -f /lib/systemd/system/sysinit.target.wants/$i; done) \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/*

# Systemd defines that shutdown signal as SIGRTMIN+3 (Systemd does not exit on sigterm)
STOPSIGNAL SIGRTMIN+3

# Tell image required volumes
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock" ]

# Execute the init command
ENTRYPOINT [ "/sbin/init" ]

