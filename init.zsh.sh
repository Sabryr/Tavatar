TAVATAR_LOG=~/.tavatar_history

preexec() { echo $1 >> "$TAVATAR_LOG" ; }
