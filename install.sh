#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/frost-head/geniusCLI.git"
INSTALL_DIR="/usr/local/geniusCLI"
LINK_PATH="/usr/local/bin/genius"

echo "🚀 Installing geniusCLI..."

# Install required system packages
install_sysdeps() {
  echo "📦 Installing system dependencies..."

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install -y tmux tree python3-pip git
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y tmux tree python3-pip git
    elif command -v yum &>/dev/null; then
      sudo yum install -y tmux tree python3-pip git
    else
      echo "❌ Unsupported Linux package manager"
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install tmux tree python git
  else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
  fi
}

# Clone the repo
clone_repo() {
  echo "📁 Cloning geniusCLI to $INSTALL_DIR..."
  sudo rm -rf "$INSTALL_DIR"
  sudo git clone "$REPO_URL" "$INSTALL_DIR"
}

# Install Python requirements
install_python_deps() {
  echo "🐍 Installing Python requirements..."
  sudo pip3 install -r "$INSTALL_DIR/requirements.txt"
}

# Symlink to /usr/local/bin/genius
link_executable() {
  echo "🔗 Linking genius CLI..."
  sudo ln -sf "$INSTALL_DIR/genius.sh" "$LINK_PATH"
  chmod +x "$INSTALL_DIR/main.sh"
  chmod +x "$INSTALL_DIR/utils/getHistory.sh"
  chmod +x "$INSTALL_DIR/API/gemini.api.py"
  chmod +x "$INSTALL_DIR/Parse/parse.sh"


  sudo chmod +x "$LINK_PATH"
}

install_sysdeps
clone_repo
install_python_deps
link_executable

echo "✅ Done! Run 'genius' to launch."
