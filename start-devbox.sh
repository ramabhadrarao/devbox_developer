#!/bin/bash
set -e

echo "Starting devbox initialization..."

# Create all necessary directories (in case volumes are mounted)
echo "Creating required directories..."
mkdir -p /var/log/supervisor
mkdir -p /var/run/supervisor
mkdir -p /var/run/xrdp
mkdir -p /var/log/xrdp
mkdir -p /var/log/account

# Set proper permissions
chmod 755 /var/log/supervisor
chmod 755 /var/run/supervisor
chmod 755 /var/run/xrdp

# Clean up stale PID files
echo "Cleaning up stale PID files..."
rm -f /var/run/xrdp/xrdp-sesman.pid
rm -f /var/run/xrdp/xrdp.pid
rm -f /var/run/supervisord.pid

# Ensure XFCE session exists for the dev user
USER_HOME="/home/$DEVBOX_USER"
if [ ! -f "$USER_HOME/.xsession" ]; then
    echo "Creating XFCE session for user $DEVBOX_USER..."
    echo "startxfce4" > "$USER_HOME/.xsession"
    chown $DEVBOX_USER:$DEVBOX_USER "$USER_HOME/.xsession"
    chmod 644 "$USER_HOME/.xsession"
fi

# Start process accounting service
echo "Starting process accounting..."
service acct start || true

# Start supervisor daemon
echo "Starting supervisord..."
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf