#!/bin/bash

SESSION_NAME="my_session"
COMMAND="./main.sh"
TMUX_CONF="./utils/tmux.conf"

# Use custom tmux config
export TMUX_CONF
export TMUX="-f $TMUX_CONF"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux attach-session -t "$SESSION_NAME"
else
  tmux new-session -d -s "$SESSION_NAME"

  tmux split-window -h -t "$SESSION_NAME"

  # Resize left pane to 2/3 width
  tmux select-pane -t "$SESSION_NAME:0.0"
  tmux resize-pane -x $(( $(tput cols) * 4 / 6 ))

  # Run command in right pane
  tmux send-keys -t "$SESSION_NAME:0.1" "$COMMAND" C-m

  tmux attach-session -t "$SESSION_NAME"
fi
