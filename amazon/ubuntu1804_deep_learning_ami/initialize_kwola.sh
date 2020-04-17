#!/usr/bin/env bash

KWOLA_INSTALL_DIR="/opt/kwola"

echo "Please enter the credentials for your Amazon S3 account where Kwola will store its data"

cd $KWOLA_INSTALL_DIR

echo "Please enter your AWS S3 Access Key ID:"
read AWSACCESSKEYID

echo "Please enter your AWS S3 Secret Key:"
read AWSSECRETACCESSKEY

echo "Please enter your AWS bucket name:"
read AWSBUCKETNAME

echo "$AWSBUCKETNAME:$AWSACCESSKEYID:$AWSSECRETACCESSKEY" | sudo su kwola -c "tee  $KWOLA_INSTALL_DIR/.passwd-s3fs"
sudo chmod 600 $KWOLA_INSTALL_DIR/.passwd-s3fs
echo "$AWSBUCKETNAME" | sudo su kwola -c "tee .s3-bucket"

echo "Please enter the URL that you would like Kwola to start testing. Include http:// and everything in the URL."
read KWOLAURL

echo "Mounting the S3 Bucket to a local directory"
sudo umount kwola_s3_mount
sudo su kwola -c "mkdir kwola_s3_mount"
sudo su kwola -c "s3fs `cat .s3-bucket` kwola_s3_mount"
sleep 3


echo "Copying files into the S3 bucket"
sudo su kwola -c "cp local_kwola_config.json kwola_s3_mount"
sudo su kwola -c "cp -r node_modules kwola_s3_mount"
sudo su kwola -c "source venv/bin/activate "

echo "Initializing Kwola"
sudo su kwola -c "source venv/bin/activate; pip3 install kwola --upgrade --no-cache; pip3 install kwola --upgrade --no-cache; pip3 install kwola --upgrade --no-cache;"
sudo su kwola -c "source venv/bin/activate;kwola_init $KWOLAURL local_kwola_config"
sudo su kwola -c "rm kwola_gcs_mount/local_kwola_config.json"

sudo systemctl restart kwola

echo "You have completed initializing Kwola. Kwola will now start running."
echo "Kwola will now start storing its results in the S3 bucket that you provided."
