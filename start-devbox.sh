#!/bin/bash
set -e

# Clean up stale XRDP PID files
rm -f /var/run/xrdp/xrdp-sesman.pid
rm -f /var/run/xrdp/xrdp.pid

# Ensure XFCE session exists for the dev user
USER_HOME="/home/$DEVBOX_USER"
if [ ! -f "$USER_HOME/.xsession" ]; then
    echo "startxfce4" > "$USER_HOME/.xsession"
    chown $DEVBOX_USER:$DEVBOX_USER "$USER_HOME/.xsession"
    chmod 644 "$USER_HOME/.xsession"
fi

# Start acct (logs all commands)
service acct start || true

# 👉 Hand over control to Supervisor (it will run xrdp + sesman)
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
