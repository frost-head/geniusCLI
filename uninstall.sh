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

echo "✅ geniusCLI has been uninstalled."
