#!/bin/bash

# Installation script for BashSSH

# --- Configuration ---
SOURCE_SCRIPT_NAME="BashSSH"      # The name of your script file
TARGET_BIN_NAME="BashSSH"         # The desired name for the installed command
INSTALL_DIR="/usr/local/bin"      # Standard location for user-installed binaries
INSTALL_PATH="$INSTALL_DIR/$TARGET_BIN_NAME"

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

# --- Pre-installation Checks ---

# 1. Check for root/sudo privileges
if [[ "$EUID" -ne 0 ]]; then
  error_exit "This script must be run with root privileges (e.g., using sudo)."
fi
info "Root privileges detected."

# 2. Check if ssh command exists
if ! command -v ssh &> /dev/null; then
    echo -e "${RED}Error: The 'ssh' command (OpenSSH client) was not found.${NC}" >&2
    echo -e "${YELLOW}Please install the OpenSSH client for your distribution before proceeding.${NC}" >&2
    echo "Common commands:" >&2
    echo "  Debian/Ubuntu: ${CYAN}sudo apt update && sudo apt install openssh-client${NC}" >&2
    echo "  Fedora/CentOS/RHEL: ${CYAN}sudo dnf install openssh-clients${NC} (or yum)" >&2
    echo "  Arch Linux: ${CYAN}sudo pacman -Syu openssh${NC}" >&2
    exit 1
fi
info "SSH command detected."

# 3. Check if the source script exists in the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)" # Get directory of install.sh
SOURCE_SCRIPT_PATH="$SCRIPT_DIR/$SOURCE_SCRIPT_NAME"

if [[ ! -f "$SOURCE_SCRIPT_PATH" ]]; then
    error_exit "The source script '$SOURCE_SCRIPT_NAME' was not found in the directory '$SCRIPT_DIR'."
fi
info "Source script '$SOURCE_SCRIPT_NAME' found."

# --- Installation ---

info "Attempting to install '$TARGET_BIN_NAME' to '$INSTALL_PATH'..."

# 1. Ensure the installation directory exists
if ! mkdir -p "$INSTALL_DIR"; then
    error_exit "Failed to create installation directory '$INSTALL_DIR'. Check permissions."
fi
info "Installation directory '$INSTALL_DIR' ensured."

# 2. Copy the script to the installation directory
if ! cp "$SOURCE_SCRIPT_PATH" "$INSTALL_PATH"; then
    error_exit "Failed to copy script to '$INSTALL_PATH'. Check permissions and available space."
fi
info "Script copied to '$INSTALL_PATH'."

# 3. Make the installed script executable
if ! chmod +x "$INSTALL_PATH"; then
    # Attempt to remove the copied file if chmod fails
    rm "$INSTALL_PATH" &> /dev/null
    error_exit "Failed to set execute permissions on '$INSTALL_PATH'."
fi
info "Execute permissions set on '$INSTALL_PATH'."

# --- Completion ---
success "Installation complete!"
echo ""
echo -e "You can now run the script from anywhere using the command:"
echo -e "  ${YELLOW}$TARGET_BIN_NAME${NC}"
echo ""
echo -e "Example: type '${YELLOW}BashSSH${NC}' and press Enter to start the interactive session."

exit 0
