#!/bin/bash
# Script by Leegenux
# Note that this script should be placed under the installation folder when executed.

DEVICE=""
BASEDIR=$(realpath $(dirname $0))
cd $BASEDIR

part_device () {
	while [ -z $DEVICE ] || ! [ -b $DEVICE ] ; do
		read -p 'Please type in your devices file descriptor:' -i "/dev/sdb" -e DEVICE
	done

	read -p "Do you want to rebuild the partition table ? (Erases all the existing partitions and data) [Y/N] " -e CONFIRM 
	if [ x$CONFIRM == xY ] ; then 
		sudo sfdisk ${DEVICE} < disk.layout

		read -p "Do you want to format the partition to VFAT format ? (Erases all the data) [Y/N] " -e CONFIRM 
		if [ x$CONFIRM == xY ] ; then 
			sudo mkfs.vfat -F 32 ${DEVICE}1
		else
			exit 1
		fi
	else
		exit 1
	fi

}


install_files () {
	sudo mkdir mount_point
	sudo mount ${DEVICE}1 mount_point
	sudo cp -rfv efi_part/* mount_point/
	sudo cp -rfv boot_part/* mount_point/
	
	local UUID=$(sudo blkid -o value -s UUID ${DEVICE}1)
	local GRUBCFG=mount_point/grub/grub.cfg
	local VMLINUZ=$(ls mount_point/vmlinuz*  | rev | cut -d'/' -f1 | rev)
	local INITRD=$(ls mount_point/initramfs* | rev | cut -d'/' -f1 | rev)

	echo "UUID:" $UUID

	sudo bash -c "
	echo menuentry 'mini-system' {   		>> $GRUBCFG
	echo '  'load_video 		 		>> $GRUBCFG
	echo '  'insmod gzio 		 		>> $GRUBCFG
	echo '  'insmod part_gpt  		 	>> $GRUBCFG
	echo '  'linux /$VMLINUZ root=UUID=$UUID  	>> $GRUBCFG
	echo '  'initrd /$INITRD 			>> $GRUBCFG
	echo } 						>> $GRUBCFG
	"
	echo "umounting ..."
	sudo umount ${DEVICE}1
	sudo rmdir mount_point
	echo "done!"
}

part_device
install_files 
