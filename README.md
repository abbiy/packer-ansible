# packer-senzing-demo-kafka-postgres

## Overview

This repository uses [Packer](https://www.packer.io/) to build a virtual machines for
VMware, VirtualBox, or AWS AMI.

The virtual machines have the following installed:

- [Senzing API Server](https://github.com/Senzing/senzing-api-server)
- [Senzing Entity Search webapp](https://github.com/Senzing/entity-search-web-app)

### Contents

1. [Expectations](#expectations)
1. [Build dependencies](#build-dependencies)
1. [Build](#build)
    1. [amazon-ebs preparation](#amazon-ebs-preparation)
    1. [Build all versions](#build-all-versions)
    1. [Build specific version](#build-specific-version)
1. [Run on VMware Workstation](#run-on-vmware-workstation)
1. [Run on Vagrant / VirtualBox](#run-on-vagrant--virtualbox)
    1. [Add to library](#add-to-library)
    1. [Run](#run)
    1. [Login to guest machine](#login-to-guest-machine)
    1. [Find guest machine IP address](#find-guest-machine-ip-address)
    1. [Remote login to guest machine](#remote-login-to-guest-machine)
    1. [Remove image from Vagrant library](#remove-image-from-vagrant-library)
1. [References](#references)

#### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 2 hours minutes to create the virtual machine.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Packer](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/packer.md)

## Build dependencies

See [build dependencies](https://github.com/docktermj/KnowledgeBase/blob/master/build-dependencies/packer.md).

## Build

Use `make help` to see targets.

### amazon-ebs preparation

#### Install aws cli

:thinking: **Optional:** The following instructions show how to install the `aws` command line interface.

1. [Installing the AWS CLI version 2 on Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)

#### Create AWS access key

An AWS access key is needed by Packer to access the account.
This information is usually kept in `~/.aws/credentials`
and is accessed by the Packer `amazon-ebs` builder.

1. Create [Access keys for CLI, SDK, & API access](https://console.aws.amazon.com/iam/home?#/security_credentials).

1. **Method #1:** Use the `aws` command line interface to create `~/.aws/credentials`.
   Supply the information when prompted.
   Example:

    ```console
    $ aws configure

    AWS Access Key ID:
    AWS Secret Access Key:
    Default region name [us-east-1]:
    Default output format [json]:
    ```

1. **Method #2:** :pencil2: Manually create a `~/.aws/credentials` file.
   Example:

    ```console
    mkdir ~/.aws

    cat <<EOT > ~/.aws/credentials
    [default]
    aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
    aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    EOT

    chmod 770 ~/.aws
    chmod 750 ~/.aws/credentials
    ```

1. References:
    1. Packer [using AWS authentication](https://www.packer.io/docs/builders/amazon/#authentication)

### Build all versions

```console
make all
```

### Build specific version

VMware

```console
make vmware-iso
```

VirtualBox

```console
make virtualbox-iso
```

## Run on VMware Workstation

1. Choose VMX file
    1. VMware Workstation > File > Open...
        1. Navigate to `.../output-vmware-iso-nnnnnnnnnn/`
        1. Choose `packer-senzing-xxxxxx-nnnnnnnnnn.vmx`
1. Optional: Change networking
    1. Navigate to VMware Workstation > My Computer > packer-senzing-xxxxx-nnnnnnnnnn
    1. Right click on "packer-senzing-xxxxxx-nnnnnnnnnn" and choose "Settings"
    1. Choose "Network Adapter" > "Network Connection" > :radio_button: Bridged: Connected directly to the physical network
    1. Click "Save"
1. Run image
    1. Choose VMware Workstation > My Computer > packer-senzing-xxxxx-nnnnnnnnnn
    1. Click "Start up this guest operating system"
1. Username: vagrant  Password: vagrant

## Run on Vagrant / VirtualBox

### Add to library

1. :pencil2: Identify virtual image metadata.
   Example:

    ```console
    export VAGRANT_NAME=packer-centos-virtualbox
    export VIRTUALBOX_FILE=./packer-centos-18.04-virtualbox-nnnnnnnnnn.box
    ```

1. Add VirtualBox image to `vagrant`
   Example:

    ```console
    vagrant box add --name=${VAGRANT_NAME} ${VIRTUALBOX_FILE}
    ```

### Run

An example of how to run in a new directory.

#### Specify directory

In this example the `/tmp/packer-ubuntu-18.04` directory is used.

```console
export VAGRANT_DIR=/tmp/${VAGRANT_NAME}
```

#### Initialize directory

Back up an old directory and initialize new directory with Vagrant image.

```console
mv ${VAGRANT_DIR} ${VAGRANT_DIR}.$(date +%s)
mkdir ${VAGRANT_DIR}
cd ${VAGRANT_DIR}
vagrant init ${VAGRANT_NAME}
```

#### Enable remote login

Modify Vagrantfile to allow remote login by
uncommenting `config.vm.network` in `${VAGRANT_DIR}/Vagrantfile`.
Example:

```console
sed -i.$(date +'%s') \
  -e 's/# config.vm.network \"public_network\"/config.vm.network \"public_network\"/g' \
  ${VAGRANT_DIR}/Vagrantfile
```

#### Start guest machine

```console
cd ${VAGRANT_DIR}
vagrant up
```

### Login to guest machine

```console
cd ${VAGRANT_DIR}
vagrant ssh
```

### Find guest machine IP address

In the vagrant machine, find the IP address.

```console
ip addr show
```

### Remote login to guest machine

SSH login from a remote machine.

```console
ssh vagrant@nn.nn.nn.nn
```

Password: vagrant

### Remove image from Vagrant library

To remove Vagrant image, on host machine:

```console
vagrant box remove ${VAGRANT_NAME}
```

## References

1. [Build dependencies](https://github.com/docktermj/KnowledgeBase/blob/master/build-dependencies/packer.md).
1. [Bibliography](https://github.com/docktermj/KnowledgeBase/blob/master/bibliography/packer.md)
