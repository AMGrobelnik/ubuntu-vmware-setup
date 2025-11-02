#!/bin/bash

# GNOME Extensions and Settings Restore Script
# Created: $(date)
# This script restores your exact GNOME setup

BLUE="\033[94m"
GREEN="\033[92m"
YELLOW="\033[93m"
CYAN="\033[96m"
END="\033[0m"

echo -e "${CYAN}========================================${END}"
echo -e "${CYAN}  Restoring GNOME Setup${END}"
echo -e "${CYAN}========================================${END}"
echo ""

# Get the directory where this script is located
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Restoring extension settings...${END}"
dconf load /org/gnome/shell/extensions/ < "$BACKUP_DIR/all-extension-settings.dconf"
echo -e "${GREEN}✓ Extension settings restored${END}"

echo -e "${BLUE}Restoring desktop settings...${END}"
dconf load /org/gnome/desktop/ < "$BACKUP_DIR/gnome-desktop-settings.dconf"
echo -e "${GREEN}✓ Desktop settings restored${END}"

echo ""
echo -e "${BLUE}Enabling extensions...${END}"

# Enable all extensions from backup
while IFS= read -r extension; do
    if [ ! -z "$extension" ]; then
        gnome-extensions enable "$extension" 2>/dev/null
        echo -e "  ${GREEN}✓${END} $extension"
    fi
done < "$BACKUP_DIR/enabled-extensions.txt"

echo ""
echo -e "${GREEN}========================================${END}"
echo -e "${GREEN}  Restore Complete!${END}"
echo -e "${GREEN}========================================${END}"
echo ""
echo -e "${YELLOW}Note: You may need to log out and back in for all changes to take effect.${END}"
echo ""
