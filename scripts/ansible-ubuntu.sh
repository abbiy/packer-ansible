#!/usr/bin/env bash

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
