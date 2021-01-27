---
menu_title: Compose
title: Docker - Compose
permalink: /notes/docker/compose/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Commands

### run

#### Basic usage:

```bash
$ docker-compose run web bash
```

The specified command start in new containers (while `exec` executes in running ones) as defined by the service, except: the command in the configuration is replaced by the specified command and the defined port mapping is not applied to avoid collision with active ports. This also starts linked services, if required.

The `--rm` option can be used to remove the container after the command finish running.

### restart

This command simply stops and starts the defined services. Changes to `docker-compose.yml` are not captured by this command.

For example, if we add a new environment variable to `docker-compose.yml`, you won't be able to find it in the container by just using `restart`. Now, if you use `up`, then the container will be recreated to reflect the changes to the configuration. We can confirm this by checking that the container has a different id after `up`.

## Configuration

### volumes

```yaml
version: "3.9"
services:
  web:
    image: nginx:alpine
    volumes:
      - type: volume
        source: mydata
        target: /data
        volume:
          nocopy: true
      - type: bind
        source: ./static
        target: /opt/app/static

  db:
    image: postgres:latest
    volumes:
      - "/var/run/postgres/postgres.sock:/var/run/postgres/postgres.sock"
      - "dbdata:/var/lib/postgresql/data"

volumes:
  mydata:
  dbdata:
```

The top-level `volumes` key is needed to reuse a volume accross multiple services and is not required otherwise.

#### Short Syntax:

Uses the generic `[SOURCE:]TARGET[:MODE]` format and can be specified in a couple of different ways:

```yaml
volumes:
  # Just specify a path and let the Engine create a volume
  - /var/lib/mysql

  # Specify an absolute path mapping
  - /opt/data:/var/lib/mysql

  # Path on the host, relative to the Compose file
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Named volume
  - datavolume:/var/lib/mysql
```


Check <https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes> for the long syntax.
