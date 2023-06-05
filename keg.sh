#!/bin/sh
#################################
# Keg - easily manage Homebrew  #
# Copyright Jacob Stordahl 2023 #
#################################
#
# Edited by Kyle LeBlanc - 2023
#
#################################

if ! which -s gum > /dev/null 2>&1 || ! which -s brew > /dev/null 2>&1; then
    echo "Requirement not found! Please install Gum and Homebrew."
    exit 1
fi

gum style --foreground="#f5c2e7" "Welcome to Keg! What would you like to do?"

TASK=$(echo "Install a package with Brew\nUpdate Brew\nUpdate a Brew Package(s)\nUninstall a Brew Package(s)" | gum choose --limit 1)

case "$TASK" in
  "Install a package with Brew") 
    P=$(gum input --placeholder "Package name")
    gum spin --spinner dot --title "Installing $P" -- brew install $P
    echo "$P is installed!"
  ;;
  "Update Brew") 
    gum spin --spinner dot --title "Updating brew (this may take a while)" -- brew update
    echo "Brew is updated!"
  ;;
  "Update a Brew Package(s)")
    echo "Space to select, Enter to update"
    L=$(brew list | gum choose --no-limit)
    for p in `echo $L` 
    do
      gum spin --spinner dot --title "Updating $p" -- brew upgrade $p
      echo "Updated $p"
    done
  ;;
  "Uninstall a Brew Package(s)")
    echo "Space to select, Enter to uninstall"
    brew list | gum choose --no-limit | xargs brew uninstall
  ;;
  *) gum style "No selection made"
  ;;
esac
