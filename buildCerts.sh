# Create SSL root auth. and cert
cat >> domains.ext <<EOL
[req]
req_extensions = v3_req

[ v3_req ]
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
EOL

openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout LeNidRootCA.key -out LeNidRootCA.pem -subj "/C=CH/L=Genève/CN=Nid-Root-CA"
openssl x509 -outform pem -in LeNidRootCA.pem -out LeNidRootCA.crt
openssl req -new -nodes -newkey rsa:2048 -keyout posbox.key -out posbox.csr -subj "/C=CH/ST=Genf/L=Geneve/O=LeNid/CN=localhost"
openssl x509 -req -sha256 -days 1024 -in posbox.csr -CA LeNidRootCA.pem -CAkey LeNidRootCA.key -CAcreateserial -extfile domains.ext -out posbox.crt

sudo mkdir -p /etc/nginx/ssl
sudo cp posbox.key /etc/nginx/ssl/
sudo cp posbox.crt /etc/nginx/ssl/
