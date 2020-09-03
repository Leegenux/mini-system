#!/bin/bash

# Make sure the folder exists
HOME=/home/leegenux
initDir=$HOME/initDir
img_path=$(realpath $1)

# Check $1
if [ $1 ] ; then
	if [ ! -f $1 ] ; then
		echo "No such initramfs: $1"
		exit 0
	fi
else
	echo "Please specify a valid initramfs image"
	exit 0
fi


# create initDir if not exists
if [ ! -f $initDir ] ; then
	mkdir -p $initDir
	read -p "Are you sure you want to overwrite your current initDir: $initDir ?
	Ctrl-C to exit...."  tmp
fi

# Make sure that you are executing the script with root privilege
if [ $(whoami) != root ] ; then
	echo "Please execute as root"
	exit 0
fi

# Decompress the initramfs into the $initDir
cd $HOME
echo "Removing old files"
rm -rvf ./initDir/*

cd $initDir
/usr/lib/dracut/skipcpio $img_path | xzcat | cpio -ivd

echo "Finished decompressing at directory $initDir"
