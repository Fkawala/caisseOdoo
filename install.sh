#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

export ODOO_USER=root
export CLONE_DIR=/usr/bin/odoo
export ODOO_VERSION=11.0
export REPO=https://github.com/odoo/odoo.git
export COOP_USER=coop
export CERT_NAME="LeNidRootCA"

chmod +x *.sh

./git_clone.sh
./install_lib.sh
./update_group.sh
./create_conf.sh
./build_certs.sh
./setup_nginx.sh
./install_pgsql.sh
./create_odoo_daemon.sh
./install_certs.sh 

update-rc.d nginx defaults
update-rc.d odoo defaults

rm *.key *.pem *.crt *.csr *.ext *.srl
