#!/bin/bash
#Script to print history of a nother terminal
#used for keeping a list of commands used 
#so students can follow, if fall behind
#for this to work, history must be redirected as follows
#On the working terminal 
# export  PROMPT_COMMAND="history -a"
# export  SHARED_HISTORY_FILE=$HOME/.online_history
# export HISTFILE=$SHARED_HISTORY_FILE
 
VERSION="0.1"

if [[ $# -eq 0 ]] 
then
	echo "Print help"
elif [ "$1" == "-v" ]
then
	echo "Version $VERSION"
	exit 0;
elif [ "$1" == "MAIN" ]
then
	echo "Main"
elif [ "$1" == "CONNECT" ]
then
	echo "Connect"
else
	echo "Print help"
fi

connect () {
        export PS1="\# "
        export SHARED_HISTORY_FILE=$HOME/.online_history
        export HISTFILE=$SHARED_HISTORY_FILE
        last_printed="NA"
}


