#!/usr/bin/env bash


cd /home/ubuntu
gcsfuse `cat .gcs-bucket` kwola_gcs_mount
source venv/bin/activate
cd kwola_gcs_mount
kwola
