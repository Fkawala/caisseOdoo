#!/bin/bash

# Install git
apt -y --no-install-recommends install git

# configure GIT
git config --global user.email "cielenid@coopiteasy.be"
git config --global user.name "cielenid"

# Create clone directory
mkdir -p $CLONE_DIR

# Init git repository
git clone -b ${ODOO_VERSION} --no-local --depth 1 ${REPO} "${CLONE_DIR}"
