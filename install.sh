#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/frost-head/geniusCLI.git"
INSTALL_DIR="/usr/local/geniusCLI"
LINK_PATH="/usr/local/bin/genius"
ENV_FILE="/usr/local/geniusCLI/.env"


getkey() {# Load existing .env


  echo -n "🔐 Enter your Gemini API Key: "
  read -r GEMINI_API_KEY


  echo "GEMINI_API_KEY=$GEMINI_API_KEY" >> "$ENV_FILE"
  echo "✅ API key saved to $ENV_FILE"


export GEMINI_API_KEY
}
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

  # Make all .sh and .py scripts executable
  sudo find "$INSTALL_DIR" -type f \( -iname "*.sh" -o -iname "*.py" \) -exec chmod +x {} \;

  # Symlink genius.sh to /usr/local/bin/genius
  sudo ln -sf "$INSTALL_DIR/genius.sh" "$LINK_PATH"

  # Fix ownership
  sudo chown -R "$USER:$USER" "$INSTALL_DIR"

  echo "✅ Linked genius as '/usr/local/bin/genius'"
}


install_sysdeps
clone_repo
install_python_deps
link_executable
getkey

echo "✅ Done! Run 'genius' to launch."
