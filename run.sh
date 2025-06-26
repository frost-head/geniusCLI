#!/bin/bash

SESSION_NAME="my_session"
COMMAND="./main.sh"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux attach-session -t "$SESSION_NAME"
else
  tmux new-session -d -s "$SESSION_NAME"
  
  # Split to create right pane
  tmux split-window -h -t "$SESSION_NAME"

  # Resize **left** pane (pane 0) to 2/3 of total width
  tmux select-pane -t "$SESSION_NAME:0.0"
  tmux resize-pane -x $(( $(tput cols) * 4 / 6 ))

  # Run command in right pane (pane 1)
  tmux send-keys -t "$SESSION_NAME:0.1" "$COMMAND" C-m

  tmux attach-session -t "$SESSION_NAME"
fi
