#!/bin/bash
#Script to print history of a nother terminal
#used for keeping a list of commands used 
#so students can follow, if fall behind
#for this to work, history must be redirected as follows
#On the working terminal 
# export  PROMPT_COMMAND="history -a"
# export  SHARED_HISTORY_FILE=$HOME/.online_history
# export HISTFILE=$SHARED_HISTORY_FILE
 
export PS1="\# "
export SHARED_HISTORY_FILE=$HOME/.online_history
export HISTFILE=$SHARED_HISTORY_FILE
last_printed="NA"
WEB_SERVER_DIR="pariganaka.uio.no:~/www_docs/"
echo "webaddress: http://folk.uio.no/sabryr/history.html"
i=1;
echo "<html> <head> <title>History</title> <meta http-equiv=\"refresh\" content=\"3\" />  </head>  <body><ol type=\"1\">" > history.html
while [ $? -eq "0" ]; 
do
	last=$(tail -n 1 $SHARED_HISTORY_FILE)
	last_base=$(echo $last | awk '{print $1}')
	which "$last_base"  > /dev/null 2>&1
	if [[  $? -eq "0" ]] || [[ "$last" == *http* ]]
        then
		if [ "$last" != "$last_printed" ]
		then
			echo $i". "$last
			sed -i -- '/\/body/d'  history.html
			if [[ "$last" == *http* ]]
			then
				last_m=$(echo "$last" | sed "s/#//")
				echo "<li><a href=\"$last_m\"> $last_m</a></li>" >> history.html
			else
				echo "<li>$last</li>" >> history.html
			fi
			echo " </ol> </body> </html>" >> history.html
			scp history.html $WEB_SERVER_DIR > /dev/null 2>&1
			last_printed="$last"
			i=$((i+1))
		fi
	#else
	#	echo "Wrong command"
	fi

sleep 2
done;
