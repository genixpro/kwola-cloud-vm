#!/usr/bin/env bash

echo "Please enter the credentials for your Azure Storage account where Kwola will store its data"

KWOLA_INSTALL_DIR="/opt/kwola"

cd $KWOLA_INSTALL_DIR

echo "Please enter your Azure Storage Account Name:"
read ACCOUNT_NAME

echo "Please enter your Azure Storage Access Key:"
read ACCESS_KEY

echo "Please enter your Azure Storage Container Name:"
read CONTAINER_NAME

echo "accountName $ACCOUNT_NAME
accountKey $ACCESS_KEY
containerName $CONTAINER_NAME" | sudo su kwola -c "tee $KWOLA_INSTALL_DIR/fuse_connection.cfg"
sudo chmod 600 $KWOLA_INSTALL_DIR/fuse_connection.cfg

echo "$CONTAINER_NAME" | sudo su kwola -c "tee $KWOLA_INSTALL_DIR/.container-name"


echo "Please enter the URL that you would like Kwola to start testing. Include http:// and everything in the URL."
read KWOLAURL

sudo umount $KWOLA_INSTALL_DIR/kwola_storage_mount
sudo rm -rf $KWOLA_INSTALL_DIR/kwola_storage_mount
sudo rm -rf $KWOLA_INSTALL_DIR/blobfusetmp
sudo su kwola -c "mkdir $KWOLA_INSTALL_DIR/blobfusetmp"
sudo su kwola -c "mkdir $KWOLA_INSTALL_DIR/kwola_storage_mount"
sudo blobfuse $KWOLA_INSTALL_DIR/kwola_storage_mount --tmp-path=$KWOLA_INSTALL_DIR/blobfusetmp  --config-file=fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o allow_other
sleep 3

echo "Copying files to blob storage"
sudo su kwola -c "cp $KWOLA_INSTALL_DIR/local_kwola_config.json $KWOLA_INSTALL_DIR/kwola_storage_mount"
sudo su kwola -c "cp -r $KWOLA_INSTALL_DIR/node_modules $KWOLA_INSTALL_DIR/kwola_storage_mount"

echo "Generating the TLS/SSL MITM Proxy Certificate"
sudo su kwola -c "source venv/bin/activate; kwola_install_proxy_cert 1"

echo "Installing the mitm proxy certificate into the Chrome registry"
sudo su kwola -c "certutil -d sql:/home/kwola/.pki/nssdb -A -n 'mitm.it cert authority' -i ~/.mitmproxy/mitmproxy-ca-cert.cer -t TCP,TCP,TCP"

echo "Initializing Kwola"
cd $KWOLA_INSTALL_DIR/kwola_storage_mount
sudo su kwola -c "source $KWOLA_INSTALL_DIR/venv/bin/activate; pip3 install kwola --upgrade --no-cache; pip3 install kwola --upgrade --no-cache; pip3 install kwola --upgrade --no-cache;"
sudo su kwola -c "source $KWOLA_INSTALL_DIR/venv/bin/activate; kwola_init $KWOLAURL local_kwola_config"

echo "Cleaning up"
sudo su kwola -c "rm $KWOLA_INSTALL_DIR/kwola_storage_mount/local_kwola_config.json"


echo "Restarting the Kwola system service"
sudo systemctl restart kwola

echo "You have completed initializing Kwola. Kwola will now start running."
echo "Kwola will store its results in the Azure Storage bucket that you provided."
echo "Please look there in the bugs folder to find data on the bugs that Kwola finds."
