#!/bin/sh
#install.sh
#This script will install grip so it is usable from the command line.

GRIPFILE=""$HOME/grip""

function main(){
	if [ ! -d "$GRIPFILE" ]; then
		mkdir "$GRIPFILE"
		echo "does not exist"
	fi
	
	if [ ! -f "$GRIPFILE/grip_info.txt" ]; then
		touch "$GRIPFILE/grip_info.txt"
	fi
	
	if [ ! -f "$GRIPFILE/grip.sh" ]; then
		cp grip.sh "$GRIPFILE/grip.sh"
	fi
	#sh "$GRIPFILE/grip.sh" init
}	

main