#!/usr/bin/env bash

# Commands for yum-based systems:  CentOS, Red Hat, etc.

if [ -n "$(command -v yum)" ]; then

    # Remove Ansible and its dependencies.

    pip3 install pip-autoremove
    ln -s /usr/bin/pip3 /usr/bin/pip
    /usr/local/bin/pip-autoremove ansible -y

    rm -f /usr/bin/pip
    pip3 uninstall pip-autoremove -y

    # Zero out the rest of the free space using dd, then delete the written file.

    echo "Writing zeroes to free space (this could take a while)."
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY

    # Add `sync` so Packer doesn't quit too early, before the large file is deleted.

    sync

# Commands for apt-based systems: Debian, Ubuntu, etc.

elif [ -n "$(command -v apt-get)" ]; then

    # Uninstall Ansible and remove PPA.

    apt -y remove --purge ansible
    apt-add-repository --remove ppa:ansible/ansible

    # Apt cleanup.

    apt autoremove
    apt update

    # Delete unneeded files.

    rm -f /home/vagrant/*.sh

    # Zero out the rest of the free space using dd, then delete the written file.

    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY

    # Add `sync` so Packer doesn't quit too early, before the large file is deleted.

    sync

fi
