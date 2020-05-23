#!/usr/bin/env bash

# Commands for yum-based systems:  CentOS, Red Hat, etc.

if [ -n "$(command -v yum)" ]; then

    # Install Python.

    yum -y install python3 python3-pip
    alternatives --set python /usr/bin/python3

    # Install Ansible.

    if [ ! -z "${ANSIBLE_VERSION}" ]; then
        ANSIBLE_VERSION_PARAMETER="==${ANSIBLE_VERSION}"
    fi
    pip3 install ansible${ANSIBLE_VERSION_PARAMETER}

# Commands for apt-based systems: Debian, Ubuntu, etc.

elif [ -n "$(command -v apt-get)" ]; then

    # Install Ansible repository.

    apt -y update && apt-get -y upgrade
    apt -y install software-properties-common
    apt-add-repository ppa:ansible/ansible
    apt -y update

    # Install Ansible.

    if [ ! -z "${ANSIBLE_VERSION}" ]; then
        ANSIBLE_VERSION_PARAMETER="=${ANSIBLE_VERSION}"
    fi
    apt -y install ansible${ANSIBLE_VERSION_PARAMETER}

fi
