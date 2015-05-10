#! /usr/local/bin/zsh

# script to create a full system backup, saved on
# an encrypted external ZFS drive called "BACKUP"
echo SYSTEM BACKUP

# set variables
disk=/dev/gpt/BACKUP
bdir=/BACKUP_EXT/backups_main/
name="bkup_$(date +'%d-%m-%Y')"
folder="$bdir$name"

# check if user is root
if [ "$USER" = 'root' ]; then {
	# check if BACKUP disk is connected
	if [ -c $disk ]; then {
		geli attach /dev/gpt/BACKUP
		zpool import BACKUP_EXT
		echo DISK "BACKUP": attached
		
		# check if backup directory is mounted
		# and if so: create folder and backup
		if [ -d $bdir ]; then {
			mkdir $folder

			echo BACKUP: successfully created
		} else {
    			echo DIRECTORY: not mounted
			echo BACKUP: not created
		} fi

		zpool export BACKUP_EXT
		geli detach /dev/gpt/BACKUP
		echo DISK "BACKUP": detached
	} else {
		echo DISK "BACKUP": not connected
		exit 1
	} fi
} else {
	echo USER: not root
	exit 1
} fi
