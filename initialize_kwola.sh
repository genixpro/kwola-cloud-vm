#!/usr/bin/env bash

echo "Please enter the credentials for your Amazon S3 account where Kwola will store its data"

echo "Please enter your AWS S3 Access Key ID:"
read AWSACCESSKEYID

echo "Please enter your AWS S3 Secret Key:"
read AWSSECRETACCESSKEY

echo "Please enter your AWS bucket name:"
read AWSBUCKETNAME

echo "$AWSBUCKETNAME:$AWSACCESSKEYID:$AWSSECRETACCESSKEY" > .passwd-s3fs
chmod 600 .passwd-s3fs
echo "$AWSBUCKETNAME" > .s3-bucket

echo "Please enter the URL that you would like Kwola to start testing. Include http:// and everything in the URL."
read KWOLAURL

mkdir kwola_s3_mount
s3fs `cat .s3-bucket` kwola_s3_mount
sleep 3
cd kwola_s3_mount
cp ../local_kwola_config.json .
cp -r ../node_modules .
kwola_init $KWOLAURL local_kwola_config

sudo systemctl restart kwola

echo "You have completed initializing Kwola. Kwola will now start running."
echo "Kwola will now start storing its results in the S3 bucket that you provided."
