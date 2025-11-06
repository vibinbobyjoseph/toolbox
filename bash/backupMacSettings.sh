#!/bin/bash
# -----------------------------------------------------------------------------
# backupMacSettings.sh
#
# This script backs up key macOS configuration and application files,
# compresses them, and securely copies the archive to a remote server (bytebase).
# It checks that the server is reachable and the destination drive is mounted
# before proceeding. Intended for regular or manual backup of developer settings.
#
# Usage: Run manually to archive and upload macOS settings and dotfiles.
# -----------------------------------------------------------------------------

SERVER="bytebase"
MOUNT_POINT="/media/internal"

echo "Checking if $SERVER is available..."
# Check if server is accessible
ssh -q $SERVER 'exit'
if [ $? -ne 0 ]; then
    echo "Server is not reachable."
    exit 1
fi

# Check if the drive is mounted
if ! ssh $SERVER "mount | grep -q $MOUNT_POINT"; then
    echo "Drive $MOUNT_POINT is not mounted."
    exit 1
fi

# If all checks pass, copy files
echo "Server is accessible and drive is mounted. Proceeding with file copy..."
# Your file copy command here

folder=$(date "+%Y_%m_%d_%H_%M_%S")
echo ~/Documents/Other/SoftwareSettings/$folder/

mkdir -p ~/Documents/Other/SoftwareSettings/$folder/
rsync -az /etc/my.cnf ~/Documents/Other/SoftwareSettings/$folder/mysql/; echo "adding: my.cnf"
rsync -az ~/.zshrc ~/Documents/Other/SoftwareSettings/$folder/; echo "adding: .zshrc"
rsync -az ~/.vimrc ~/Documents/Other/SoftwareSettings/$folder/; echo "adding: .vimrc"
rsync -az ~/.gitconfig ~/Documents/Other/SoftwareSettings/$folder/; echo "adding: .gitconfig"
rsync -az ~/.gitignore_global ~/Documents/Other/SoftwareSettings/$folder/; echo "adding: .gitignore_global"
rsync -az ~/.m2/settings.xml ~/Documents/Other/SoftwareSettings/$folder/.m2/; echo "adding: .m2/settings.xml"
rsync -az ~/.m2/settings-docker.xml ~/Documents/Other/SoftwareSettings/$folder/.m2/; echo "adding: .m2/settings-docker.xml"
rsync -az ~/.ssh/config ~/Documents/Other/SoftwareSettings/$folder/.ssh/; echo "adding: .ssh/config"
rsync -az ~/.config/karabiner/ ~/Documents/Other/SoftwareSettings/$folder/karabiner; echo "adding: karabiner files"
rsync -az ~/.hammerspoon ~/Documents/Other/SoftwareSettings/$folder/hammerspoon; echo "adding: hammerspoon files"
rsync -az /Users/josephv/Library/Application\ Support/Choosy/behaviours.plist ~/Documents/Other/SoftwareSettings/$folder/choosy/; echo "adding: Choosy files"
rsync -az /Users/josephv/Library/Application\ Support/Alfred ~/Documents/Other/SoftwareSettings/$folder/; echo "adding: Alfred setttings and workflows"
rsync -az ~/usrbin/scripts/* ~/Documents/Other/SoftwareSettings/$folder/scripts/; echo "adding: ~/usrbin/scripts"
rsync -az ~/usrbin/saved_settings/table_plus/Connection* ~/Documents/Other/SoftwareSettings/$folder/tableplus/; echo "adding: table_plus connection and favourites"
rsync -az ~/usrbin/saved_settings/table_plus/Favorite/* ~/Documents/Other/SoftwareSettings/$folder/tableplus/Favorite/; 
rsync -az ~/usrbin/saved_settings/other/* ~/Documents/Other/SoftwareSettings/$folder/other/; echo "adding: others saved settings"
rsync -az /etc/hosts ~/Documents/Other/SoftwareSettings/$folder/; echo "adding: /etc/hosts"
cd ~/Documents/Other/SoftwareSettings/ && tar -czf $folder.tar.gz $folder; echo "tarring & zipping..."
echo "Copying zipped file to $SERVER..."
rsync -az $folder.tar.gz bytebase:~/internal/ImportantFiles/SoftwareSettings/; echo "Copy Complete!!"
trash $folder.tar.gz
