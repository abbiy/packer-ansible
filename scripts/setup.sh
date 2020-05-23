#!/usr/bin/env bash

# Commands for yum-based systems:  CentOS, Red Hat, etc.

if [ -n "$(command -v yum)" ]; then

  echo "YUM based - nothing to do"

# Commands for apt-based systems: Debian, Ubuntu, etc.

elif [ -n "$(command -v apt-get)" ]; then

    # Add vagrant user to sudoers.

    echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
    sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

    # Disable daily apt unattended updates.

    echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

fi
