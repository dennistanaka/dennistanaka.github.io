---
menu_title: Virtualization
title: Tools - Virtualization
permalink: /notes/tools/virtualization/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Resize VM Disk

This was required when I was using Vagrant to create Ubuntu virtual machines and the original disk space was not enough. Before running the commands below, we need to dettach the disk from the corresponding virtual machine and take note on the controller being used to be able to reattach the disk later.

The disk had *.vmdk file format what is not compatible with the resizing command below, so it was necessary to convert it to *.vdi first. After the resizing, the disk was converted back to the original format.

```bash
$ VBoxManage clonemedium disk "ubuntu-bionic-18.04-cloudimg.vmdk" "ubuntu-bionic-18.04-cloudimg.vdi" --format vdi
$ VBoxManage modifymedium disk "ubuntu-bionic-18.04-cloudimg.vdi" --resize 25600
$ mv ubuntu-bionic-18.04-cloudimg.vmdk ubuntu-bionic-18.04-cloudimg-copy.vmdk
$ VBoxManage clonemedium disk "ubuntu-bionic-18.04-cloudimg.vdi" "ubuntu-bionic-18.04-cloudimg.vmdk" --format vmdk
$ rm ubuntu-bionic-18.04-cloudimg-copy.vmdk ubuntu-bionic-18.04-cloudimg.vdi
```

<span class="info-source">Source: [https://stackoverflow.com/questions/11659005/how-to-resize-a-virtualbox-vmdk-file](https://stackoverflow.com/questions/11659005/how-to-resize-a-virtualbox-vmdk-file)</span>
