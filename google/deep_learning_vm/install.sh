#!/usr/bin/env bash -e


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
rm -rf chromedriver
rm -rf chromedriver_linux64.zip


echo "Creating the python virtual environment using the newly compiled Python version"
python3.8 -m venv venv
source venv/bin/activate
pip3 install kwola --upgrade --no-cache


echo "Installing babel and the kwola babel plugin globally using npm"
sudo npm install @babel/cli -g
sudo npm install @babel/core -g
sudo npm install babel-plugin-kwola -g


echo "Installing a copy of the babel plugin locally as well"
npm install babel-plugin-kwola
rm -rf package-lock.json


echo "Make the primary kwola scripts executable"
chmod +x run_kwola.sh
chmod +x initialize_kwola.sh


echo "Creating the directory that we will mount google storage too"
mkdir kwola_gcs_mount


echo "Creating a system service for kwola and enabling it so that it runs on boot"
sudo cp kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload


echo "Installing the SSH Banner for the Server"
sudo cp ssh_banner.txt /etc/banner
sudo su -c 'echo "Banner /etc/banner" >> /etc/ssh/sshd_config'
sudo systemctl restart sshd

echo "The installation of Kwola to this Google Cloud Server is now complete"

