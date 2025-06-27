#!/usr/bin/env bash
set -e

REPO="frost-head/geniusCLI"
RAW="https://raw.githubusercontent.com/$REPO/main"
REQ_FILE="/tmp/geniuscli_requirements.txt"

echo "🗑️  Uninstalling geniusCLI..."

# Remove the installed CLI binary
if [[ -f "/usr/local/bin/genius" ]]; then
  sudo rm /usr/local/bin/genius
  echo "🧹 Removed /usr/local/bin/genius"
else
  echo "⚠️  genius CLI not found at /usr/local/bin/genius"
fi

# Prompt to uninstall Python packages
read -p "❓ Do you want to remove Python packages listed in requirements.txt? (y/N): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "📥 Fetching latest requirements.txt..."
  curl -fsSL "$RAW/requirements.txt" -o "$REQ_FILE"
  echo "🐍 Uninstalling Python packages..."
  xargs -a "$REQ_FILE" pip3 uninstall -y
  rm -f "$REQ_FILE"
else
  echo "⚠️  Skipping Python package removal."
fi

echo "✅ geniusCLI has been uninstalled."
