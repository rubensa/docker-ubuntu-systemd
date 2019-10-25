# Docker image based on Ubuntu and running systemd init system

This is a Docker image with Ubuntu running systemd init system inside a container.

## Building

You can build the image like this:

```
#!/usr/bin/env bash

docker build --no-cache \
	-t "rubensa/ubuntu-systemd" \
	--label "maintainer=Ruben Suarez <rubensa@gmail.com>" \
	.
```

## Running

You can run the container like this (change --rm with -d if you don't want the container to be removed on stop):

```
#!/usr/bin/env bash

prepare_docker_systemd() {
  # https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
  # Systemd expects /run is mounted as a tmpfs
  MOUNTS+=" --mount type=tmpfs,destination=/run"
  # Systemd expects /run/lock to be a separate mount point (https://github.com/containers/libpod/issues/3295)
  MOUNTS+=" --mount type=tmpfs,destination=/run/lock"
  # Systemd expects /sys/fs/cgroup filesystem is mounted.  It can work with it being mounted read/only.
  MOUNTS+=" --mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup,readonly"
  # Systemd expects /sys/fs/cgroup/systemd be mounted read/write.
  # Not needed as the subdir/mount points (/sys/fs/cgroup is already mounted) will be mounted in as read/write
  #MOUNTS+=" --mount type=bind,source=/sys/fs/cgroup/systemd,target=/sys/fs/cgroup/systemd"
}

prepare_docker_timezone() {
  # https://www.waysquare.com/how-to-change-docker-timezone/
  MOUNTS+=" --mount type=bind,source=/etc/timezone,target=/etc/timezone,readonly"
  MOUNTS+=" --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly"
}

prepare_docker_systemd
prepare_docker_timezone

docker run --rm -it \
  --name "ubuntu-systemd" \
  ${MOUNTS} \
  rubensa/ubuntu-systemd
```

## Connect

You can connect to the running container like this:

```
#!/usr/bin/env bash

docker exec -it \
  ubuntu-systemd \
  bash -l
```

## Stop

You can stop the running container like this:

```
#!/usr/bin/env bash

docker stop \
  ubuntu-systemd
```

## Start

If you run the container without --rm you can start it again like this:

```
#!/usr/bin/env bash

docker start \
  ubuntu-systemd
```
