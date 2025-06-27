#!/bin/bash

CONVO_FILE="/tmp/conversation_log.txt"
LOG_FILE="/tmp/geniusCLI.log"
> "$CONVO_FILE"  # Overwrite each run
> "$LOG_FILE"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

help (){
  echo "
    you can exit by typing                          '/bye'
    you can ask for help by typing                  '/help'
  "
}





while true; do
  /usr/local/geniusCLI/utils/getHistory.sh
  echo "$last_10_commands" > /tmp/shell_history.txt

  echo ""
  read -p ">> " question
  echo ""
  
  if [ "$question" = "/bye" ]; then
    log "User exited."
    exit
  elif [ "$question" = "/help" ]; then
    help
    log "Displayed help menu."
    continue
  fi

  log "User question: $question"
  echo "User: $question" >> "$CONVO_FILE"

  cur_dir=$(tmux display -p -t ':.+1' "#{pane_current_path}")
  file_tree=$(tree -L 2 "$cur_dir")
  last_output=""
  file_context=$(<"/usr/local/geniusCLI/context_file.txt")
  conversation_context=$(tail -n 5 "$CONVO_FILE")

  log "Running Gemini API..."
  python3 "/usr/local/geniusCLI/API/gemini.api.py" \
    --cur_dir "$cur_dir" \
    --question "$question" \
    --last_10_commands "$last_10_commands" \
    --file_tree "$file_tree" \
    --last_output "$last_output" \
    --conversation_context "$conversation_context" \
    --file_context "$file_context" > response.txt 2>&1

  if [ $? -ne 0 ]; then
    log "ERROR: Gemini API script failed. Check response.txt"
  else
    log "Gemini API call successful."
  fi

  python3 -m rich.markdown response.txt

  /usr/local/geniusCLI/Parse/parse.sh "response.txt"
  log "Parsed response.txt"

  if [ -s "/tmp/execute.txt" ]; then  
    echo "found the following commands"
    cat /tmp/execute.txt
    echo " "

    read -p "Would you like to run the suggested commands? (y/N): " ch
    echo " "

    if [ "$ch" = "y" ]; then
      log "User confirmed execution. Running commands from /tmp/execute.txt"
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        tmux send-keys -t :.0 "$line" C-m
        log "Executed: $line"
      done < /tmp/execute.txt
      echo "done executing"
    else
      log "User declined command execution."
    fi
  else
    log "response.txt is empty or missing."
  fi

  response=$(<response.txt)
  echo "LLM: $response" >> "$CONVO_FILE"
  log "Appended LLM response to conversation log."
done
