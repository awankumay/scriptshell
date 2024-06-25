#!/bin/bash

echo "Get Repository Git-Core"
sudo add-apt-repository ppa:git-core/ppa
echo "Install / Upgrade Git"
sudo apt install git -y
echo "Install / Upgrade Git Done!"
git --version
