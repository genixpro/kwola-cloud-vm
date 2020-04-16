#!/usr/bin/env bash

echo "Please enter the credentials for Google Cloud Storage"

gcloud auth application-default login

echo "Please enter your GCS bucket name:"
read GCSBUCKETNAME

echo "$GCSBUCKETNAME" > .gcs-bucket

echo "Please enter the URL that you would like Kwola to start testing. Include http:// and everything in the URL."
read KWOLAURL

mkdir kwola_gcs_mount
gcsfuse `cat .gcs-bucket` kwola_gcs_mount
sleep 3
cd kwola_gcs_mount
cp ../local_kwola_config.json .
cp -r ../node_modules .
source ../venv/bin/activate
kwola_init $KWOLAURL local_kwola_config
rm local_kwola_config.json


sudo systemctl restart kwola

echo "You have completed initializing Kwola. Kwola will now start running."
echo "Kwola will now start storing its results in the gcs bucket that you provided."
