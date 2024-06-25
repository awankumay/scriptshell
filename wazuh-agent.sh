#!/bin/bash

echo "Get Source Wazuh Agent & Install....."
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.8.0-1_amd64.deb
sudo WAZUH_MANAGER='10.245.245.42' WAZUH_AGENT_GROUP='OwlexaHealthcare' WAZUH_AGENT_NAME=$(hostname) dpkg -i ./wazuh-agent_4.8.0-1_amd64.deb
echo "Installation Wazuh Agent Done!"
echo "Get Restart Service Wazuh Agent & Enable Service"
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
echo "Proses Service Done!"
echo "Get Disable GLPI Agent Inventory...."
sudo systemctl stop glpi-agent.service
sudo systemctl disable glpi-agent.service
echo "Proses Service Done!"
