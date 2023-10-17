    #!/bin/bash
gnome-terminal -- bash -c "echo 'Setting up installation...'

echo 'Installing Node.js...'
sudo apt update
sudo apt install -y nodejs
node -v
npm -v

echo -e '\nInstalling npm...\n================================================'
sudo apt install -y npm

echo -e '\nInstalling php...\n================================================'
sudo apt install php

echo -e '\nInstalling Python...\n================================================'
sudo apt install python3

echo -e '\nInstalling Docker...\n================================================'
sudo apt-get update
sudo apt-get install -y docker.io
docker --version

echo -e '\nInstalling Visual Studio Code... \n================================================'
sudo snap install code --classic

echo -e '\nInstalling Postman... \n================================================'
sudo snap install postman


echo -e '\nInstalling GNU Guix... \n================================================'
sudo apt install guix

echo -e '\nInstalling Neovim >= 0.8.0... \n================================================'
sudo guix package --install neovim

echo -e '\nInstalling wavemon... \n================================================'
sudo apt install wavemon

echo -e '\nInstalling Filezilla... \n================================================'
sudo snap install filezilla --edge

echo -e '\nInstalling Beekeper Studio... \n================================================'
sudo snap install beekeeper-studio


echo -e '\n==========================================================='
echo -e '\n Yeay! All package already installed'
echo -e '\nInstallation completed. Press Enter to close this terminal.'
read"
echo -e '\n==========================================================='

