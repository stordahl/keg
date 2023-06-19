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

gum style --foreground="#539FC5" "Welcome to Keg! What would you like to do?"

TASK=$(echo "Install a Package\nUpdate Brew\nUpdate a Brew Package(s)\nUninstall Package\nExit" | gum choose --limit 1)

case "$TASK" in
    "Install a Package")
    NAME=$(gum input --placeholder "Package Name")
    gum spin --spinner dot --title "Installing $NAME" -- brew install "$NAME"
    echo "$NAME was installed!"
    ;;

    "Update Brew")
    gum spin --spinner dot --title "Updating brew. Please Wait..." -- brew update
    VERSION=$(brew --version | cut -d ' ' -f2)
    echo "Brew has been updated! Running version: $VERSION"
    ;;

    "Update a Brew Package(s)")
    echo "Use SPACE to select, ENTER to Update"
    UPDATE=$(brew list | gum choose --no-limit)
    for app in $UPDATE
    do
        gum spin --spinner dot --title "Updating $app" -- brew update "$app"
        echo "Updated $app"
    done
    ;;

    "Uninstall Package")
    echo "Press ENTER to Uninstall"
    TITLE=$(brew list | gum choose --limit 1)
    gum style --foreground="#539FC5" "You have selected to Uninstall $TITLE."

    if gum confirm; then
        gum spin --spinner dot --title "Uninstalling $TITLE" -- brew uninstall "$TITLE"
    else
        echo "Uninstall Cancelled"
    fi
    ;;

    "Exit")
    gum style --foreground="#539FC5" "Goodbye!"
    exit 0
    ;;

    *) gum style "No selection made"
    ;;
esac
