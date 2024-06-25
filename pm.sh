#!/bin/bash

# Get current year, month, and day
year=$(date +"%Y")
month=$(date +"%m")
day=$(date +"%d")

current_datetime=$(date +"%Y-%m-%d_%H-%M-%S")

# Define path to logs directory
pathlogs=~/logs/$year/$month/$day/

# Check if logs directory exists, if not create it
if [ ! -d "$pathlogs" ]; then
    mkdir -p "$pathlogs"
fi

#Function to update repository server
apt_update() {
    echo "Updating Repository Server in process..."
    {
        
        echo "$(date): Repository Server updated"
        sudo apt-get update || { echo "Failed to update repository server"; exit 1; }
        echo "Update Repository Done!"
        sudo apt list --upgradable || { echo "Failed to list upgradable packages"; exit 1; }
        echo "Update Available"
        sudo apt-get upgrade -s || { echo "Failed to simulate package upgrade"; exit 1; }

    } 2>&1 | tee -a $pathlogs/logs-update-$current_datetime.log
    echo "apt-get update exit code: $?" >> $pathlogs/logs-update-$current_datetime.log
}

# Function to update ClamAV databases
freshclam_update() {
    echo "Updating ClamAV Databases..."
    {   
        echo "$(date): ClamAV Databases updated"
        echo "================================="
        echo "= Stop Service Clamav Freshclam ="
        echo "================================="
        sudo systemctl stop clamav-freshclam
        sudo freshclam
        echo "================================="
        echo "= Stop Service Clamav Freshclam ="
        echo "================================="
        sudo systemctl restart clamav-daemon.service
    } 2>&1 | tee -a $pathlogs/logs-freshclam-$current_datetime.log
    echo "freshclam exit code: $?" >> $pathlogs/logs-freshclam-$current_datetime.log
}

clamscan(){
    echo "Scanne With Clamav Directory '/'"
    {
        sudo clamscan -r -v --infected --exclude-dir="/sys/|/proc/|/dev/|/mnt/|snapd/|/usr/local/" /
    } 2>&1 | tee -a $pathlogs/logs-clamscan-$current_datetime.log
    echo "freshclam exit code: $?" >> $pathlogs/logs-clamscan-$current_datetime.log
}

show_detail(){
    echo "Check Detail!"
    {
    echo "===================================="
    echo "Log Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "===================================="
    echo "Show Detail Hostname"
    hostnamectl
    echo "Show Detail Uptime"
    uptime
    echo "Show Detail Memmory"
    free -h
    echo "Show Detail Disk"
    df -h --total --exclude-type=tmpfs --exclude-type=devtmpfs --exclude-type=overlay
    echo "Show Detail Librarry"
    apt list --installed 2>/dev/null | grep -E -h 'ssh' | grep -E -v 'lib'
    apt list --installed 2>/dev/null | grep -E -h 'apache2' | grep -E -v 'libapache2'
    apt list --installed 2>/dev/null | grep -E -h 'clamav' | grep -E -v 'libclamav'
    apt list --installed 2>/dev/null | grep -E -h 'fail2ban'
    apt list --installed 2>/dev/null | grep -E -h 'jenkins'
    apt list --installed 2>/dev/null | grep -E -h 'logwatch' | grep -E -v 'liblogwatch'
    apt list --installed 2>/dev/null | grep -E -h 'mysql-community' | grep -E -v 'libmysql'
    apt list --installed 2>/dev/null | grep -E -h 'php' | grep -E -v 'libphp'
    apt list --installed 2>/dev/null | grep -E -h 'spamassassin' | grep -E -v 'libsapamassassin'
    apt list --installed 2>/dev/null | grep -E -h 'docker'
    apt list --installed 2>/dev/null | grep -E -h 'postgresql'
    apt list --installed 2>/dev/null | grep -E -h 'wildfly'
    apt list --installed 2>/dev/null | grep -E -h 'samba'
    apt list --installed 2>/dev/null | grep -E -h 'teleport'
    } 2>&1 | tee -a $pathlogs/logs-detail-$current_datetime.log
    echo "Show Detail Exit Code: $?" >> $pathlogs/logs-detail-$current_datetime.log
}

apt_upgrade(){
    echo "Proses APT Upgrade!"
    {
        sudo apt-get upgrade -y
    } 2>&1 | tee -a $pathlogs/logs-upgrade-$current_datetime.log
    echo "APT Upgrade Exit Code: $?" >> $pathlogs/logs-upgrade-$current_datetime.log
}

show_menu() {
    echo "Welcome!"
    echo "1. Update Repository Server"
    echo "2. Update Databases Clamav"
    echo "3. Clamscan"
    echo "4. Show Detail Server"
    echo "5. APT Upgrade"
    echo "0. Exit"
}

# Main loop
while true; do
    show_menu
    read -p "Pilih opsi: " option
    case $option in
        1)
            apt_update
            exit
            ;;
        2)
            freshclam_update
            exit
            ;;
        3)
            clamscan &
            exit
            ;;
        4)
            show_detail &
            exit
            ;;
        5)
            apt_upgrade &
            exit
            ;;
        0)
            echo "Keluar."
            exit
            ;;
        *)
            echo "Opsi tidak valid."
            ;;
    esac
    echo
done
