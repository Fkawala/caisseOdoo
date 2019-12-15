#!/bin/bash

# Install python packages 
sudo apt -y --no-install-recommends install python3-wheel python3-dev python3-setuptools python3-pip

# Install precomplied python packages 
sudo apt -y --no-install-recommends install python3-evdev python3-psutil
	
# posboxless python dependencies
sudo -H pip3 install pyserial qrcode netifaces PyPDF2 passlib Babel Werkzeug lxml==4.2.3 decorator python-dateutil psycopg2==2.7.3.1 Pillow==6.1.0 reportlab html2text==2016.9.19 docutils num2words jinja2 pyusb==1.0.0b

