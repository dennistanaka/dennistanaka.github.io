---
menu_title: Basics
title: Docker - Basics
permalink: /notes/docker/basics/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Containers

A `container` is a runtime instance of an `image` (executable package that includes everything needed to run an application--the code, a runtime, libraries, environment variables, and configuration files). A container is sandboxed, so if a service needs to be accessed by an outside process, the corresponding port needs to be exposed to the host. This way, for outside processes, it seems as if the service is run by the host itself.

## PID Namespaces

A PID namespace is a set of PIDs (process identifiers) that can be created and Docker creates a new one for each container it starts, so two separate containers can have a process with PID 1 without conflicts, for example. This also provides security as these namespaces are separated from the host one. Eventually, it may be necessary to share the process namespace between the host and a container. This can be achieved by the `--pid=host` flag:

```bash
$ docker run --pid=host <image_name> ps
```

## Container Identification

When we start working with multiple containers, we may create conflicts between running containers. We cannot create two containers with the same name (`--name` flag), for example. One mechanism that may help us in this task is to use the container identifiers (CI) Docker assign to each container. Those are very long IDs, but we may use only the first 12 characters with very little risk of collision between them.

These container identifiers are not particularly friendly for humans, but we may use them for automation as we can store a CID in an envrionment variable when starting the container for later use. This is only true for dettached containers as the `docker run` command will return the CID immediately. For interactive containers, we can use the `docker create` command to get the container's CID before running it. CIDs can be useful for automation as collisions are unlikely, but Docker also provides a human-friendly mechanism to help us identify containers easier in the form of generated names.  

## Volumes

Everytime a container is re-created, its data is removed. That's because containers are stateless. If data needs to be persisted, we need to use what is called `volumes` and link a folder in the container to a folder in the host. This is done by using the option `-v <host-dir>:<container-dir>`

```bash
$ docker run -d --name project_redis_persisted -v /opt/docker/data/redis:/data redis:latest
```
