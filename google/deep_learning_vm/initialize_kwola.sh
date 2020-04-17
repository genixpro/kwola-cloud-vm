#!/usr/bin/env bash


echo "Please enter the credentials for Google Cloud Storage"

cd /opt/kwola

sudo su kwola -c "gcloud auth application-default login"

echo ""
echo "Please enter your GCS bucket name:"
read GCSBUCKETNAME

sudo echo $GCSBUCKETNAME | sudo su kwola -c 'tee /opt/kwola/.gcs-bucket'

echo ""
echo "Please enter the URL that you would like Kwola to start testing. Include http:// and everything in the URL."
read KWOLAURL

echo "Mounting the GCS Bucket to a local directory"
sudo su kwola -c "umount kwola_gcs_mount"
sudo su kwola -c 'gcsfuse `cat /opt/kwola/.gcs-bucket` kwola_gcs_mount'
sleep 3


echo "Copying files to GCS storage"
sudo su kwola -c "cp -r node_modules kwola_gcs_mount/"


echo "Initializing Kwola"
sudo su kwola -c "cp local_kwola_config.json kwola_gcs_mount/"
sudo su kwola -c "source venv/bin/activate;kwola_init $KWOLAURL local_kwola_config"
sudo su kwola -c "rm kwola_gcs_mount/local_kwola_config.json"

sudo systemctl restart kwola

echo "You have completed initializing Kwola. Kwola will now start running."
echo "Kwola will now start storing its results in the gcs bucket that you provided."
-