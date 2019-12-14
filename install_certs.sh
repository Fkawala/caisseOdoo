#!/bin/bash

### Script installs root.cert.pem to certificate trust store of applications using NSS
### (e.g. Firefox, Thunderbird, Chromium)
### Mozilla uses cert8, Chromium and Chrome use cert9

###
### Requirement: apt install libnss3-tools
###

# Install libnss3
apt -y --no-install-recommends install libnss3-tools

###
### CA file to install (CUSTOMIZE!)
###



###
### For cert8 (legacy - DBM)
###

for certDB in $(find /home/${COOP_USER}/ -name "cert8.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${CERT_NAME}" -t "TCu,Cu,Tu" -i ${CERT_NAME}.pem -d dbm:${certdir}
done


###
### For cert9 (SQL)
###

for certDB in $(find /home/${COOP_USER}/ -name "cert9.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${CERT_NAME}" -t "TCu,Cu,Tu" -i ${CERT_NAME}.pem -d sql:${certdir}
done

###
### NGINX
###

mkdir -p /etc/nginx/ssl
cp localhost.key.pem /etc/nginx/ssl/posbox.key
cp localhost.crt /etc/nginx/ssl/posbox.crt
