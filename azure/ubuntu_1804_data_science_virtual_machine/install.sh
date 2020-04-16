#!/usr/bin/env bash


CUDA_REPO_PKG=cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
wget -O /tmp/${CUDA_REPO_PKG} http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/${CUDA_REPO_PKG}
sudo dpkg -i /tmp/${CUDA_REPO_PKG}
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
rm -f /tmp/${CUDA_REPO_PKG}


curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


sudo apt update -y

sudo apt install ffmpeg chromium-browser nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg cuda-drivers cuda libssl-dev blobfuse  -y

wget https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
rm -rf chromedriver
rm -rf chromedriver_linux64.zip

python3 -m venv venv
source venv/bin/activate
pip3 install kwola --upgrade --no-cache


sudo npm install @babel/cli -g
sudo npm install @babel/core -g
sudo npm install babel-plugin-kwola -g
npm install babel-plugin-kwola
rm -rf package-lock.json

chmod +x run_kwola.sh
chmod +x initialize_kwola.sh

mkdir kwola_storage_mount

sudo cp kwola.service /etc/systemd/system/kwola.service
sudo systemctl daemon-reload
sudo systemctl enable kwola
sudo systemctl daemon-reload


echo "Installing the SSH Banner for the Server"
sudo cp ssh_banner.txt /etc/banner
sudo su -c 'echo "Banner /etc/banner" >> /etc/ssh/sshd_config'
sudo systemctl restart sshd


