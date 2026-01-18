#!/bin/sh

export PATH="/usr/sbin:$PATH"

if ! command -v gum >/dev/null 2>&1; then
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
CATEGORIES=""
STARTUPWMCLASS=""

while [ "$finished" != "true" ]; do
	clear
	MENU=$(gum choose "Name" "Comment" "Dir" "Exec" "Icon" "Finish")
	if [ "$MENU" = "Name" ]; then
		echo "Name the file (without the .desktop): "
	NAME=$(gum input --placeholder "Enter here...")
	fi
	if [ "$MENU" = "Comment" ]; then
		echo "Write the comment"
		COMMENT=$(gum input --placeholder "Enter here...")
	fi
	if [ "$MENU" = "Exec" ]; then
		echo "Pick the Exec"
		EXEC=$(find "$HOME" -type f -executable | fzf --style full --height ~100% --border --padding 1,2 --input-label ' Input ' --header-label ' File Type ' --preview 'bat -n --color=always {}')
	fi
	if [ "$MENU" = "Dir" ]; then
		echo "Pick the directory"
		DIR=$(find "$HOME" -type d -print | fzf --style full --height ~100% --border --padding 1,2 --input-label ' Input ' --header-label ' File Type ' --preview 'bat -n --color=always {}')
	fi
	if [ "$MENU" = "Icon" ]; then
		echo "Pick the icon"
		ICON=$(find "$HOME" -type f -name "*.jpg" -o -name "*.png" -o -name "*.svg" | fzf --style full --height ~100% --border --padding 1,2 --input-label ' Input ' --header-label ' File Type ' --preview 'tiv -w $FZF_PREVIEW_COLUMNS -h $FZF_PREVIEW_LINES {} 2>/dev/null')
		clear
	fi
	if [ "$MENU" = "Categorie(s)" ]; then
		echo "Write the categorie(s)"
		CATEGORIES=$(gum input --placeholder "Enter here...")
	fi
	if [ "$MENU" = "StartupWMClass" ]; then
		echo "Write the StartupWMClass"
		STARTUPWMCLASS=$(gum input --placeholder "Enter here...")
	fi
	if [ "$MENU" = "Finish" ]; then
		if gum confirm "Create desktop file?"; then
			cat >"$HOME/.local/share/applications/{$NAME,,}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$NAME
Comment=$COMMENT
Path=$DIR
Exec=$EXEC
Icon=$ICON
Terminal=false
Categories=$CATEGORIES
StartupWMClass=$STARTUPWMCLASS
EOF
			echo "Desktop file created: $NAME"
			finished="true"
		fi
	fi
done
