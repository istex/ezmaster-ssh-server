#!/bin/bash

# READING CONFIG FILE
cd /app
bash ./parse-config.sh
if [[ -f "config.env" ]];
then
    . config.env
    echo "config.env parsed, using the folling parameters :"
    cat config.env
else
    echo "cannot read config.env file"
fi

    echo "${SSHSERVER_AUTHORIZED_KEYS}" > /etc/ssh/authorized_keys
    mkdir -p /root/.ssh
    echo "${SSHSERVER_AUTHORIZED_KEYS}" > /root/.ssh/authorized_keys
    echo "file authorized_keys written"

if [[ ! -f "/etc/ssh/ssh_host_key" ]]; then

    # GENERATE SSH KEYS
    echo "root:${SSHSERVER_ROOT_PASSWORD}" | chpasswd
    sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
    sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config
    sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config
    sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config
    sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config
    sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config

    /usr/bin/ssh-keygen -A
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key -N "${SSHSERVER_SSH_PASSPHRASE}"
    chmod 1777 /data
fi 

# STARTING HTTP and SSH SERVERS
cd /www && python -m SimpleHTTPServer 80 &

echo "starting ssh server..."
exec /usr/sbin/sshd -D
