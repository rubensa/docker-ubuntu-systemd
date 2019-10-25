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
  MOUNTS+=" --mount type=tmpfs,destination=/tmp"
  MOUNTS+=" --mount type=tmpfs,destination=/run"
  MOUNTS+=" --mount type=tmpfs,destination=/run/lock"
  MOUNTS+=" --mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup,readonly"
}

prepare_docker_timezone() {
  MOUNTS+=" --mount type=bind,source=/etc/timezone,target=/etc/timezone,readonly"
  MOUNTS+=" --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly"
}

prepare_docker_systemd
prepare_docker_timezone

docker run --rm -it \
  --name ubuntu-systemd \
  ${MOUNTS} \
  rubensa/ubuntu-systemd
```

NOTE: Mounting /etc/timezone and /etc/localtime allows you to use your host timezone on container.

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
