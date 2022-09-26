#!/bin/bash
#
cat >/etc/sysconfig/watchlog<<__EOF
# Configuration file for my watchdog service
# Place it to /etc/sysconfig
# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/messages
__EOF

cat >/opt/watchlog.sh<<__EOF
#!/bin/bash
WORD=\$1
LOG=\$2
DATE=\`date\`
if grep \$WORD \$LOG &> /dev/null
then
logger "\$DATE: I found word, Master!"
else
exit 0
fi
__EOF

chmod +x /opt/watchlog.sh

cat >/etc/systemd/system/watchlog.service<<__EOF
[Unit]
Description=My watchlog service
[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
__EOF

cat >/etc/systemd/system/watchlog.timer<<__EOF
[Unit]
Description=Run watchlog script every 30 second
[Timer]
# Run every 30 second
OnActiveSec=1sec
OnUnitActiveSec=30
AccuracySec=1us
Unit=watchlog.service
[Install]
WantedBy=multi-user.target
__EOF

systemctl daemon-reload && systemctl start watchlog.timer

logger ALERT