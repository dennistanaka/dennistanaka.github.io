---
menu_title: Cheat Sheet
title: Docker - Cheat Sheet
permalink: /notes/docker/cheatsheet/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Cheat Sheet

### Information about the Installation

Docker version:

```bash
$ docker --version
```

Additional information:

```bash
$ docker info
```

### Managing Images

Search available images:

```bash
$ docker search <image_name>
```

List images (downloaded and built):

```bash
$ docker image ls
```

### Running Containers

```bash
$ docker run <image_name>

# example (running in background):
$ docker run --detach redis:latest # --detach or -d: detached mode (daemon or service)

# with further customization:
# --publish or -p: binds port 80 of the container to TCP port 8080 of the host. We could also limit access from the host with: 127.0.0.1:8080:80
$ docker run --detach --name web --publish 8080:80 nginx:1.19-alpine # equivalent to: 0.0.0.0:8080:80

# running interactive containers
# --interactive keeps STDIN open and --tty allocates a virtual terminal for the container
$ docker run --interactive --tty --link web:alias_for_web busybox /bin/sh # or -i and -t, even -it to apply both

# the container above will have an entry added to /etc/hosts so we could, for example, run: ping alias_for_web

# detach from a running container with Ctrl + P and then Q

# we can later attach to a running container
$ docker attach <container_name>
```

Why run container with --interactive and without --tty?

> Since -i keeps STDIN open even if not attached, it allows for composition (piping):

```bash
$ echo hello | docker run -i busybox cat
  hello
```

Source: [StackOverflow](https://stackoverflow.com/questions/35459652/when-would-i-use-interactive-without-tty-in-a-docker-container)

### Managing Containers

List running containers:

```bash
$ docker ps
```

Restart containers:

```bash
$ docker restart web
```

Stop containers:

```bash
$ docker stop web
```

Rename containers:

```bash
$ docker rename web web-old
```

List all containers:

```bash
$ docker container ls --all # or -a
```

Create a container in a stopped state:

```bash
$ docker create nginx # this will output the container id
```

We can assign this to a shell variable for later use:

```bash
$ CID=$(docker create nginx)
$ echo $CID
```

There's even a flag to write this id to a file:

```bash
$ docker create --cidfile /tmp/nginx.cid nginx
$ cat /tmp/nginx.cid
```

We can get the container id by other means:

```bash
$ CID=$(docker ps --latest --quiet) # or -l -q; --no-trunc can be used for the full CID
$ echo $CID
```

### Monitoring Containers

Show information about a container:

```bash
$ docker inspect <friendly-name|container-id>
```

Show the logs output by a container:

```bash
$ docker logs <friendly-name|container-id>
```

### Running Applications

Run processes in the foreground:

```bash
$ docker run redis:latest ps

or

$ docker run -it redis:latest bash
```

Run commands in a running container:

```bash
$ docker exec <friendly-name|container-id> echo hello

# interactive mode
$ docker exec -it <friendly-name|container-id> bash
```

## Dockerfile

Instructions on how to build a Docker image. A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image. A Docker image is created from a base image and `alpine` is a very well-known base image used to build Docker images.

### Example - A Static HTML Website as a Container

Create a Dockerfile with the following content:

```
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

We are creating a new image based on the Alpine version of Nginx. Then we are copying the content of the current folder to the `/usr/share/nginx/html` folder inside the container. The current folder will contain the HTML website we want to work with.

Then we can run the `build` command that executes each instruction in the Dockerfile and creates a Docker image to learn our application.

```bash
$ docker build -t project_web:v1 .
```

Where the `-t` option allow us to define a friendly name for the image and a tag.

We can now run a container by using the image we just built:

```bash
$ docker run -d -p 8080:80 test_webserver:v1
```

### Example - Rails Project in a Container

Make sure you have the desired version of Ruby and Ruby on Rails installed. As `rails` uses the latest version installed, it's possible to replace by `rails _version_` to create the new project targeting a specific version.

Create the new project:

```bash
$ rails new rails_on_docker --skip-bundle
```

Place the following `Dockerfile` in the project's root:

```
FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install --path 'vendor/bundle'
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

```

Build the image:

```bash
$ docker build --tag=rails_on_docker .
```

Check the built image:

```bash
$ docker image ls

or

$ docker images
```

If something goes wrong, images can be removed with:

```bash
$ docker rmi -f image_id
```

Run the project:

```bash
$ docker run -p 3000:3000 rails_on_docker
```

Run in detached mode:

```bash
$ docker run -d -p 3000:3000 rails_on_docker
```

We can stop the container by its id:

```bash
$ docker container stop container_id
```

## Clean Up

Source: [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)
