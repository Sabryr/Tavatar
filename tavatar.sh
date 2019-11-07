#!/bin/bash
#Script to print history of a nother terminal
#used for keeping a list of commands used 
#so students can follow, if fall behind
#for this to work, history must be redirected as follows
#On the working terminal 
# export  PROMPT_COMMAND="history -a"
# export  SHARED_HISTORY_FILE=$HOME/.online_history
# export HISTFILE=$SHARED_HISTORY_FILE

DOC_NM="1VQ4lUr1hrrKQwOAYa2z0h-0xltBm1PEuQLY8VksWk7c"
VERSION="0.1"
connect () {
	echo "function"
	export PS1="\# "
	export SHARED_HISTORY_FILE=$HOME/.online_history
	export HISTFILE=$SHARED_HISTORY_FILE
	last_printed="NA"
	i=1;
	while [ $? -eq "0" ]; 
	do
		last=$(tail -n 1 $SHARED_HISTORY_FILE)
        	last_base=$(echo $last | awk '{print $1}')
        	which "$last_base"  > /dev/null 2>&1
        	if [[  $? -eq "0" ]] || [[ "$last" == *http* ]]
        	then
                	if [ "$last" != "$last_printed" ]
                	then
                        	last_printed="$last"
				echo "$last_printed"
				send-togoogle-client $last_printed
                        elif [[ "$last" == *http* ]]
                        then
				echo "$last_printed"
				send-togoogle-client $last_printed
                                #last_printed= "$last"
				#last_m=$(echo "$last" | sed "s/#//")
                		#echo "<li><a href=\"$last_m\"> $last_m</a></li>" >> history.html
                        fi
                        i=$((i+1))
        	fi
		sleep 2

	done;
}

setterm () {
	echo "#Tavatar connect" > $HOME/.tavatar
	echo "export  PROMPT_COMMAND=\"history -a\"" >> $HOME/.tavatar 
	echo "export  SHARED_HISTORY_FILE=$HOME/.online_history" >> $HOME/.tavatar
	echo "export  HISTFILE=$HOME/.online_history" >> $HOME/.tavatar
	echo "source $HOME/.tavatar"
}

send-togoogle-client () {
	 python  google-client.py $DOC_NM 1 $1
}

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
	setterm
elif [ "$1" == "CONNECT" ]
then
	echo "Connect"
	connect
elif [ "$1" == "CLEAN" ]
then
	echo "History cleaned"
	rm $HOME/.online_history
else
	echo "Print help"
fi
