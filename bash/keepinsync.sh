#!/bin/bash
# -----------------------------------------------------------------------------
# This script is used to keep two mounted directories in sync on bytebase 
# as a cron job.
# 0 * * * * ~/usrbin/scripts/scriptorium/bash/keepinsync.sh internal external >> /tmp/keepinsync.log 2>&1
# 
# Synchronizes files between two mounted directories using rsync.
# Usage: ./keepinsync.sh <src> <des>
# <src> and <des> are the names of directories under /media/
# Both source and destination must be mounted directories.
# -----------------------------------------------------------------------------
usage() {
        echo ""
        echo "Usage : $0 <src> <des>"
        echo
        exit -1
}
test $# -ne 2 && usage
src=/media/$1/
des=/media/$2/
if mountpoint -q -- "$src" && mountpoint -q -- "$des"; 
then
	echo "syncing files from $src to $des"
	rsync -avz --delete $src $des
elif ! mountpoint -q -- "$src"; then
	echo "$src is not a mounted directory"
elif ! mountpoint -q -- "$des"; then
	echo "$des is not a mounted directory"
fi
