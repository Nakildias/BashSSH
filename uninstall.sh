#!/bin/bash

# Uninstallation script for BashSSH

# --- Configuration ---
# These should match the values used in install.sh
TARGET_BIN_NAME="BashSSH"
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="$INSTALL_DIR/$TARGET_BIN_NAME"
CONFIG_DIR="$HOME/.config/bashssh" # User config directory (for info message)

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Helper Functions ---
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${CYAN}$1${NC}"
}

success() {
    echo -e "${GREEN}$1${NC}"
}

warn() {
    echo -e "${YELLOW}Warning: $1${NC}" >&2
}


# --- Pre-uninstallation Checks ---

# 1. Check for root/sudo privileges
if [[ "$EUID" -ne 0 ]]; then
  error_exit "This script must be run with root privileges (e.g., using sudo)."
fi
info "Root privileges detected."

# 2. Check if the binary exists at the target location
info "Checking for BashSSH installation at '$INSTALL_PATH'..."
if [[ ! -f "$INSTALL_PATH" ]]; then
    warn "BashSSH binary not found at '$INSTALL_PATH'."
    echo -e "${YELLOW}Perhaps it is already uninstalled or was installed elsewhere?${NC}" >&2
    # Exit successfully as the goal (program removed) is achieved
    exit 0
fi
info "BashSSH binary found."

# --- Uninstallation ---

info "Attempting to remove '$INSTALL_PATH'..."

# Remove the binary file
# Use -f to force removal without prompting and ignore non-existent file errors (though we already checked)
if ! rm -f "$INSTALL_PATH"; then
    error_exit "Failed to remove '$INSTALL_PATH'. Check permissions or if the file is in use."
fi

# --- Completion ---
success "BashSSH has been successfully uninstalled from '$INSTALL_PATH'."
echo ""
echo -e "${YELLOW}Note:${NC} This script does not remove user configuration files."
echo -e "If you wish to remove your saved connections, you can manually delete the directory:"
echo -e "  ${CYAN}rm -rf \"$CONFIG_DIR\"${NC}"
echo -e "(This command removes your stored connections list: ${CYAN}$CONFIG_DIR/connections.list${NC})"


exit 0
