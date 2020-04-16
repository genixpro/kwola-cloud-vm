#!/usr/bin/env bash -e


cd /home/ubuntu

sudo blobfuse kwola_storage_mount --tmp-path=/home/ubuntu/blobfusetmp  --config-file=fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120

source venv/bin/activate
cd kwola_storage_mount
kwola
