#!/usr/bin/env bash

# Install Python.

yum -y install python3 python3-pip
alternatives --set python /usr/bin/python3

# Install Ansible.

if [ ! -z "${ANSIBLE_VERSION}" ]; then
    ANSIBLE_VERSION_PARAMETER="==${ANSIBLE_VERSION}"
fi
pip3 install ansible${ANSIBLE_VERSION_PARAMETER}
