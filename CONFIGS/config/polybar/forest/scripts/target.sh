#!/bin/bash

FILE=/tmp/target
RED='\033[0;31m'

if [ $# -eq 0 ]; then
	if [ -e "$FILE" ]; then
		cat $FILE
	else
		printf "No Target"
	fi
elif [ $1 == "reset" ]; then
	rm /tmp/target
else
	echo $1 > $FILE
fi
