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


