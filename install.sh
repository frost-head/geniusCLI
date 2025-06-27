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
# 🔐 Prompt for Gemini API Key
# ---------------------------------------
get_key() {
  echo "🔐 Configuring Gemini API Key..."

  # Ensure .env file exists
  sudo touch "$ENV_FILE"
  sudo chown "$USER:$USER" "$ENV_FILE"

  # Load existing if present
  set -a
  [ -f "$ENV_FILE" ] && source "$ENV_FILE"
  set +a

  if [ -z "$GEMINI_API_KEY" ]; then
    echo -n "Enter your Gemini API Key: "
    read -r GEMINI_API_KEY < /dev/tty

    if [ -z "$GEMINI_API_KEY" ]; then
      echo "❌ No API key entered. Exiting."
      exit 1
    fi

    echo "GEMINI_API_KEY=$GEMINI_API_KEY" >> "$ENV_FILE"
    echo "✅ Saved API key to $ENV_FILE"
  else
    echo "✅ GEMINI_API_KEY already present."
  fi
}

# ---------------------------------------
# 🐍 Install Python dependencies
# ---------------------------------------
install_python_deps() {
  echo "🐍 Installing Python requirements..."
  sudo pip3 install -r "$INSTALL_DIR/requirements.txt" --break-system-packages
}

# ---------------------------------------
# 🔗 Link CLI + fix perms
# ---------------------------------------
link_executable() {
  echo "🔗 Linking genius CLI..."

  # Make all scripts executable
  sudo find "$INSTALL_DIR" -type f \( -iname "*.sh" -o -iname "*.py" \) -exec chmod +x {} \;

  # Symlink genius.sh to /usr/local/bin/genius
  sudo ln -sf "$INSTALL_DIR/genius.sh" "$LINK_PATH"
  sudo chmod +x "$LINK_PATH"

  # Fix ownership of repo
  sudo chown -R "$USER:$USER" "$INSTALL_DIR"

  echo "✅ genius CLI linked as 'genius'"
}

# 🔧 Run setup steps
install_sysdeps
clone_repo
get_key
install_python_deps
link_executable

echo ""
echo "🎉 Installation complete. Type 'genius' to launch the CLI."
