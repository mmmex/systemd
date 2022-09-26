#!/bin/bash
#
FIRST_PID=/var/run/httpd/httpd-first.pid
FIRST_LISTEN=8080
#FIRST_SERVERNAME=first.local

SECOND_PID=/var/run/httpd/httpd-second.pid
SECOND_LISTEN=8081
#SECOND_SERVERNAME=second.local

cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service
sed '/^Description/ s/$/ %I/' -i /usr/lib/systemd/system/httpd@.service
sed '/^EnvironmentFile/ s/$/-%I/' -i /usr/lib/systemd/system/httpd@.service

cat >/etc/sysconfig/httpd-first<<__EOF
OPTIONS=-f conf/first.conf
__EOF

cat >/etc/sysconfig/httpd-second<<__EOF
OPTIONS=-f conf/second.conf
__EOF

cat >/etc/httpd/conf/first.conf<<__EOF
PidFile $FIRST_PID
Listen $FIRST_LISTEN
__EOF

cat >/etc/httpd/conf/second.conf<<__EOF
PidFile $SECOND_PID
Listen $SECOND_LISTEN
__EOF

systemctl daemon-reload