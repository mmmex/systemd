#!/bin/bash

yum install -y epel-release
yum install -y spawn-fcgi php php-cli mod_fcgid httpd

sed '/#[SOCKET,OPTIONS]/s/^#//' -i /etc/sysconfig/spawn-fcgi

cat >/etc/systemd/system/spawn-fcgi.service<<__EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
__EOF

systemctl daemon-reload
systemctl start spawn-fcgi