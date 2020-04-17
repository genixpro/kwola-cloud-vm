#!/usr/bin/env bash

KWOLA_INSTALL_DIR="/opt/kwola"

sudo blobfuse $KWOLA_INSTALL_DIR/kwola_storage_mount --tmp-path=$KWOLA_INSTALL_DIR/blobfusetmp  --config-file=$KWOLA_INSTALL_DIR/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120
source $KWOLA_INSTALL_DIR/venv/bin/activate
cd $KWOLA_INSTALL_DIR/kwola_storage_mount
kwola
