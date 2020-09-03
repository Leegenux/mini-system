#!/bin/bash


home=/home/leegenux
#libPath=$home/testPath
libPath=$home/initDir
irreduntancyDB=""

# Check if the path is valid
if [ ! -d $libPath ] ; then
	echo 'Not a valid initDir!'
	exit 0
fi

if [ ! $(whoami) == root ] ; then
	echo 'Please run this as root'
	exit 0
fi

mkdirCopy () {
	# Before copy, you should make sure that the source is valid

	# Make sure the path is valid
	path=`echo $2 | sed -E 's/\/([^/]+$)//g'`
	if [ ! -d $path ] ; then
		mkdir -p $path
	fi
	# Do the copy	
	if [ ! -f $2 ] ; then
		if [[ "`file $1 | grep 'symbolic link to'`" ]] ; then
			cp -vL $1 $2
		else
			cp -v $1 $2
		fi
		echo $2 >> $home/getLibDB
	else
		#echo "($2) exists"
		:
	fi
}

getLibOf () {
	irreduntancyDB=$2

	# Check if the lib is valid
	if [[ "$1" ]] && [ -f $1 ]  && [[ `file -L $1 | grep ELF` ]] ; then
		# Copy it
		mkdirCopy $1 ${libPath}$1 

		# Copy its deps
		line=''
		ldd $1 | grep "=> /" | awk '{print $3;}' | while IFS= read -r line ; do
			if [[ $irreduntancyDB == *$1* ]] ; then	
				:
			else
				irreduntancyDB=${irreduntancyDB}${line}
				getLibOf $line $irr$irreduntancyDB
			fi
		done
	else
		if [ x$1 != x ] ; then 
			echo "($1) is not a valid ELF file"
		else
			:
		fi
	fi
}

getLibOf $1 $irreduntancyDB


#echo $result | grep "=> /" | awk '{cmd="getLibOf $3"; system(cmd); print $3;}' | xargs -I '{}' sudo cp -v '{}' $libPath'{}'

#function cpAndCheckValidity () {
#	if [ $1 ] && [[ `file $1 | grep ELF` ]] ; then
#		sudo cp -v $1 ${libPath}$1
#	fi
#}
