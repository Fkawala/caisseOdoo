#!/bin/bash

# Create odoo daemon
envsubst '${CLONE_DIR} ${ODOO_USER}' < odoo.deamon > /etc/init.d/odoo

# Setup the deamon
sudo chmod +x /etc/init.d/odoo
sudo systemctl enable odoo
sudo systemctl start odoo
