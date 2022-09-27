#!/bin/bash
#
FIRST_PID=/var/run/httpd/httpd-first.pid
FIRST_LISTEN=8080
FIRST_SERVERNAME=first.local

SECOND_PID=/var/run/httpd/httpd-second.pid
SECOND_LISTEN=8081
SECOND_SERVERNAME=second.local

HTTPD_USER=apache
HTTPD_GROUP=apache
HTTPD_PATH_MODULES=conf.modules.d/*.conf

# Resolve error: Permission denied: AH00072: make_sock: could not bind to address [::]:8081
# https://stackoverflow.com/questions/17079670/httpd-server-not-started-13permission-denied-make-sock-could-not-bind-to-ad
selinuxenabled && setenforce 0

cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service
# Resolve problem with start httpd
cp /etc/mime.types /etc/httpd/conf
sed '/^Description/ s/$/ %I/' -i /usr/lib/systemd/system/httpd@.service
sed '/^EnvironmentFile/ s/$/-%I/' -i /usr/lib/systemd/system/httpd@.service

cat >/etc/sysconfig/httpd-first<<__EOF
OPTIONS=-f conf/first.conf
__EOF

cat >/etc/sysconfig/httpd-second<<__EOF
OPTIONS=-f conf/second.conf
__EOF

cat >/etc/httpd/conf/first.conf<<__EOF
ServerName $FIRST_SERVERNAME
PidFile $FIRST_PID
Listen $FIRST_LISTEN
Include $HTTPD_PATH_MODULES
User $HTTPD_USER
Group $HTTPD_GROUP
__EOF

cat >/etc/httpd/conf/second.conf<<__EOF
ServerName $SECOND_SERVERNAME
PidFile $SECOND_PID
Listen $SECOND_LISTEN
Include $HTTPD_PATH_MODULES
User $HTTPD_USER
Group $HTTPD_GROUP
__EOF

systemctl daemon-reload && systemctl start httpd@first && systemctl start httpd@second