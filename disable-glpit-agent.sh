#!/bin/bash

echo "Get Disable GLPI Agent Inventory...."
systemctl stop glpi-agent.service && systemctl disable glpi-agent.service
echo "Proses Service Done!"
