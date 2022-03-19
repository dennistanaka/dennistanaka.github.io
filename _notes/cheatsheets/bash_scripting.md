---
menu_title: Bash Scripting
title: Cheat Sheets - Bash Scripting
permalink: /notes/cheatsheets/bash_scripting/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

# set

`set` options causes scripts to fail explicitly, preventing bugs to become hidden and difficult to find out.

We can specify them one by one:

```bash
set -e
set -u
set -o pipefail
set -x
```

Or use the short version:

```bash
set -euxo pipefail
```

- `set -e`: option instructs bash to immediately exit if any command has a non-zero exit status
- `set -x`: makes all executed commands to be printed to the terminal
- `set -u`: causes the program to exit if a variable not previously defined is referenced
- `set -o pipefail`: the return code of the failed command will be returned if any command in the pipeline fails

Example:

```bash
#!/bin/bash

set -u

if [ -z "$variable" ]; then
  echo "[Error] Variable is not set"
  exit 1
fi

# This prints
# script.sh: line 5: variable: unbound variable
# instead of [Error] Variable is not set
```

<span class="info-source">References:</span>
- <span class="info-source"><https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425></span>
- <span class="info-source"><https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed></span>

# Trap

Catch signals sent to our processes. For example, we can handle `ERR` signals representing non-zero exit status from a command:

```bash
trap 'echo "Error in line $LINENO. Command exited with $? status" >&2; exit 1' ERR
```

<span class="info-source">Reference: <https://developer.ibm.com/articles/au-usingtraps/></span>

# Return Code

We can get the return code of a command by referencing `$?` after that:

```bash
$ date
$ echo $?
# or
$ return_code=$?
```

# Command Substitution

To store the output of a command in a variable:

```bash
variable=$(command)
# or
variable=`command`
```

Detailed explanation below:

<span class="info-source"><https://linuxhint.com/bash_command_output_variable/></span>

# Operators

Information about details such as operators are one `man sh` away. Or we can also check this
[The Linux Documentation Project](https://tldp.org/LDP/abs/html/comparison-ops.html) page for that.

# Brackets

Regarding brackets, one of the answers to this [StackOverflow thread](https://stackoverflow.com/questions/31255699/double-parenthesis-with-and-without-dollar/31255942):

> [..] is used in conditions or logical expressions.

All the variations in the usage of brackets, parenthesis, curly braces are still confusing to me. So, I will keep trying to understand those using the above and following sources:

- <span class="info-source"><https://dev.to/rpalo/bash-brackets-quick-reference-4eh6></span>
- <span class="info-source"><https://stackoverflow.com/questions/2188199/how-to-use-double-or-single-brackets-parentheses-curly-braces></span>
- <span class="info-source"><https://stackoverflow.com/questions/12063692/vs-in-bash-shell></span>
- <span class="info-source"><https://stackoverflow.com/questions/8748831/when-do-we-need-curly-braces-around-shell-variables></span>

# Quotes

Quotes are another confusing topic to me and this [StackOverflow thread](https://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash) discuss about those.

# Error Redirection

The `>&2` in `echo "Error: Argument for $1 is missing" >&2` is simply directing the message to the `stderr` istead of `stdout`. As explained in this [Ask Ubuntu thread](https://askubuntu.com/questions/1182450/what-does-2-mean-in-a-shell-script), the idea is that:

> Most people don't bother redirecting echo error messages to >&2 but it is technically the correct way of doing things.

<span class="info-source">Reference: <https://stackoverflow.com/questions/23489934/echo-2-some-text-what-does-it-mean-in-shell-scripting></span>

# Casing

I use lowercase variable names as this is how those were usually presented in the tutorials I've checked. But, I was not that confident as I've also found a lot of examples using uppercase. I've decided to stick to this pattern after checking the discussion in this [StackOverflow thread](https://stackoverflow.com/questions/673055/correct-bash-and-shell-script-variable-capitalization).

# Named Arguments - KVM VM Creation

I've created this script to automate the creation of KVM VMs. The process that is being automated is descripted in [my blog post](/2020/11/08/kvm_provisioning_with_cloud-init.html).
This script is completely based on the article in the [**Source**](https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f) and I used this to learn a little bit about the basics of Bash scripting.

## Note on Other Options

There are other options to handle named arguments, but they have limitations.

`getopt` supports long arguments (`--arg value`), but not in BSD/macOS. `getopts` is portable, but it only support short-arguments (`-a value`). There's a workaround to make `getopts` handle long arguments what is OK.

<span class="info-source">References:</span>
- <span class="info-source"><https://www.reddit.com/r/bash/comments/jkblav/double_dash_parameters_in_bash_script/></span>
- <span class="info-source"><https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options></span>

## Original Script

```bash
#!/bin/bash

PARAMS=""

while (( "$#" )); do
  case "$1" in
    -a|--my-boolean-flag)
      MY_FLAG=0
      shift
      ;;
    -b|--my-flag-with-argument)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"
```

## Modified Script

```bash
#!/bin/bash

while (( "$#" )); do
  case "$1" in
    --vm-name)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        vm_name=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --disk-size)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        disk_size=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --ip-address)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ip_address=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *|-*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

echo "Initializing creation of a new virtual machine with the following attributes:"
echo "Name: $vm_name"
echo "Disk Size: $disk_size"
echo "IP Address: $ip_address"
```

This script can be executed as below:

```bash
$ bash provision.sh --vm-name test --ip-address 192.168.1.10 --disk-size 20G
```

## Details

### Iterating through Arguments

The loop below goes through each of the arguments in the command

```bash
while (( "$#" )); do
  ...
done
```

From one response to this [StackOverflow thread](https://stackoverflow.com/questions/42677433/what-does-while-do-shift-done-mean-in-bash-and-why-would-someone-u):

> So this loop is executed until every positional parameter has been processed; (($#)) is true if there is at least one positional parameter.

Each named parameter is handled by a case block such as the below:

```bash
    --vm-name)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        vm_name=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
```

<span class="info-source">Reference: <https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash></span>

### Substring Expansion

`${2:0:1}` is simple, just a substring expansion with the `${parameter:offset:length}` format, as explained in this  [StackExchange thread](https://unix.stackexchange.com/questions/275649/what-does-102-mean-in-this-context).

## Final Script

And finally, this is the final version of the script. It fits my use case, but may need modifications for other uses.

```bash
#!/bin/bash

while (( "$#" )); do
  case "$1" in
    --vm-name)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        vm_name=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --disk-size)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        disk_size=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --ip-address)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ip_address=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --vm-cpus)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        vm_cpus=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --vm-ram)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        vm_ram=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *|-*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

echo "Initializing creation of a new virtual machine with the following attributes:"
echo "Name: $vm_name"
echo "Disk Size: $disk_size"
echo "IP Address: $ip_address"
echo "CPUs: $vm_cpus"
echo "RAM: ${vm_ram}MB"

original_cloud_image="bionic-server-cloudimg-amd64.img"
vm_disk_filename="${vm_name}-bionic-server-cloudimg-amd64.qcow2"

echo "Branching from the Original Cloud Image..."
echo "Original Cloud image: $original_cloud_image"
echo "VM Disk Filename: $vm_disk_filename"
qemu-img create -f qcow2 -F qcow2 -b $original_cloud_image cloud_images/${vm_disk_filename} ${disk_size}

user_data_filename=${vm_name}-user-data

echo "Creating the user-data configuration for the cloud-init provisioning..."
cat > cloud-init/${user_data_filename} << EOF
#cloud-config

hostname: ${vm_name}
fqdn: ${vm_name}.localdomain
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
      - <ssh-public-key-1>
      - <ssh-public-key-2>
EOF

network_config_filename=${vm_name}-network-config

echo "Creating the network configuration for the cloud-init provisioning..."
cat > cloud-init/${network_config_filename} << EOF
version: 2
ethernets:
  enp1s0:
    dhcp4: false
    addresses:
    - ${ip_address}/24
    gateway4: <router-ip-address>
    nameservers:
      addresses:
      - <router-ip-address>
EOF

provisioning_disk_image=${vm_name}-cloud-init-provisioning.qcow2

echo "Create the cloud-init configuration disk image to be attached to the virtual machine..."
cloud-localds -v --network-config=cloud-init/${network_config_filename} cloud-init/${provisioning_disk_image} cloud-init/${user_data_filename} cloud-init/meta-data

echo "Create and boot the new virtual machine..."
virt-install \
--name ${vm_name} \
--virt-type kvm \
--vcpus ${vm_cpus} \
--memory ${vm_ram} \
--disk path=cloud_images/${vm_disk_filename},device=disk \
--disk path=cloud-init/${provisioning_disk_image},device=cdrom \
--os-type Linux \
--os-variant ubuntu18.04 \
--graphics none \
--network bridge=br0 \
--import
```

We can now use the script like below and the VM will be ready to be accessed through SSH.

```bash
$ bash provision.sh --vm-name test001 --ip-address 192.168.1.10 --disk-size 20G --vm-cpus 1 --vm-ram 1024
```

# References

* <span class="info-source"><https://www.gnu.org/software/bash/manual/html_node/></span>
* <span class="info-source"><https://linuxconfig.org/bash-scripting-tutorial-for-beginners></span>
* <span class="info-source"><https://linuxconfig.org/bash-scripting-tutorial></span>
* <span class="info-source"><https://www.taniarascia.com/how-to-create-and-use-bash-scripts/></span>
* <span class="info-source"><https://flaviocopes.com/bash-scripting/></span>
* <span class="info-source"><https://www.codecademy.com/learn/learn-the-command-line/modules/bash-scripting></span>
