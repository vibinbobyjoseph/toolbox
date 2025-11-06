#!/bin/bash
# -----------------------------------------------------------------------------
# resilioSyncBackup.sh
#
# This script creates compressed backups of Private_Cloud and Company directories
# from /home/josephv/internal/Cloud_Backup/, then uploads them to S3 storage.
# It checks that /media/internal/ and /media/external/ are mounted before running.
#
# Usage: Run as a scheduled backup job or manually to archive and upload data.
# -----------------------------------------------------------------------------
isMounted() {
	mountpoint -q /media/internal/ && mountpoint -q /media/external/
}

if isMounted >/dev/null; then
    echo "Directories mounted. Running backup on $(date +\"%Y-%m-%d\")"
    cd /home/josephv/internal/Cloud_Backup/ 
    echo "Backing up Private_Cloud"
    tar -cvzf Private_Cloud_$(date +"%Y-%m-%d").tar.gz -C /home/josephv/internal/Cloud_Backup/ --exclude=Private_Cloud/.sync Private_Cloud
    aws s3 cp /home/josephv/internal/Cloud_Backup/Private_Cloud_$(date +"%Y-%m-%d").tar.gz s3://bytebase-cloudstorage/Private_Cloud_$(date +"%Y-%m-%d").tar.gz
    echo "Backing up Company"
    tar -cvzf Company_$(date +"%Y-%m-%d").tar.gz -C /home/josephv/internal/Cloud_Backup/ --exclude=Company/.sync Company
    aws s3 cp /home/josephv/internal/Cloud_Backup/Company_$(date +"%Y-%m-%d").tar.gz s3://bytebase-cloudstorage/Company_$(date +"%Y-%m-%d").tar.gz
    echo "Backup job complete"
else
    echo "Directories not mounted. Cannot run backup on $(date +\"%Y-%m-%d\")"
fi
