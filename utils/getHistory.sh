#!/bin/bash  
current_shell=$(basename "$SHELL")

case "$current_shell" in
  bash)
    hist_file="$HOME/.bash_history"
    ;;
  zsh)
    hist_file="$HOME/.zsh_history"
    ;;
  fish)
    hist_file="$HOME/.local/share/fish/fish_history"
    ;;
  *)
    echo "Unknown shell: $current_shell"
    hist_file=""
    ;;
esac


if [ -f "$hist_file" ]; then
  last_10_commands=$(tail -n 5 "$hist_file" | awk -F ';' '{print $2}')
else
  last_10_commands="No history available"
fi
