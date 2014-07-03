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

#grip startr (filename)	//makes a new file and starts a new git repository.
#						//default will make a file called README and open in prefered text editor



#grip startb name	

#grip me

#grip setme	

#grip syncr name




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

function startr_tell_github() {
	NAME=$1
	token=""
	username="SalvatoreTosti"
	url="https://api.github.com/user/repos"
	
	name="\"name\""
	arg1="\"$NAME\""
	
	op1="$name: $arg1"
	
	autoinit="\"auto_init\""
	arg2="true"
	op2="$autoinit: $arg2"
	
	private="\"private\""
	arg3="false"
	op3="$private: $arg3"
	
	curl -i -H 'Authorization: token '"$token"'' -d '{ '"$op1"', '"$op2"', '"$op3"' }' $url
	
	
	#curl -i -H 'Authorization: token d30e3e152ab490f38d96aa4b08eff9f4581329cf' -d '{ "name": "test", "auto_init": true, 	"private": false }' https://api.github.com/user/repos
}

function startr() {
	if [ $1 ]; then
		startr_tell_github "$1"
	else
		echo "Please enter a name for the new repository."
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
	startr)
	startr "$2"
	
	;;
	*)
	echo "other"
		help_func
	;;
esac






