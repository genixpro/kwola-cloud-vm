#!/usr/bin/env bash

START_DIR=`pwd`


echo "Installing the NodeJS repository"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


echo "Installing general system packages"
sudo apt update -y
sudo apt install ffmpeg chromium nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg libssl-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev curl libsqlite3-dev -y


echo "Compiling Python version 3.8.2 The system by default has Python 3.5 which does not work for Kwola"
curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
tar -xf Python-3.8.2.tar.xz
cd Python-3.8.2
./configure --enable-optimizations
make -j 8
sudo make altinstall
cd ..
sudo rm -rf Python-3.8.2
sudo rm -rf Python-3.8.2.tar.xz


echo "Downloading and installing Chromedriver"
wget https://chromedriver.storage.googleapis.com/73.0.3683.68/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
sudo chmod +rw,+r,+r /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
rm -rf chromedriver
rm -rf chromedriver_linux64.zip

echo "Creating a user for Kwola"
sudo useradd -s /bin/bash --home-dir /home/kwola kwola
sudo mkdir /home/kwola
sudo chown -R kwola:kwola /home/kwola

echo "Creating the python virtual environment using the newly compiled Python version"
sudo mkdir /opt/kwola
cd /opt/kwola
sudo python3.8 -m venv venv
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


echo "Creating the directory that we will mount google storage too"
sudo mkdir kwola_gcs_mount


echo "Creating a system service for kwola and enabling it so that it runs on boot"
sudo cp $START_DIR/kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload


echo "Installing the SSH Banner for the Server"
sudo cp $START_DIR/ssh_banner.txt /etc/motd
sudo rm /etc/update-motd.d/*
sudo systemctl restart sshd

sudo cp $START_DIR/local_kwola_config.json /opt/kwola/

echo "Setting all files in /opt/kwola to have the owner 'kwola'. "
sudo chown kwola:kwola -R /opt/kwola

echo "Cleaning up the installation files"
rm $START_DIR/ssh_banner.txt
rm $START_DIR/kwola.service
rm $START_DIR/install.sh
rm $START_DIR/initialize_kwola.sh
rm $START_DIR/run_kwola.sh
rm $START_DIR/local_kwola_config.json

echo "The installation of Kwola to this Google Cloud Server is now complete"

