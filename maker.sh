#!/bin/sh

if ! command -v gum &> /dev/null; then
    echo "Error: 'gum' is not installed."
    echo "Install it with: nix-shell -p gum"
    echo "Or visit: https://github.com/charmbracelet/gum"
    exit 1
fi

finished=false
NAME=""
COMMENT=""
DIR=""
EXEC=""
ICON=""

while [ "$finished" != "true" ]; do
  MENU=$(gum choose "Name" "Comment" "Dir" "Exec" "Icon" "Finish")
  if [ "$MENU" = "Name" ]; then
    echo "Name the file: "
    NAME=$(gum input)
    if [[ "$NAME" != *".desktop"* ]]; then
      NAME="$NAME.desktop"
    fi
    echo "The name is $NAME"
  fi
  if [ "$MENU" = "Finish" ]; then
    if gum confirm "Create desktop file?"; then
      # Create the .desktop file
      cat >"$NAME" <<EOF
[Desktop Entry]
Name=$NAME
Comment=$COMMENT
Path=$DIR
Exec=$EXEC
Icon=$ICON
Type=Application
Terminal=false
EOF
      echo "Desktop file created: $NAME"
      finished="true"
    fi
  fi
done
