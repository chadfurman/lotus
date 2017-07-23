#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG="$DIR/config"
source "$CONFIG/globals.sh"

main() {
	while true; do
		tput clear
		header
		if main_menu; then
			read -p "Press any key to continue..."
		fi
	done;
}

header() {
	tput setaf 87
	tput cup 1 $BASE_INDENT 
	echo "Lotus v$VERSION"
	tput cup 2 $BASE_INDENT 
	echo '---------------'
	tput sgr0
}

main_menu() {
	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	echo "Main Menu"
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	main_menu_HEADER_HEIGHT=$(($HEADER_HEIGHT+2))

	tput cup $(($main_menu_HEADER_HEIGHT+1)) $BASE_INDENT 
	echo '1) Attack Menu'
	tput cup $(($main_menu_HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '2) Misc. Menu'
	tput cup $(($main_menu_HEADER_HEIGHT+3)) $BASE_INDENT 
	echo '0) Exit'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection (1-12, 0 to exit): ' selection
	handle_main_menu "$selection"
	return $?
}

handle_main_menu() {
	selection="$1"
	case $selection in
	[0,q]) exit 0
		;;
	1) 
		source $LIB/attack_menu.sh
		attack_menu	
		return $?
		;;
	2) source "$LIB/misc_menu.sh" 
		misc_menu	
		return $?
		;;
	*) echo "Invalid selection" 
		;;
	esac
}

main
