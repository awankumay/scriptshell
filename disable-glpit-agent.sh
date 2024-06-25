#!/bin/bash

echo "Get Disable GLPI Agent Inventory...."
sudo systemctl stop glpi-agent.service
sudo systemctl disable glpi-agent.service
echo "Proses Service Done!"
