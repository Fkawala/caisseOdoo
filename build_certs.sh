
apt -y --no-install-recommends install libssl1.0.0

touch ~/.rnd
openssl genrsa -aes256 -out ca.key.pem 2048
chmod 400 ca.key.pem
openssl genrsa -out localhost.key.pem 2048
openssl req -subj "/CN=${CERT_NAME}" -extensions v3_req -sha256 -new -key localhost.key.pem -out localhost.csr
openssl req -new -x509 -subj "/CN=${CERT_NAME}" -extensions v3_ca -days 3650 -key ca.key.pem -sha256 -out ${CERT_NAME}.pem -config localhost.cnf
openssl x509 -req -extensions v3_req -days 3650 -sha256 -in localhost.csr -CA ${CERT_NAME}.pem -CAkey ca.key.pem -CAcreateserial -out localhost.crt -extfile localhost.cnf
