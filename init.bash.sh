TAVATAR_LOG=~/.tavatar_history

BASH_LOG=~/demos.out
bash_log_commands () {
    # https://superuser.com/questions/175799
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    # don't cause a preexec for $PROMPT_COMMAND
    [[ "$PROMPT_COMMAND" =~ "$BASH_COMMAND" ]] && return
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    echo "$this_command" >> "$TAVATAR_LOG"
}
trap 'bash_log_commands' DEBUG
