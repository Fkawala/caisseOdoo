#!/bin/bash

# Install nginx
apt -y --no-install-recommends install nginx 

# Stop ngnix daemon if any
systemctl stop nginx

# Nginx posbox config
envsub < posbox.nginx > /etc/nginx/sites-available/posbox

ln -s /etc/nginx/sites-available/posbox /etc/nginx/sites-enabled/posbox

