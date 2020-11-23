---
layout: post
title:  "Provisioning KVM Virtual Machines with Cloud Init"
date:   2020-11-08 09:11:39 +0900
---

<h4>Table of Contents</h4>
* TOC
{:toc}

# KVM Provisioning with cloud-init

# To-Do

- write the Introduction

# Introduction


# Requirement

Have installed KVM following kvm_with_cockpit.md or similar guide.

# Guide

## Install Required Packages

We first needd to install `cloud-image-utils`. This is needed to provision the client OS in the first boot.

```bash
$ sudo apt install cloud-image-utils
```

## Download the Ubuntu Cloud Image

Ubuntu provides their cloud images at https://cloud-images.ubuntu.com/. In my case, I chose to use Bionic 18.04 LTS. I've created a `cloud_images` folder inside `~/Downloads` to store such files:

```bash
~/Downloads/cloud_images$ wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
```

## Verifying the Downloaded Image

To make sure the image is not corrupted nor has been tampered with, let's execute the steps below. We use `gpg` to verify the image's authenticity and `sha256` to verify its integrity. The necessary tools are installed by default on Pop_OS! I'm using. For other cases, you can check https://ubuntu.com/tutorials/how-to-verify-ubuntu#2-necessary-software.

But first, also download both the `SHA256SUMS` and `SHA256SUMS.gpg` files to the same folder. Then:

```bash
# check if we need to download the public key used to authenticate the checksum file:
$ gpg --keyid-format long --verify SHA256SUMS.gpg SHA256SUMS
```

For me, it returned something like:

```
gpg: Signature made <date and time>...
gpg:                using RSA key <key ID>
gpg: Can't check signature: No public key
```

From this message, we know the ID of the key we need to request to the Ubuntu key server:

```bash
$ gpg --keyid-format long --keyserver hkp://keyserver.ubuntu.com --recv-keys <key ID>
```

This command should report that the key was imported, what means that it was retrieved and added to the keyring. Now, we can inspect the key fingerprints:

```bash
$ gpg --keyid-format long --list-keys --with-fingerprint 0x<key ID>
```

It should display the key used to sign Ubuntu Cloud Images checksums. We can now verify the checksum file using the signature:

```bash
$ gpg --keyid-format long --verify SHA256SUMS.gpg SHA256SUMS
```

This returned the following line in the output:

```bash
gpg: Good signature from "UEC Image Automatic Signing Key <cdimage@ubuntu.com>" [unknown]
```

A `Good signature` means the checksum file was indeed created by Ubuntu. So, now we can check that the image's sha256 checksum matches the downloaded checksum:

```bash
$ sha256sum -c SHA256SUMS 2>&1 | grep OK
```

An output like the following indicates the ISO file matches the checksum and should be used without problems.

```
bionic-server-cloudimg-amd64.img: OK
```

# Branch from the Downloaded Image

We can get the details of the image we just downloaded with the command below:

```bash
$ qemu-img info bionic-server-cloudimg-amd64.img

# Output
image: bionic-server-cloudimg-amd64.img
file format: qcow2
virtual size: 2.2 GiB (2361393152 bytes)
disk size: 343 MiB
cluster_size: 65536
Format specific information:
    compat: 0.10
    refcount bits: 16
```

As we can see, the downloaded image is way too small for any practical purpose, so let's create a new 20GB image based on the downloaded one:

```bash
$ qemu-img create -f qcow2 -F qcow2 -b bionic-server-cloudimg-amd64.img  vm_0001-bionic-server-cloudimg-amd64.qcow2 20G
$ qemu-img info vm_0001-bionic-server-cloudimg-amd64.qcow2

# Output
image: vm_0001-bionic-server-cloudimg-amd64.qcow2
file format: qcow2
virtual size: 20 GiB (21474836480 bytes)
disk size: 196 KiB
cluster_size: 65536
backing file: bionic-server-cloudimg-amd64.img
Format specific information:
    compat: 1.1
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
```

> Note: we could have also made a copy of the downloaded image and resized with `qemu-img resize vm_0001-bionic-server-cloudimg-amd64.qcow2 20G`

# Create the Provisioning Configuration

Now, we are going to create the `cloud-init` configuration to be used in the guest provisioning. Let's first create a `user-data` file containing the content below. The `meta-data` file may be used in the future but, for now, let's keep it empty.

```bash
$ mkdir cloud-init
$ cd cloud-init
$ touch user-data
$ touch meta-data
```

```yml
#cloud-config

hostname: vm_0001
fqdn: vm_0001.localdomain
manage_etc_hosts: true

ssh_pwauth: false
disable_root: true

users:
  - name: ubuntu
    home: /home/ubuntu
    shell: /bin/bash
    groups: sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh-authorized-keys:
      - <SSH public key>
```

The `<SSH public key>` needs to be replaced accordingly.

For networking, we create a file called `network-config`. This is an example for a fixed IP configuration:

```yml
version: 2
ethernets:
  enp1s0:
     dhcp4: false
     addresses:
     - 192.168.122.100/24
     gateway4: 192.168.122.1
     nameservers:
       addresses:
       - 192.168.122.1
       - 8.8.8.8
```

In my case, I've used the dynamic IP configuration below:

```yml
version: 2
ethernets:
  enp1s0:
     dhcp4: true
```

> I had named the interface `ens1`, but the guest VM was not able to have an IP address assigned when started. In these failed VM starts, network information was displayed during the boot and I noticed the interface was being identified as `enp1s0`. So, I've changed the interface name in the `network-config` file and the guests started getting IP addresses from the DHCP server.

Let's now create a disk image containing the provisioning configuration. This is where the `cloud-image-utils` package is used.

```bash
$ cloud-localds -v --network-config=network-config cloud-init-provisioning.qcow2 user-data meta-data
```

> One of the tutorials uses `genisoimage` instead of `cloud-localds`

# Bridge Networking

Before creating a new virtual machine, we are going to create a network bridge on the host first. This will allow our virtual machines to connect to the local network directly and become visible in this context. Let's first install the necessary dependency:

```bash
$ sudo apt install bridge-utils
```

Next, let's edit the `/etc/network/interfaces` file that was originally like this:

```
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d
```

Add the following lines after the existing content:

```
auto lo
iface lo inet loopback

auto br0
iface br0 inet dhcp
        bridge_ports enp6s0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
```

In my case, I opted for DHCP as I've reserved my host IP address in the router. Also, `bridge_ports` need to be replaced accordingly (in my case, the ethernet interface on the host is `enp6s0`).

Now, we just need to restart networking:

```bash
$ sudo /etc/init.d/networking restart
```

> Just by restarting the network, my ethernet adapter was still showing up with an IP address assigned. So, I restarted the host and only the bridge is visible now, as it is supposed to be.

# Creating a New Virtual Machine

Now, we can create the new virtual machine:

```bash
$ virt-install \
  --name vm_0001 \
  --virt-type kvm \
  --vcpus 2 \
  --memory 2048 \
  --disk path=cloud_images/vm_0001-bionic-server-cloudimg-amd64.qcow2,device=disk \
  --disk path=cloud-init/cloud-init-provisioning.qcow2,device=cdrom \
  --os-type Linux \
  --os-variant ubuntu18.04 \
  --graphics none \
  --network bridge=br0 \
  --import
```

The machine will start its initialization process until it reaches the login prompt. According to our configuration, we are supposed to access the guest through SSH and no user is allowed shell access to it. We can go back to our shell with the `Ctrl + ]` key combination.

In my case, my KVM host is not my main desktop, so the guest is on a separate machine, but accessing it from my desktop should not be a problem since the guest is using bridge networking. Since I set the SSH public key from my desktop in the cloud-init provisioning configuration, I can access the newly created guest with:

```bash
$ ssh ubuntu@<ip address of the guest>
```

We can discover the IP address of the guest during its boot process when network information is displayed. But, as far as I know, the only way to check the IP address assigned to the guest afterwards is to check the list of DHCP clienst on my router's admin screen. So, in this case, it's probably a better idea to set a static IP address for the guest or, maybe, fix the guest's IP address in the router. The article below mentions the same limitation:

https://levelup.gitconnected.com/how-to-setup-bridge-networking-with-kvm-on-ubuntu-20-04-9c560b3e3991

Lastly, we can check some output generated by cloud-init in the following files:

* /run/cloud-init/result.json
* /var/log/cloud-init.log
* /var/log/cloud-init-output.log

# Clean Up

cloud-init is setup to run everytime the machine starts and it can be left this way if we want to enforce those settings. If that's not the case, we can disable cloud-init.

```bash
# this file disables cloud-init execution
$ sudo touch /etc/cloud/cloud-init.disabled

# alternatively, we could remove the cloud-init package
```

# References

https://ubuntu.com/tutorials/how-to-verify-ubuntu#1-overview
https://fabianlee.org/2020/02/23/kvm-testing-cloud-init-locally-using-kvm-for-an-ubuntu-cloud-image/
https://stafwag.github.io/blog/blog/2019/03/03/howto-use-centos-cloud-images-with-cloud-init/
https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8
https://medium.com/@yping88/use-ubuntu-server-20-04-cloud-image-to-create-a-kvm-virtual-machine-with-fixed-network-properties-62ecae025f6c
https://help.ubuntu.com/community/KVM/Networking#Creating_a_network_bridge_on_the_host

# Additional Information

## cloud-init

https://www.digitalocean.com/community/tutorials/an-introduction-to-cloud-config-scripting
