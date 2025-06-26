#!/bin/bash

parse_code_blocks() {
  local input="$1"
  local output="/tmp/execute.txt"

  rm "$output"
  touch "$output"

  awk '
    BEGIN { in_block=0 }
    /^\s*```/ {
      in_block = !in_block
      next
    }
    in_block {
      print
    }
  ' "$input" >> "$output"

  chmod +x "$output"

}

parse_code_blocks "$1"
