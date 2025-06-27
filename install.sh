#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/frost-head/geniusCLI.git"
INSTALL_DIR="/usr/local/geniusCLI"
LINK_PATH="/usr/local/bin/genius"
ENV_FILE="$INSTALL_DIR/.env"

echo "🚀 Installing geniusCLI..."

# ---------------------------------------
# 📦 Install system dependencies
# ---------------------------------------
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

# ---------------------------------------
# 📁 Clone repo
# ---------------------------------------
clone_repo() {
  echo "📁 Cloning geniusCLI to $INSTALL_DIR..."
  sudo rm -rf "$INSTALL_DIR"
  sudo git clone "$REPO_URL" "$INSTALL_DIR"
}

# ---------------------------------------
# 🐍 Install Python dependencies
# ---------------------------------------
install_python_deps() {
  echo "🐍 Installing Python requirements..."
  sudo pip3 install -r "$INSTALL_DIR/requirements.txt"
}

# ---------------------------------------
# 🔗 Link CLI script and set permissions
# ---------------------------------------
link_executable() {
  echo "🔗 Linking genius CLI..."

  # Make all scripts executable
  sudo find "$INSTALL_DIR" -type f \( -iname "*.sh" -o -iname "*.py" \) -exec chmod +x {} \;

  # Link entrypoint
  sudo ln -sf "$INSTALL_DIR/genius.sh" "$LINK_PATH"

  # Fix ownership
  sudo chown -R "$USER:$USER" "$INSTALL_DIR"

  echo "✅ Linked as '/usr/local/bin/genius'"
}

# ---------------------------------------
# 🔐 Ask for API key if not already set
# ---------------------------------------
get_key() {
  echo "🔐 Setting up Gemini API key..."
  
  if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
  fi

  if [ -z "$GEMINI_API_KEY" ]; then
    echo -n "Enter your Gemini API Key: "
    read -r GEMINI_API_KEY

    if [ -z "$GEMINI_API_KEY" ]; then
      echo "❌ No API key provided. Exiting."
      exit 1
    fi

    echo "GEMINI_API_KEY=$GEMINI_API_KEY" >> "$ENV_FILE"
    echo "✅ API key saved to $ENV_FILE"
  else
    echo "✅ GEMINI_API_KEY already set."
  fi
}

# 🔧 Run all steps
install_sysdeps
clone_repo
install_python_deps
link_executable
get_key

echo "🎉 Installation complete. Run 'genius' to launch."
