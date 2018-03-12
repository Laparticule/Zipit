#!/bin/bash

# This script allows you to zip a specific folder

#---------------------------------------------------------

DEFAULT_SRC_DIR="/PATH/TO/SOME/DEFAULT/SRC/DIRECTORY"
DEFAULT_DEST_DIR="/PATH/TO/SOME/DEFAULT/DEST/DIRECTORY"
DEFAULT_ARCHIVE_NAME="archive.zip"

USER_INPUT=$(yad --title="Zipit" --text="<b>Zipit</b> is a simple tool that will allow you to <b>compress</b> a specific folder.\n(You will have the opportunity to dismiss some files originally present in the chosen folder.)\n" --form --field="Original folder":DIR "$DEFAULT_SRC_DIR" --field="Name of the archive" "$DEFAULT_ARCHIVE_NAME" --field="Destination folder":DIR "$DEFAULT_DEST_DIR")

SRC_DIR=$(echo "$USER_INPUT" | cut -d '|' -f 1)
DEST_DIR=$(echo "$USER_INPUT" | cut -d '|' -f 3)
ARCHIVE_NAME=$(echo "$USER_INPUT" | cut -d '|' -f 2)

# Creates the archive and shows progress
cd "$SRC_DIR"
(zip -qr - ./ | pv -i 0.1 -n -s $(du -sb | cut -f1) > "$DEST_DIR/$ARCHIVE_NAME") 2>&1 | yad --progress --auto-close --auto-kill --title="Zipit"
cd -

# Checks the archive's contents
yad --title="Zipit" --text="<b>Your archive has been successfully created!</b>\nNow you can check its contents and eventually delete some files."
file-roller "$DEST_DIR/$ARCHIVE_NAME"
