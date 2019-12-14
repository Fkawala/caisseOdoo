#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

export ODOO_USER=root
export CLONE_DIR=/home/francois/nid/odoo
export ODOO_VERSION=11.0
export REPO=https://github.com/odoo/odoo.git
export COOP_USER=francois
export CERT_NAME="LeNidRootCA"

# Install git and other packages needed to run
# the install scripts.
apt -y --no-install-recommends install gettext

chmod +x *.sh

./git_clone.sh
./install_lib.sh
./update_group.sh
./create_conf.sh
./setup_nginx.sh
./build_certs.sh
./install_pgsql.sh
#./create_odoo_daemon.sh
./install_certs.sh 

systemctl start nginx
update-rc.d nginx defaults
update-rc.d odoo defaults

#rm *.key *.pem *.crt *.csr *.ext *.srl
