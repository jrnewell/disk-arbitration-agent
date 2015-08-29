#!/bin/bash

BIN_DEST="/System/Library/Frameworks/DiskArbitration.framework/Versions/Current/Support"
PLIST_DEST="/System/Library/LaunchAgents"
BIN="DiskArbitrationAgent"
PLIST="com.apple.DiskArbitrationAgent.plist"

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="./DiskArbitrationAgent_Backup/${DATE}"
mkdir -p "$BACKUP_DIR"

echo "Backing up files to $BACKUP_DIR"
sudo mv "${BIN_DEST}/${BIN}" "$BACKUP_DIR"
sudo mv "${PLIST_DEST}/${PLIST}" "$BACKUP_DIR"

echo "Installing files"
sudo cp "./${BIN}" "$BIN_DEST"
sudo cp "./LaunchAgents/${PLIST}" "$PLIST_DEST"

echo "Fixing permissions"
sudo chown root:wheel "${BIN_DEST}/${BIN}"
sudo chmod 755 "${BIN_DEST}/${BIN}"
sudo chown root:wheel "${PLIST_DEST}/${PLIST}"
sudo chmod 644 "${PLIST_DEST}/${PLIST}"

echo "Done!"

exit 0
