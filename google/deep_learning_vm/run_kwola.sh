#!/usr/bin/env bash


cd /opt/kwola
gcsfuse `cat .gcs-bucket` kwola_gcs_mount
source venv/bin/activate
cd kwola_gcs_mount
kwola
