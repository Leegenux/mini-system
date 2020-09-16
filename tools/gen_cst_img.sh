#!/bin/bash

# Make sure the folder exists
#initDir='/home/leegenux/initDir'

outcome=./initramfs-mini-system.img

if [ $1 ] ; then
	if [ -d $1 ] ; then
		initDir=`realpath $1`
		read -p "The initDir is $initDir, Enter to contineu..." tmp
	else
		echo "Please provide a valid rootfs."
		exit 1
	fi
else
	initDir='/home/leegenux/initDir'
fi


if [ ! -d $initDir ] ; then # The Directory doesn't exist
	echo "Sorry there is no valid rootfs in $initDir, please provide one"
	exit 0
fi

# Make sure that you are executing the script with root privilege
if [ $(whoami) != root ] ; then
	echo "Please execute as root"
	exit 0
fi

# compress the initDir
cd $initDir
find . -print0 | cpio --null -ov --format=newc | xz -9 --check=crc32 --format=xz > $outcome

echo "The initramfs has already been created as $outcome"
