#!/bin/bash
# -----------------------------------------------------------------------------
# postRestart.sh
#
# This script unlocks and mounts encrypted drives (sdb and sdc) after a reboot,
# sets ACL permissions for rslsync on cloud backup directories,
# and force-reloads the minidlna service.
#
# Usage: Run after system restart to restore access to encrypted storage and services.
# -----------------------------------------------------------------------------
echo "Enter sudo password"
sudo :
echo "Unlocking sdb"
sudo cryptsetup open /dev/sdb internal 
echo "Mounting sdb"
sudo mount /dev/mapper/internal /media/internal/
echo "Unlocking sdc"
sudo cryptsetup open /dev/sdc external 
echo "Mounting sdc"
sudo mount /dev/mapper/external /media/external/
echo "Setting cloud permissions"
sudo setfacl -R -m "u:rslsync:rwx" /home/josephv/internal/Cloud_Backup/Company
sudo setfacl -R -m "u:rslsync:rwx" /home/josephv/internal/Cloud_Backup/Private_Cloud
echo "force loading minidlna"
sudo service minidlna force-reload
