#!/bin/bash

# This is needed to build some of the packages below.
sudo apt -y --no-install-recommends install build-essential

# Install python packages 
sudo apt -y --no-install-recommends install python3-wheel python3-dev python3-setuptools python3-pip virtualenv

# Install precomplied python packages 
sudo apt -y --no-install-recommends install python3-evdev python3-psutil

# Create virtualenv
sudo virtualenv -p python3.6 ${CLONE_DIR}/venv/
source ${CLONE_DIR}/venv/bin/activate
	
# posboxless python dependencies
pip3 install pyserial==3.1.1 qrcode==5.3 netifaces PyPDF2==1.26.0 passlib==1.6.5 Babel==2.3.4 Werkzeug==0.11.15 lxml==4.2.3 decorator==4.0.10 python-dateutil psycopg2==2.7.3.1 Pillow==6.1.0 reportlab==3.3.0 html2text==2016.9.19 docutils==0.12 num2words==0.5.6 jinja2==2.10.1 pyusb==1.0.0b1 PyYAML==3.13
