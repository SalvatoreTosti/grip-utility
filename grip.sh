#!/bin/sh
#grip.sh

#Key for reading comments
#!!!NOTE: - indicates an idea or thought about program future development / execution.
#!!!TODO: - indicates a piece of the program which should be revisited at a later date.

#grip update f1 f2 	//update one file relative to another using rsync
#					//then commit changes via git
#git commit --message=
#grip syncr name
#grip startb name
#grip nameme
#grip mailme
#grip megn		//show git name (local git name) and ask if user wants to change it.
#grip mehn		//show github name (github user account name) and ask if user wants to change it.		

#grip save REPO_NAME //commits changes and then pushes changes to REPO_NAME
#grip sync source dest 	//copies all files from source into dest (via rsync)
#					   	//simultaneously adding all new files to git's watch via add
#						//finally, it commits this change to the dest repo
#grip new file.txt	//makes a new file called 'file.txt' in prefered editor
#					//then git adds 'file.txt'
#grip startr (filename)	//makes a new file and starts a new git repository.
#						//default will make a file called README and open in prefered text editor

#grip me		//show all information in grip_info file
#grip purgeme	//delete all information in grip_info file

function help_func() { #named as such to prevent overlap with default 'help' in unix
	#statements
	echo "grip is a script which extends and bundles some git functionalities."
	echo "new - creates a new file and commits it to the active git repository."
	echo "Template: grip new <filename>"
	echo "init - initializes a new user"
	echo "startr - "
}

function new() {
	FILE=$1
	if [ -f $FILE ]; then
		echo "File '$FILE' already exists."
	else
		touch $FILE
		open -t $FILE
		git add $FILE	
	fi
}

function startrCloneHelper() {
	GITHUBUSERNAME=$1
	REPONAME=$2
	echo git://github.come/$GITHUBUSERNAME/$REPONAME
	git clone git://github.com/$GITHUBUSERNAME/$REPONAME
}

function startrTellGithub() {
	#!!!TODO: have the initializer start a repo and a new branch called 'development'
	source $GRIPFILE
	REPONAME=$1
	token="$GITHUBAPITOKEN"	#get a token from Github and put inside the quotes, it's just that easy!
	url="https://api.github.com/user/repos"
	
	name="\"name\""
	arg1="\"$REPONAME\""
	
	op1="$name: $arg1"
	
	autoinit="\"auto_init\""
	arg2="true"
	op2="$autoinit: $arg2"
	
	private="\"private\""
	arg3="false"
	op3="$private: $arg3"
	
	resp=$(curl -silent -i -H 'Authorization: token '"$token"'' -d '{ '"$op1"', '"$op2"', '"$op3"' }' $url)

	httpLine=$(jsonHelper "$resp" 1)

	returnCode=`echo $httpLine | cut -c10-13`
	#201 is returned upon successful completion
	#422 is returned if it's already created
	#401 is returned if user has invalid API code
	if [ $returnCode -eq "201" ]; then
		echo "New repository $REPONAME was created!"
		startrCloneHelper $GITHUBUSERNAME $REPONAME
	elif [ $returnCode -eq "422" ]; then
		echo "Repository $REPONAME already exists for this user." 
	elif [ $returnCode -eq "401" ]; then
		echo "Your Github API code is invalid."
	else 
		echo "An error occoured, HTTP: $returnCode"
	fi
	
	#curl -i -H 'Authorization: token d30e3e152ab490f38d96aa4b08eff9f4581329cf' -d '{ "name": "test", "auto_init": true, 	"private": false }' https://api.github.com/user/repos
}

function startr() {
	if [ $1 ]; then
		startrTellGithub "$1"	
	else
		echo "Please enter a name for the new repository."
	fi
}

function jsonHelper() {
	#Template:  jsonHelper <JSON_to_be_parsed> <line_number_to_return>
	#!!!NOTE: returns "" if line number is out of range
	local JSON=$1
	local LINENUM=$2
	local cntr=1
	local result=""
	oldIFS=$IFS
	IFS=$'\n'
	for line in $JSON; do
		if [ $cntr == $LINENUM ]; then
			result=$line
			break 
		fi		
	cntr=$((cntr+1))
	done
	echo $result
	IFS=$oldIFS
}

function getNameHelper() {
	echo "Please enter your name for git: "
	read input_variable
	echo "You entered: $input_variable"
}

function initGripFileHelper() {
	 #GITNAME=$(git config user.name)
	 #GITEMAIL=$(git config user.email)
	 echo $GITNAME
	 echo $GITEMAIL
	 if [ -z "$GITNAME" ]; then
	 	echo "Please enter your name for git: "
	 	read input_variable
	 	NEWNAME=$input_variable
		git config user.name "$NEWNAME"
		GITNAME=$NEWNAME
	 fi
	 if [ -z "$GITEMAIL" ]; then
		 echo "Please enter your email for git: "
		 read input_variable
		 NEWEMAIL=$input_variable
		 #echo "$NEWEMAIL"
		 git config user.email "$NEWEMAIL"
		 GITEMAIL=$NEWEMAIL
	 fi
}

function initializeHelper() {
	source $GRIPFILE
	initGripFileHelper 
	
	USERNAME=$GITHUBUSERNAME
	NOTE="grip API for "$GITNAME""
	
	if [ -z "$GITHUBAPITOKEN" ]; then
		resp=$(curl -silent -i -u $USERNAME -d '{"scopes": ["repo","public_repo"], "note": '"\"$NOTE\""'}' https://api.github.com/authorizations)
		
		httpLine=$(jsonHelper "$resp" 1) 
		returnCode=`echo $httpLine | cut -c10-13`
		if [ $returnCode -eq "201" ]; then
			echo "New token generated for grip."
		elif [ $returnCode -eq "422" ]; then
			echo "A token has already been created under the note \""$NOTE"\""
			exit 1 
		else 
			echo "An error occoured, HTTP: $returnCode"
			exit 1
		fi
		
		tokenLine=$(jsonHelper "$resp" 33)
		token=$(echo $tokenLine | cut -c11-)	#remove leading token junk
		token=$(echo "${token%?}")	#remove trailing quote
		token=$(echo "${token%?}")	#remove trailing comma
		tokenString="GITHUBAPITOKEN=$token"
		echo $tokenString >> grip_info.txt
	else
		echo "API key has already been initialized."
	fi
}

function replaceHelper() {
	Key=$1
	New=$2
	File=$3
	#Template:  replaceHelper $Key $New $File
	#this should be used to replace any line containing $Key 
	#with $New in document $File
	sed -i "" 's/^'"$Key"'.*/'"$New"'/' $File
}

function meHelper() {
	#!!!TODO: I should make this output prettier with some nice text replacement
	FILE=$GRIPFILE
	for line in `cat $FILE`; do
		echo "$line"
	done < "$FILE"
}

function meGitNameHelper() {
	#echo "Git name helper"
	echo $(git config user.name)
}

function meGithubNameHelper() {
	echo "Github name helper"
}

GRIPFILE="./grip_info.txt"

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
	init)
	initializeHelper "$2"
	;;
	me)
	meHelper
	;;
	test)
	initGripFileHelper
	;;
	*)
	help_func
	;;
esac






