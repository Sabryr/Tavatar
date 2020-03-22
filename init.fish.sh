TAVATAR_LOG=~/.tavatar_history

function cmd_log --on-event fish_preexec ; echo "$argv" >> "$TAVATAR_LOG"  ; end
