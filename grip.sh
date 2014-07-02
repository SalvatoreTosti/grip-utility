#!/bin/sh
#grip.sh
#bundle the scripts I use repeatedly relative to git

#rsync --update --progress -r CS_Lab_Spring_14/CoralImageAnalysis/ CS\ Summer\ 14/CoralImageAnalysis/
#git commit --message=

#Just hashing out some thoughts here
#grip update f1 f2 	//update one file relative to another using rsync
#					//then commit changes via git

#grip save REPO_NAME //commits changes and then pushes changes to REPO_NAME

#grip sync source dest 	//copies all files from source into dest (via rsync)
#					   	//simultaneously adding all new files to git's watch via add
#						//finally, it commits this change to the dest repo

#grip new file.txt	//makes a new file called 'file.txt' in prefered editor
#					//then git adds 'file.txt'
#

function help_func() { #named as such to prevent overlap with default 'help' in unix
	#statements
	echo "grip - A script which extends and bundles some git functionalities."
}

function new() {
	FILE=$1
	if [ -f $FILE ]; then
		echo "File '$FILE' already Exists."
	else
		touch $FILE
		open -t $FILE
		git add $FILE	
	fi
}


case "$1" in
	new)
	new "$2"
	;;
	sync)
	
	echo "sync"
	;;
	save)
	
	echo "save"
	;;
	*)
	echo "other"
		help_func
	;;
esac






