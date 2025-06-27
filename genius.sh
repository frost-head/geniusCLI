# !/bin/bash
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo $SCRIPT_DIR
SESSION_NAME="geniusCLI"
COMMAND="./main.sh"
TMUX_CONF="./utils/tmux.conf"

if tmux -f "$TMUX_CONF" has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux -f "$TMUX_CONF" attach-session -t "$SESSION_NAME"
else
  tmux -f "$TMUX_CONF" new-session -d -s "$SESSION_NAME"


  tmux split-window -h -t "$SESSION_NAME"

  # Resize left pane to 2/3 width
  tmux select-pane -t "$SESSION_NAME:0.0"
  tmux resize-pane -x $(( $(tput cols) * 4 / 6 ))

  # Run command in right pane
  tmux send-keys -t "$SESSION_NAME:0.1" "$COMMAND" C-m

  tmux attach-session -t "$SESSION_NAME"
fi