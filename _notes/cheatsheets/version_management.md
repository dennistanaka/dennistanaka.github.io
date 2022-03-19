---
menu_title: Version Management
title: Cheat Sheets - Version Management
permalink: /notes/cheatsheets/version_management/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## rbenv (Ruby)

### List Ruby Versions

```bash
$ rbenv versions
```

## gvm (Go)



## pyenv (Python)

<https://github.com/pyenv/pyenv>

### Installation (on macOS)

```bash
$ brew update
$ brew install pyenv
```

### Activate (for Zsh)

```bash
$ echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc

# restart the shell
$ exec "$SHELL"
```

### Install a New Version of Python

```bash
$ pyenv install 3.7.9

# make it default
$ pyenv global 3.7.9
```

## virtualenv (Python)

<https://virtualenv.pypa.io/en/latest/>

### Installation

```bash
$ pip install virtualenv
```

### Usage Example

```bash
$ mkdir python-envs

# python-envs/my-project-venv - could be any other folder
$ virtualenv python-envs/my-project-venv

$ source python-envs/my-project-venv/bin/activate
```
