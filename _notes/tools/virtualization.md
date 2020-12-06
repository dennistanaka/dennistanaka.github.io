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

<span class="info-source">Source: <https://stackoverflow.com/questions/11659005/how-to-resize-a-virtualbox-vmdk-file></span>

## Identify Underlying Hypervisor

```bash
$ systemd-detect-virt
kvm

# or

$ sudo lshw -class system
<machine_name>
    description: Computer
    product: Standard PC (Q35 + ICH9, 2009)
    vendor: QEMU
    version: pc-q35-4.2
    width: 64 bits
    capabilities: smbios-2.8 dmi-2.8 smp vsyscall32
    configuration: boot=normal uuid=...

# or

$ hostnamectl status
   Static hostname: <machine_name>
         Icon name: computer-vm
           Chassis: vm
        Machine ID: ...
           Boot ID: ...
    Virtualization: kvm
  Operating System: Ubuntu 18.04.5 LTS
            Kernel: Linux 4.15.0-123-generic
      Architecture: x86-64
```

<span class="info-source">Source: <https://unix.stackexchange.com/questions/89714/easy-way-to-determine-virtualization-technology></span>
