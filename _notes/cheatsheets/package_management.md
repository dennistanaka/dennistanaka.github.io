---
menu_title: Package Management
title: Cheat Sheets - Package Management
permalink: /notes/cheatsheets/package_management/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## apt

### Check Whether or Not a Package is Installed

```bash
$ dpkg --list qemu*
...
un  qemu-system-x86-64     <none>           <none>       (no description available)
ii  qemu-utils             1:4.2-3ubuntu6.6 amd64        QEMU utilities
```

un: not installed<br>
ii: installed

## Homebrew

### List Installed Packages

```bash
brew list
```

### Install Specific Version of a Package

Search the package:

```bash
$ brew search package
```

Install a specific version:

```bash
$ brew install package@5
```

We may have multiple versions of a package installed, but only one active at a time. We need to unlink an exisitng package before making the installed one active:

```bash
$ brew unlink package
$ brew link package@5
```

We may need to use the options below depending on the package:

```bash
$ brew link --force --overwrite package@5
```

<span class="info-source">Source: [https://apple.stackexchange.com/questions/171530/how-do-i-downgrade-node-or-install-a-specific-previous-version-using-homebrew](https://apple.stackexchange.com/questions/171530/how-do-i-downgrade-node-or-install-a-specific-previous-version-using-homebrew)</span>

## Gems (Ruby)

### List Installed Gems

```bash
$ gem list
```

## pip (Python)

### List Installed Packages

```bash
$ pip list
```

## npm (Node - packages.json)

### List Installed Packages (Global)

```bash
$ npm list -g
```

### Dependencies

Options for dependency declaration, especially version definition.

- `version` Must match `version` exactly
- `>version` Must be greater than `version`
- `>=version` etc
- `<version`
- `<=version`
- `~version` Approximately equivalent to `version`
- `^version` Compatible with `version`
- `1.2.x` 1.2.0, 1.2.1, etc., but not 1.3.0
- `http://...`
- `*` Matches any version
- `""` (just an empty string) Same as `*`
- `version1 - version2` Same as `>=version1` `<=version2`
- `range1 || range2` Passes if either `range1` or `range2` are satisfied
- `git...`
- `user/repo`
- `tag` A specific version tagged and published as `tag`
- `path/path/path`

For example, these are all valid:

{% highlight javascript %}
{ "dependencies" :
  { "foo" : "1.0.0 - 2.9999.9999"
  , "bar" : ">=1.0.2 <2.1.2"
  , "baz" : ">1.0.2 <=2.3.4"
  , "boo" : "2.0.1"
  , "qux" : "<1.0.0 || >=2.3.1 <2.4.5 || >=2.5.2 <3.0.0"
  , "asd" : "http://asdf.com/asdf.tar.gz"
  , "til" : "~1.2"
  , "elf" : "~1.2.3"
  , "two" : "2.x"
  , "thr" : "3.3.x"
  , "lat" : "latest"
  , "dyl" : "file:../dyl"
  }
}
{% endhighlight %}

<span class="info-source">Source: [https://docs.npmjs.com/files/package.json#dependencies](https://docs.npmjs.com/files/package.json#dependencies)</span>
