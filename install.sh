#!/usr/bin/env bash
set -e

REPO="frost-head/geniusCLI"
RAW="https://raw.githubusercontent.com/$REPO/main"
SCRIPT="genius.sh"
REQ="requirements.txt"

echo "🚀 Installing geniusCLI..."

# Determine OS and package manager
install_sysdeps() {
  echo "🔧 Installing tmux, tree, python3-pip..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y tmux tree python3-pip
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y tmux tree python3-pip
    elif command -v yum &>/dev/null; then
      sudo yum install -y tmux tree python3-pip
    else
      echo "❌ Unsupported Linux package manager"
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install tmux tree python
  else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
  fi
}

install_pipdeps() {
  echo "📥 Fetching Python dependencies: $REQ"
  curl -fsSL "$RAW/$REQ" -o /tmp/$REQ
  echo "🐍 Installing pip packages from $REQ..."
  pip3 install -r /tmp/$REQ
  rm /tmp/$REQ
}

install_cli() {
  echo "📥 Downloading CLI script: $SCRIPT"
  curl -fsSL "$RAW/$SCRIPT" -o /tmp/genius
  sudo mv /tmp/genius /usr/local/bin/genius
  sudo chmod +x /usr/local/bin/genius
  echo "✅ Installed CLI as 'genius'"
}

install_sysdeps
install_pipdeps
install_cli

echo "🎉 Installation complete! Run 'genius' to start."
