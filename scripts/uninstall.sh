#!/bin/bash

BIN_DEST="/System/Library/Frameworks/DiskArbitration.framework/Versions/Current/Support"
PLIST_DEST="/System/Library/LaunchAgents"
BIN="DiskArbitrationAgent"
PLIST="com.apple.DiskArbitrationAgent.plist"

if [[ "$#" -ne 1 ]]; then
    echo "usage $0 backup-dir"
    exit 1
fi

BACKUP_DIR="$1"

if [[ ! -d "$BACKUP_DIR" || ! -f "${BACKUP_DIR}/${BIN}" || ! -f "${BACKUP_DIR}/${PLIST}" ]]; then
  echo "$BACKUP_DIR is an invalid backup directory, needs to include both $BIN and $PLIST"
  exit 1
fi

echo "Removing installed files"
sudo rm "${BIN_DEST}/${BIN}"
sudo rm "${PLIST_DEST}/${PLIST}"

echo "Restoring backup files"
sudo cp "${BACKUP_DIR}/${BIN}"  "$BIN_DEST"
sudo cp "${BACKUP_DIR}/${PLIST}" "$PLIST_DEST"

echo "Fixing permissions"
sudo chown root:wheel "${BIN_DEST}/${BIN}"
sudo chmod 755 "${BIN_DEST}/${BIN}"
sudo chown root:wheel "${PLIST_DEST}/${PLIST}"
sudo chmod 644 "${PLIST_DEST}/${PLIST}"

echo "Done!"

exit 0
