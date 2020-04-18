#!/usr/bin/env bash



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
sudo apt install ffmpeg chromium-browser nodejs build-essential libcurl4-openssl-dev libxml2-dev mime-support fuse fuse-dbg cuda-drivers cuda libssl-dev python3-venv python3-dev libnss3-tools -y

echo "Downloading and installing chromedriver"
wget https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo cp chromedriver /usr/bin/
rm -rf chromedriver
rm -rf chromedriver_linux64.zip

echo "Installing the npm modules for babel and the kwola plugin globally"
sudo npm install @babel/cli -g
sudo npm install @babel/core -g
sudo npm install babel-plugin-kwola -g

echo "The dependencies for Kwola on Ubuntu1804 are now installed."

