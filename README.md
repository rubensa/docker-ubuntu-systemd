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

docker run --rm -it \
  --name "ubuntu-systemd" \
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /run/lock \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  rubensa/ubuntu-systemd
```

## Connect

You can connect to the running container like this:

```
#!/usr/bin/env bash

docker exec -it \
  "ubuntu-systemd" \
  bash -l
```

## Stop

You can stop the running container like this:

```
#!/usr/bin/env bash

docker stop \
  "ubuntu-systemd"
```

## Start

If you run the container without -rm you can start it again like this:

```
#!/usr/bin/env bash

docker start "ubuntu-systemd"
```
