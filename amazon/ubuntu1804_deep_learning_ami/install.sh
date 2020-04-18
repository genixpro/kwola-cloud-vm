#!/usr/bin/env bash

START_DIR=`pwd`
KWOLA_INSTALL_DIR="/opt/kwola"

echo "Installing the NodeJS repository"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


echo "Installing general system packages"
sudo apt update -y
sudo apt install ffmpeg chromium-browser nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg libssl-dev python3-venv libnss3-tools -y


echo "Downloading and installing Chromedriver"
wget https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
sudo chmod 644 /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
rm -rf chromedriver
rm -rf chromedriver_linux64.zip


echo "Downloading, compiling and installing the fuse module for S3 storage"
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make -j 16
sudo make install
cd ..
sudo rm -rf s3fs-fuse


echo "Creating a user for Kwola"
sudo useradd -s /bin/bash --home-dir /home/kwola kwola
sudo mkdir /home/kwola
sudo chown -R kwola:kwola /home/kwola


echo "Creating the python virtual environment using the newly compiled Python version"
sudo mkdir $KWOLA_INSTALL_DIR
cd $KWOLA_INSTALL_DIR
sudo python3 -m venv venv
sudo su -c "source venv/bin/activate; pip3 install kwola --upgrade --no-cache"


echo "Installing babel and the kwola babel plugin globally using npm"
sudo npm install @babel/cli -g
sudo npm install @babel/core -g
sudo npm install babel-plugin-kwola -g

echo "Installing a copy of the babel plugin locally as well"
sudo npm install babel-plugin-kwola
sudo rm -rf package-lock.json


echo "Make the primary kwola scripts executable"
sudo cp $START_DIR/run_kwola.sh /usr/bin/run_kwola
sudo cp $START_DIR/initialize_kwola.sh /usr/bin/initialize_kwola
sudo chmod +x /usr/bin/run_kwola
sudo chmod +x /usr/bin/initialize_kwola


echo "Creating the directory that we will mount azure blob storage to"
sudo mkdir $KWOLA_INSTALL_DIR/kwola_s3_mount


sudo cp $START_DIR/kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload


echo "Installing the SSH Banner for the Server"
sudo cp $START_DIR/ssh_banner.txt /etc/motd
sudo rm /etc/update-motd.d/*
sudo systemctl restart sshd


echo "Installing the local kwola configuration file"
sudo cp $START_DIR/local_kwola_config.json $KWOLA_INSTALL_DIR/


echo "Setting all files in $KWOLA_INSTALL_DIR to have the owner 'kwola'. "
sudo chown kwola:kwola -R $KWOLA_INSTALL_DIR

echo "Cleaning up the installation files"
rm $START_DIR/ssh_banner.txt
rm $START_DIR/kwola.service
rm $START_DIR/install.sh
rm $START_DIR/initialize_kwola.sh
rm $START_DIR/run_kwola.sh
rm $START_DIR/local_kwola_config.json


echo "The installation of Kwola to this Amazon AWS instance is now complete"

