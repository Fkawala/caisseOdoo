#!/bin/bash

# Config file for posboxless
cat > ${CLONE_DIR}/posboxless.conf <<EOL
[options]
xmlrpc_port = 8069
longpolling_port = 8072
server_wide_modules = web,hw_proxy,hw_posbox_homepage,hw_scale,hw_scanner,hw_escpos

addons_path=
    ${CLONE_DIR}/addons,
EOL