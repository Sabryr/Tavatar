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
connect () {
	echo "function"
	export PS1="\# "
	export SHARED_HISTORY_FILE=$HOME/.online_history
	export HISTFILE=$SHARED_HISTORY_FILE
	last_printed="NA"
	i=1;
	#echo "<html> <head> <title>History</title> <meta http-equiv=\"refresh\" content=\"3\" />  </head>  <body><ol type=\"1\">" > history.html
	while [ $? -eq "0" ]; 
	do
        	last=$(tail -n 1 $SHARED_HISTORY_FILE)
        	last_base=$(echo $last | awk '{print $1}')
        	which "$last_base"  > /dev/null 2>&1
        	if [[  $? -eq "0" ]] || [[ "$last" == *http* ]]
        	then
                	if [ "$last" != "$last_printed" ]
                	then
                        	echo "$last"
				#echo $i". "$last
                        	#sed -i -- '/\/body/d'  history.html
                        if [[ "$last" == *http* ]]
                        then
                                last_m=$(echo "$last" | sed "s/#//")
                		#echo "<li><a href=\"$last_m\"> $last_m</a></li>" >> history.html
                        else	
				echo "else"
                                #echo "<li>$last</li>" >> history.html
                        fi
                        echo "end"
			#echo " </ol> </body> </html>" >> history.html
                        #scp history.html $WEB_SERVER_DIR > /dev/null 2>&1
                        last_printed="$last"
                        i=$((i+1))
                	fi
        	fi
		sleep 2
	done;
}

setterm () {
	export  PROMPT_COMMAND="history -a"
	export  SHARED_HISTORY_FILE=$HOME/.online_history
	export HISTFILE=$SHARED_HISTORY_FILE
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
else
	echo "Print help"
fi


