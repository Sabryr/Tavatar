#!/bin/bash
#Script to print history of a nother terminal
#used for keeping a list of commands used 
#so students can follow, if fall behind
#for this to work, history must be redirected as follows
#export HISTFILE=$SHARED_HISTORY_FILE
#On the working terminal 
# export  PROMPT_COMMAND="history -a"
#export  SHARED_HISTORY_FILE=<the histotory file>
# export HISTFILE=$SHARED_HISTORY_FILE
 
export PS1="\# "
last_printed="NA"
WEB_SERVER_DIR="pariganaka.uio.no:~/www_docs/"
i=1;
echo "<html> <head> <title>History</title> <meta http-equiv=\"refresh\" content=\"3\" />  </head>  <body><ol type=\"1\">" > history.html
while [ $? -eq "0" ]; 
do
	last=$(tail -n 1 $SHARED_HISTORY_FILE)
	last_base=$(echo $last | awk '{print $1}')
	which "$last_base"  > /dev/null 2>&1
	if [  $? -eq "0" ] 
        then
		if [ "$last" != "$last_printed" ] 
		then
			echo $i". "$last
			sed -i -- '/\/body/d'  history.html
			echo "<li>$last</li>" >> history.html
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