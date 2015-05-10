#! /usr/local/bin/zsh

# script to create a full system backup, saved on
# an encrypted external ZFS drive called "BACKUP"
echo FULL SYSTEM BACKUP
echo

# set variables
disk=/dev/gpt/BACKUP
disk_pool=BACKUP_EXT
sys_pool=zroot
# set constants
bdir=/BACKUP_EXT/backups_main/
name="bkup_$(date +'%d-%m-%Y')"
folder="$bdir$name"

# check if user is root
if [ "$USER" = 'root' ]; then {
	# check if BACKUP disk is connected
	if [ -c $disk ]; then {
		geli attach $disk
		zpool import $disk_pool
		echo DISK "BACKUP": attached
		
		# check if backup directory is mounted
		# and if so: create folder and backup
		if [ -d $bdir ]; then {
			mkdir $folder
			zfs snapshot -r $sys_pool@backup
                        zfs send -Rv $sys_pool@backup | gzip > $folder/$sys_pool.zfs.gz
			zfs destroy -r $sys_pool@backup
			echo BACKUP: successfully created
		} else {
    			echo DIRECTORY: not mounted
			echo BACKUP: not created
		} fi

		zpool export $disk_pool
		geli detach $disk
		echo DISK "BACKUP": detached
	} else {
		echo DISK "BACKUP": not connected
	} fi
} else {
	echo USER: not root
} fi
