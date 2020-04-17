#!/usr/bin/env bash

KWOLA_INSTALL_DIR="/opt/kwola"

cd $KWOLA_INSTALL_DIR
s3fs `cat .s3-bucket` kwola_s3_mount
source venv/bin/activate
cd kwola_s3_mount
kwola
