#!/usr/bin/env bash

# Install Ansible dependencies.

apt -y update && apt-get -y upgrade
apt -y install python-pip python-dev

# Install Ansible.

if [ ! -z "${ANSIBLE_VERSION}" ]; then
    ANSIBLE_VERSION_PARAMETER="=${ANSIBLE_VERSION}"
fi
pip install ansible${ANSIBLE_VERSION_PARAMETER}
