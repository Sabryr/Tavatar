#!/bin/bash
#Script to print history of a nother terminal
#used for keeping a list of commands used 
#so students can follow, if fall behind
#for this to work, history must be redirected as follows
#On the working terminal 
# export  PROMPT_COMMAND="history -a"
# export  SHARED_HISTORY_FILE=$HOME/.online_history
# export HISTFILE=$SHARED_HISTORY_FILE

DOC_NM=""
VERSION="0.1"
ENV_NM="$HOME/.tavatar_env"
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
		if [[  $? -eq "0" ]] || [[ "$last" == *http* ]] || [[ "$last" == *STOP* ]]
        	then
			if [[ "$last_base" == "STOP" ]]
			then
				echo "END" >> $SHARED_HISTORY_FILE
				exit 0
			elif [ "$last" != "$last_printed" ]
                	then
                        	last_printed="$last"
				echo "$last_printed"
				send-togoogle-client "$last_printed"
                        elif [[ "$last" == *http* ]]
                        then
				echo "$last_printed"
				send-togoogle-client "$last_printed"
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
	 python  google-client.py $DOC_NM 1 "$1"
}

reset () {
	echo "History cleaned"
        rm $HOME/.online_history
}

create_env () {
	ls $ENV_NM  > /dev/null 2>&1
	if [[ !   $? -eq "0" ]]
	then
		echo "Creating Python environemnt "
		tavatar_dir=$(which tavatar.sh) 
		echo "tavetar in $tavatar_dir"
		#virtualenv $ENV_NM
		source $ENV_NM/bin/activate
		pip install -r requirements.txt
	else
		source $ENV_NM/bin/activate
	fi
}

help () {
	echo "Usage"
	echo "Open two terminals and on on"
	echo "./tavatar.sh MAIN"
	echo "On the other"
	echo "./tavatar.sh CONNECT <Google doc ID>"

}
#create_env

get DOC_NM() {
	if [ -z "$var" ]
	then
		echo "\$var is empty"
		if [ -f "$DOC_NM" ]
		then
			echo "File found $DOC_NM"
		else
			 echo "file not found $DOC_NM"
		fi
	else
		echo "\$var is NOT empty"
	fi
}

if [[ $# -eq 0 ]] 
then
	help
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
	if [[ $# -eq 2 ]]
	then
		DOC_NM="$2"
		echo "Connect"
		connect
	else
		help
	fi
elif [ "$1" == "CLEAN" ]
then
	echo "History cleaned"
	rm $HOME/.online_history
else
	echo "Print help"
fi
