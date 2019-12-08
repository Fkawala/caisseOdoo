#!/bin/bash

# Access to usb device
groupadd usbusers
usermod -a -G usbusers $ODOO_USER

bash -c 'cat >/etc/udev/rules.d/99-usbusers.rules <<EOL
SUBSYSTEM=="usb", GROUP="usbusers", MODE="0660"
SUBSYSTEMS=="usb", GROUP="usbusers", MODE="0660"
EOL'

