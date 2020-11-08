---
menu_title: Toolbox
title: Tools - Toolbox
permalink: /notes/tools/toolbox/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

# Code Editor

* Visual Studio Code
  * Current theme: [Palenight](https://github.com/whizkydee/vscode-material-palenight-theme)
  * Extensions
    * [Settings Sync](https://github.com/shanalikhan/code-settings-sync) - can't live without this to keep all my settings in sync accross machines
* Atom
  * Current theme: [Nova]()
  * Extensions:
    * [Sync Settings]()

# Code Snippets - Lepton

To manage code snippets, I'm currently using an app called [Lepton](https://github.com/hackjutsu/Lepton). It has been fulfilling my needs since I just wanted a bit user-friendlier interface to manage my GitHub gists and that's exactly what it is.

## Installation on Linux

Install Snap:

```bash
$ sudo apt install snapd
```

Restart the system and install the Snap Store:

```bash
$ sudo snap install snap-store
```

Install Lepton through the Snap Store.

<span class="info-source">Source: [https://snapcraft.io/docs/installing-snap-store-app](https://snapcraft.io/docs/installing-snap-store-app)</span>

## Config

The `.leptonrc` config file is usually created on `~/` but, when installing as a snap, we need to place it in `~/snap/lepton/current` instead.

For now, I'm using the following configuration. I'd like to use the dark theme, but I think the light theme is more readable as of now.

```json
{
  "theme": "light",
  "snippet": {
    "expanded": false,
    "newSnippetPrivate": true
  }
}
```

## Note on Mac and Windows

On Mac and Windows, it's pretty much usual installation. It's just that the developer is not registered as a verified developer on both platforms, so it's necessary to ignore the warnings and proceed with the installation anyway.


# Linux - Pop!_OS

For my personal projects, especially Docker related, I mainly use Linux on a virtual machine on a Windows 10 host.

My current distro of choice is Pop!_OS and this section contains some installation notes and my after installation steps.

I used to use Ubuntu, but have recently switched to Pop!_OS. Although it uses Ubuntu as the base distribution, for some reason, it feels snappier than its parent. I also like its default aesthetics, so I'm mostly OK with of the default installation while on Ubuntu I tend to spend some time customizing stuff.

## On the Laptop

I use my laptop less frequently than my desktop, but I decided to install Pop_OS! on it as well, keeping a dual-boot configuration with Windows 10.

In the official instruction below, Windows is installed after Pop_OS!. As my laptop was almost at a clear-install state, I decided to follow these instructions as-is.

[https://support.system76.com/articles/dual-booting/](https://support.system76.com/articles/dual-booting/)

After both Pop_OS! and Windows 10 were installed, the system was booting Windows by default. I accessed the BIOS and switched the Pop_OS! UEFI entry to be the default. After that, the system started booting Pop_OS!, but no boot menu was shown so I could select the OS to boot.

[https://medium.com/@mijorus/deal-with-the-new-systemd-boot-and-set-a-default-windows-entry-be1814a0c975](https://medium.com/@mijorus/deal-with-the-new-systemd-boot-and-set-a-default-windows-entry-be1814a0c975)

Following the article above, I just added a `timeout` configuration to the `systemd-boot` config file `/boot/efi/loader/loader.conf`:

```
# add the following line to the file (timeout in seconds)
timeout 3
```

### Virtual Machines

I was first planning to use my laptop directly, but I end up not using it as much as I could. So, I decided to use as a experimentation server on my home network. I'm using it with the LID closed on a vertical laptop stand so it doesn't take too much space in my desk.

I know it's a bit of a waste of resources, but I've kept the original Pop_OS! installation, just for convenience. I've just enabled SSH by installing the corresponding metapackage:

```bash
$ sudo apt install ssh

# check it's running
$ sudo systemctl status ssh
```

My main goal is to use this laptop to run virtual machines. Although it's a couple of years old and not particularly powerful, it's decent enough and supports hardware virtualization, so I was interested in running a virtualization management platform on it, such as oVirt and Proxmox.

But, then I realized they either target specific distributions or are supposed to be installed as complete distributions. This is not a problem and I may try them in the future but, after a bit more research, I know there are other alternatives.

Because I currently know almost nothing about KVM, it may be a good idea to try managing my virtual machines through the command-line as suggested by some people when dealing with small scale installations such as mine. If a GUI is desirable, using something simpler such as "virt-manager" may be interesting, although it will be deprecated in favor of "Cockpit".

Although "Cockpit" scope is quite different, I may be interesting to play with it next as it is distribution agnostic and supports managing virtual machines as well. Experimenting with its server management features should be a good learning experience as well.

## Small stuff

1. Monospace font changed to "Noto Mono Regular 10"

## Customization

System76 has a good article about customizing the Desktop environment:

[https://support.system76.com/articles/customize-gnome/](https://support.system76.com/articles/customize-gnome/)

## Software

Install:

* Google Chrome
* Visual Studio Code
* Meld

## VMware Tools

I use VMware to run my VM, so the first thing I do is installing VMware Tools.

1. Go to Player > Manage > Install VMware Tools... the necessary files are recognized as a CDROM that is automatically mounted under `/media/<username>/VMware Tools`

2. Copy the necessary archive somewhere you can access and extract it:

    ```bash
    $ cp /media/<username>/VMware\ Tools/VMwareTools-<version>.tar.gz ~/Downloads/
    $ cd ~/Downloads
    $ tar -zxvf VMwareTools-<version>.tar.gz
    ```

3. Build it:

    ```bash
    $ cd vmware-tools-distrib
    $ sudo ./vmware-install.pl
    ```

4. Accept all the default prompts. Restart after the finish.

<span class="info-source">Source: [https://kb.vmware.com/s/article/1018414](https://kb.vmware.com/s/article/1018414)</span>

## Docker

Just follow the link below as it's quite straightforward:

[https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

Make the necessary configuration to run Docker commands without `sudo`:

[https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

Then install Docker Compose following:

[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Troubleshooting

### Disable Tap to Click on Logitech K400 Plus

This keyboard with a built-in trackpad works great overall, but I've had problems with its touchpad on Linux. First, its touchpad is recognized as a mouse. At least, on Pop_OS!, I needed to change my mouse settings to affect its behavior, instead of changing my touchpad settings. The tracking is not particularly great (not sure if due to the hardware or driver compatibility), but I feel things improved a bit after tweaking the mouse speed, enabling natural scrolling and disabling mouse acceleration.

Another problem was that I could not find any way to disable the tap-to-click. I tend to hate tap-to-click functionality as I get more prone to making mistakes and, in this case of this keyboard, I feel it's even less necessary than usual because this has an exclusive left-click button in the top left corner that I find super comfortable to use. After researching a little bit about it, I found the article below:

https://askubuntu.com/questions/227373/how-do-i-turn-off-tap-to-click-for-logitech-k400r-wireless-keyboard-with-touchpa

In summary, we can disable tap-to-click functionality by simply doing:

`Fn + Left-Click`

After doing so, it's been great to use this keyboard. It also disable right-click on two-finger tap functionality what used to activate by mistake when I was doing two-finger scrolling.
