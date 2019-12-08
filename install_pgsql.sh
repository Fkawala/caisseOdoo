#!/bin/bash

# Install pip virtualenv and git
apt -y --no-install-recommends install postgresql

sudo su - postgres -c "createuser -s $ODOO_USER"


