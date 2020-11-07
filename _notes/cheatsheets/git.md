---
menu_title: Git
title: Cheat Sheets - Git
permalink: /notes/cheatsheets/git/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Initial Configuration

```shell
$ git config --global color.ui true
$ git config --global user.name "YOUR NAME"
$ git config --global user.email "YOUR@EMAIL.com"
```

<span class="info-source">Source: [https://gorails.com/setup/ubuntu/20.04](https://gorails.com/setup/ubuntu/20.04)</span>

## Display Branch in Terminal

Add to ~/.bash_rc (or ~/.bash_profile):

```shell
# Git branch in prompt.

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
```

<span class="info-source">Source: [https://gist.github.com/joseluisq/1e96c54fa4e1e5647940](https://gist.github.com/joseluisq/1e96c54fa4e1e5647940)</span>

## Delete a File from a Git Repository

```shell
$ git rm path_to_file_to_delete
$ git commit -m 'Remove file_to_delete'
```

<span class="info-source">Source: [https://stackoverflow.com/questions/2047465/how-can-i-delete-a-file-from-git-repo](https://stackoverflow.com/questions/2047465/how-can-i-delete-a-file-from-git-repo)</span>

## Empty Commit

```shell
$ git commit --allow-empty -m "This is an empty commit"
```

<span class="info-source">Source: [https://coderwall.com/p/vkdekq/git-commit-allow-empty](https://coderwall.com/p/vkdekq/git-commit-allow-empty)</span>

## Set Up a Local Branch to Track a Remote One

Affects the currently checked out branch.

```shell
$ git branch -u origin/branch_name_on_remote
```

<span class="info-source">Source: [https://www.git-tower.com/learn/git/faq/track-remote-upstream-branch](https://www.git-tower.com/learn/git/faq/track-remote-upstream-branch)</span>

## Delete a Local Branch

```shell
$ git branch -d local_branch_name
```

<span class="info-source">Source: [https://www.git-tower.com/learn/git/faq/delete-remote-branch](https://www.git-tower.com/learn/git/faq/delete-remote-branch)</span>

## Remove Untracked Files

This is done through the `git clean` command. It can be run in the dry run mode (`-n` option) to check the files that will be deleted:

```bash
$ git clean -n
```

To include untracked directories in the cleaning process, use the `-d` option:

```bash
$ git clean -d -n
```

To actually delete the untracked files, remove the `-d` option. Depending on the value of the Git configuration variable `clean.requireForce`, it may be necessary to use the `-f` option, otherwise `clean` will refuse to run. A path can be provided to limit the cleaning process to it.

```bash
$ git clean -d -f some_path
```

`-X` can be used to remove all files and directories specified by `.gitignore`. To delete both ignored and untracked files/directories, use the `-x` option instead:

```bash
$ git clean -d -n -x
$ git clean -d -n -X
```

Lastly, `-i` can be used to the process interactively:

```bash
$ git clean -d -i
```

<span class="info-source">Source: [https://linuxize.com/post/how-to-remove-untracked-files-in-git/](https://linuxize.com/post/how-to-remove-untracked-files-in-git/)</span>
