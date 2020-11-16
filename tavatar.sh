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
HIST_NM="$HOME/.tavatar_history"
SCRIPT_PATH=$0

check_virtualenv () {
    # Check if Python and virtualenv are available.  Return 1 if not.
	which python  > /dev/null 2>&1
	if [[  $? -ne "0" ]]
   	then
        	which python3  > /dev/null 2>&1
        fi

	if [[  $? -eq "0" ]]
	then
		#echo "Python found $(which python)"
		which virtualenv  > /dev/null 2>&1
		if [[ ! $? -eq "0" ]]
		then
			echo "virtualenv not found please install this first and try again "
			exit 1
		fi
	else
		echo "This programs requires Python3"
		exit 1
	fi
}

connect () {
    # Main function to monitor the history file and send data to the doc.
	export PS1="\# "
	export SHARED_HISTORY_FILE=$HIST_NM
	export HISTFILE=$SHARED_HISTORY_FILE
	last_printed="NA"
	i=1;
	echo "History file is $SHARED_HISTORY_FILE"
	while [ $? -eq "0" ];
	do
		last=$(tail -n 1 $SHARED_HISTORY_FILE)
		#echo "$last"
        	last_base=$(echo $last | awk '{print $1}')
        	command -v "$last_base"  > /dev/null 2>&1
		if [[  $? -eq "0" ]] || [[ "$last" == *http* ]] || [[ "$last" == *STOP* ]]
        	then
			if [[ "$last_base" == "STOP" ]]
			then
				echo "END" >> $SHARED_HISTORY_FILE
				exit 0
			elif [ "$last" != "$last_printed" ]
                	then
                        	last_printed="$last"
                                printf "($i) $last_printed | "
                                if [ $(($i % 4)) == 0 ]
				then
					echo ""
  				fi
                                i=$((i+1))

				send-togoogle-client "$last_printed"

                        elif [[ "$last" == *http* ]]
                        then
                        	last_printed="$last"
				echo "$last_printed"
				send-togoogle-client "$last_printed"
                        fi
        	fi
		sleep 2

	done;
}

setterm () {
    # Do the terminal setup
    #cp $(dirname $0)/initsh ~/.tavatar
    #echo "#Tavatar connect" > $HOME/.tavatar
    #echo "export  PROMPT_COMMAND=\"history -a\"" >> $HOME/.tavatar
    #echo "export  SHARED_HISTORY_FILE=$HIST_NM" >> $HOME/.tavatar
    #echo "export  HISTFILE=$HIST_NM" >> $HOME/.tavatar
    echo "To initialize shell: source $(dirname $0)/init.bash.sh"
}

send-togoogle-client () {
	 python google-client.py $DOC_NM 1 "$1"
}

reset () {
	echo "Cleaning history"
        rm $HIST_NM
}

create_env () {
	check_virtualenv
	ls $ENV_NM  > /dev/null 2>&1
	if [[ !   $? -eq "0" ]]
	then
		echo "Creating Python environemnt "
		tavatar_dir=$0
		echo "tavetar in $tavatar_dir"
		# also works with python3: -p python3
		virtualenv $ENV_NM
		cp $SCRIPT_PATH  $ENV_NM/bin/
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

create_blank_hist () {
	if [ ! -f "$DOC_NM" ]
	then
		echo  > $HIST_NM
	fi

}

create_env

#get DOC_NM () {
#	if [ -z "$var" ]
#	then
#		echo "\$var is empty"
#		if [ -f "$DOC_NM" ]
#		then
#		echo "File found $DOC_NM"
#		else
#			 echo "file not found $DOC_NM"
#		fi
#	else
#		echo "\$var is NOT empty"
#	fi
#}

if [[ $# -eq 0 ]]
then
	help
elif [ "$1" == "-v" ]
then
	echo "Version $VERSION"
	exit 0;
elif [ "$1" == "MAIN" ]
then
	create_blank_hist
	echo "Main"
	setterm
elif [ "$1" == "CONNECT" ]
then
    create_blank_hist
    setterm
	if [[ $# -eq 2 ]]
	then
		DOC_NM="$2"
		connect
	elif [[ -f "$ENV_NM/$DOC_NM" ]]
	then
		echo "Reading Google document ID from $ENV_NM/$DOC_NM"
		DOC_NM=$(cat $ENV_NM/$DOC_NM)
	else
		help
	fi
elif [ "$1" == "CLEAN" ]
then
	reset
else
	help
fi
