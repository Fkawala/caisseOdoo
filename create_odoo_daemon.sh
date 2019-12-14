#!/bin/bash

# Create odoo daemon
envsub < odoo.deamon > /etc/init.d/odoo

# Setup the deamon
sudo chmod +x /etc/init.d/odoo
sudo systemctl enable odoo
sudo systemctl start odoo
