#!/usr/bin/env bash -e

echo "Please enter the credentials for your Azure Storage account where Kwola will store its data"

echo "Please enter your Azure Storage Account Name:"
read ACCOUNT_NAME

echo "Please enter your Azure Storage Access Key:"
read ACCESS_KEY

echo "Please enter your Azure Storage Container Name:"
read CONTAINER_NAME

echo "accountName $ACCOUNT_NAME
accountKey $ACCESS_KEY
containerName $CONTAINER_NAME" > fuse_connection.cfg
chmod 600 fuse_connection.cfg

echo "CONTAINER_NAME" > .container-name


echo "Please enter the URL that you would like Kwola to start testing. Include http:// and everything in the URL."
read KWOLAURL

mkdir blobfusetmp

mkdir kwola_storage_mount
sudo blobfuse kwola_storage_mount --tmp-path=/home/ubuntu/blobfusetmp  --config-file=fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o allow_other
sleep 3
cd kwola_storage_mount
echo "Copying files to blob storage"
cp ../local_kwola_config.json .
cp -r ../node_modules .
source ../venv/bin/activate
echo "Initializing Kwola"
kwola_init $KWOLAURL local_kwola_config
rm local_kwola_config.json


sudo systemctl restart kwola

echo "You have completed initializing Kwola. Kwola will now start running."
echo "Kwola will now start storing its results in the Azure Storage bucket that you provided."
