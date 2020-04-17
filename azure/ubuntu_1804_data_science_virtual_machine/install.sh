#!/usr/bin/env bash

START_DIR=`pwd`
KWOLA_INSTALL_DIR="/opt/kwola"


echo "Setting up system reposities for CUDA"
CUDA_REPO_PKG=cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
wget -O /tmp/${CUDA_REPO_PKG} http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/${CUDA_REPO_PKG}
sudo dpkg -i /tmp/${CUDA_REPO_PKG}
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
rm -f /tmp/${CUDA_REPO_PKG}

echo "Setting up system reposities for NodeJS from NodeSource"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


echo "Installing System Dependencies"
sudo apt update -y
sudo apt install ffmpeg chromium-browser nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg cuda-drivers cuda libssl-dev blobfuse python3-venv -y

echo "Downloading and installing chromedriver"
wget https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
rm -rf chromedriver
rm -rf chromedriver_linux64.zip


echo "Creating a user for Kwola"
sudo useradd -s /bin/bash --home-dir /home/kwola kwola
sudo mkdir /home/kwola
sudo chown -R kwola:kwola /home/kwola


echo "Creating the Python virtual environment for Kwola"
sudo mkdir $KWOLA_INSTALL_DIR
cd $KWOLA_INSTALL_DIR
sudo python3 -m venv venv
sudo su -c "source venv/bin/activate; pip3 install kwola --upgrade --no-cache"


echo "Installing the npm modules for babel and the kwola plugin globally"
sudo npm install @babel/cli -g
sudo npm install @babel/core -g
sudo npm install babel-plugin-kwola -g


echo "Installing the the babel plugin locally as well"
sudo npm install babel-plugin-kwola
sudo rm -rf package-lock.json


echo "Make the primary kwola scripts executable"
sudo cp $START_DIR/run_kwola.sh /usr/bin/run_kwola
sudo cp $START_DIR/initialize_kwola.sh /usr/bin/initialize_kwola
sudo chmod +x /usr/bin/run_kwola
sudo chmod +x /usr/bin/initialize_kwola

echo "Creating the directory that we will mount azure blob storage to"
sudo mkdir $KWOLA_INSTALL_DIR/kwola_storage_mount

echo "Creating a system service for kwola and enabling it so that it runs on boot"
sudo cp $START_DIR/kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload


echo "Installing the SSH Banner for the Server"
sudo cp $START_DIR/ssh_banner.txt /etc/motd
sudo rm /etc/update-motd.d/*
sudo systemctl restart sshd

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
rm -rf $START_DIR/notebooks
rm -rf $START_DIR/Desktop


echo "The installation of Kwola to this Microsoft Azure is now complete"

