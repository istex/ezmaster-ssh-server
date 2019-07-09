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

# GENERATE SSH KEYS
echo "root:${SSHSERVER_PASSWORD}" | chpasswd
sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config
sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config
sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config
sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config
sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config

/usr/bin/ssh-keygen -A
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key


chmod 1777 /data

# STARTING HTTP and SSH SERVERS
cd /www && python -m SimpleHTTPServer 80 &
exec /usr/sbin/sshd -D -d