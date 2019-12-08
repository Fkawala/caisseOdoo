#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

ODOO_USER=root
CLONE_DIR=/usr/bin/odoo
ODOO_VERSION=11.0
REPO=https://github.com/odoo/odoo.git

# Install pip virtualenv and git
sudo apt -y --no-install-recommends install libnss3-tools libxml2-dev libxslt-dev build-essential python3-wheel python3-dev python3-setuptools postgresql nginx git python3-pip virtualenv postgresql-server-dev-all libsasl2-dev libldap2-dev libssl-dev

# configure GIT
git config --global user.email "cielenid@coopiteasy.be"
git config --global user.name "cielenid"

# Create clone directory
mkdir -p $CLONE_DIR

# Init git repository
git clone -b ${ODOO_VERSION} --no-local --depth 1 ${REPO} "${CLONE_DIR}"

# posboxless python dependencies
sudo -H pip3 install pyserial pyusb==1.0.0b1 qrcode netifaces evdev 

# install dependencies
sudo -H pip3 install -r ${CLONE_DIR}/requirements.txt

# Access to usb device
sudo groupadd usbusers
sudo usermod -a -G usbusers $ODOO_USER

sudo bash -c 'cat >/etc/udev/rules.d/99-usbusers.rules <<EOL
SUBSYSTEM=="usb", GROUP="usbusers", MODE="0660"
SUBSYSTEMS=="usb", GROUP="usbusers", MODE="0660"
EOL'

# Apply udev modifications
sudo udevadm control --reload-rules && sudo udevadm trigger

# Config file for posboxless
cat > ${CLONE_DIR}/posboxless.conf <<EOL
[options]
xmlrpc_port = 8069
longpolling_port = 8072
server_wide_modules = web,hw_proxy,hw_posbox_homepage,hw_scale,hw_scanner,hw_escpos

addons_path=
    ${CLONE_DIR}/addons,
EOL

# Create odoo daemon
cat > /etc/init.d/odoo <<EOL
#!/bin/sh

### BEGIN INIT INFO
# Provides:             odoo-server
# Required-Start:       \$remote_fs \$syslog
# Required-Stop:        \$remote_fs \$syslog
# Should-Start:         \$network
# Should-Stop:          \$network
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Enterprise Resource Management software
# Description:          Open ERP is a complete ERP and CRM software.
### END INIT INFO

PATH=/bin:/sbin:/usr/bin:/usr/local/bin
DAEMON=${CLONE_DIR}/odoo-bin
NAME=odoo
DESC=odoo

# Specify the user name (Default: openerp).
USER=$ODOO_USER	

# Specify an alternate config file (Default: /etc/odoo-server.conf).
CONFIGFILE="${CLONE_DIR}/posboxless.conf"

# pidfile
PIDFILE=/var/run/\$NAME.pid

# Additional options that are passed to the Daemon.
DAEMON_OPTS="-c \$CONFIGFILE"

[ -x \$DAEMON ] || exit 0
[ -f \$CONFIGFILE ] || exit 0

checkpid() {
    [ -f \$PIDFILE ] || return 1
    pid=\`cat \$PIDFILE\`
    [ -d /proc/\$pid ] && return 0
    pid=\`cat \$PIDFILE\`
    [ -d /proc/\$pid ] && return 0
    pid=\`cat \$PIDFILE\`
    [ -d /proc/\$pid ] && return 0
    return 1
}

case "\${1}" in
        start)
                echo -n "Starting \${DESC}: "

                start-stop-daemon --start --quiet --pidfile \${PIDFILE} \
                        --chuid \${USER} --background --make-pidfile \
                        --exec \${DAEMON} -- \${DAEMON_OPTS}

                echo "\${NAME}."
                ;;

        stop)
                echo -n "Stopping \${DESC}: "


                start-stop-daemon --stop --quiet --pidfile \${PIDFILE} \
                        --oknodo

                echo "\${NAME}."
                ;;

        restart|force-reload)
                echo -n "Restarting \${DESC}: "

                start-stop-daemon --stop --quiet --pidfile \${PIDFILE} \
                        --oknodo

                sleep 1

                start-stop-daemon --start --quiet --pidfile \${PIDFILE} \
                        --chuid \${USER} --background --make-pidfile \
                        --exec \${DAEMON} -- \${DAEMON_OPTS}

                echo "\${NAME}."
                ;;

        *)
                N=/etc/init.d/\${NAME}
                echo "Usage: \${NAME} {start|stop|restart|force-reload}" >&2
               exit 1
               ;;
esac

exit 0
EOL

# Install postgresql
sudo su - postgres -c "createuser -s $ODOO_USER"

# Generate certificates and install them
bash buildCerts.sh
bash installCerts.sh coop

# Nginx posbox config
cat >/etc/nginx/sites-available/posbox <<EOL
server{
    listen 80;
    server_name  localhost;
    proxy_connect_timeout       600;
    proxy_send_timeout          600;
    proxy_read_timeout          600;
    send_timeout                600;
    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_pass http://localhost:8069/;
    }
}

server{
    listen 443 ssl;
    server_name localhost;
    ssl_certificate /etc/nginx/ssl/posbox.crt;
    ssl_certificate_key /etc/nginx/ssl/posbox.key;
    proxy_connect_timeout       600;
    proxy_send_timeout          600;
    proxy_read_timeout          600;
    send_timeout                600;
    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_pass http://localhost:8069/;
    }
}
EOL

sudo ln -s /etc/nginx/sites-available/posbox /etc/nginx/sites-enabled/posbox

sudo systemctl restart nginx

# Setup the deamon
sudo chmod +x /etc/init.d/odoo
sudo systemctl enable odoo
sudo systemctl start odoo

sudo update-rc.d nginx defaults
sudo update-rc.d odoo defaults
