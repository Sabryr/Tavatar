#!/bin/bash
#Script to print history of a nother terminal
#used for keeping a list of commands used 
#so students can follow, if fall behind
#for this to work, history must be redirected as follows
#export HISTFILE=$SHARED_HISTORY_FILE
 
export PS1="\# "
last_printed="NA"
WEB_SERVER_DIR=""
i=1;
echo "<html> <head> <title>History</title> <meta http-equiv=\"refresh\" content=\"3\" />  </head>  <body><ol type=\"1\">" > history.html
while [ $? -eq "0" ]; 
do
	last=$(tail -n 1 $SHARED_HISTORY_FILE)
	if [ "$last" != "$last_printed" ] 
	then
		echo $i". "$last
		sed -i -- '/\/body/d'  history.html
		echo "<li>$last</li>" >> history.html
		echo " </ol> </body> </html>" >> history.html
		scp history.html $WEB_SERVER_DIR
		last_printed="$last"
		i=$((i+1))
	fi
sleep 3
done;
