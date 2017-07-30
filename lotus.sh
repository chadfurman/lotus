#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOTUS_DIR=DIR
CONFIG="$DIR/config"
source "$CONFIG/globals.sh"

lotus() {
    init "$@"
	while true; do
		tput clear
		header
		if lotus_menu; then
			read -p "Press return to continue..."
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

lotus_menu() {
	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	echo "Main Menu"
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	menu_header_height=$(($HEADER_HEIGHT+2))

	tput cup $(($menu_header_height+1)) $BASE_INDENT 
	echo '1) Attack Menu'
	tput cup $(($menu_header_height+2)) $BASE_INDENT 
	echo '2) Misc. Menu'
	tput cup $(($menu_header_height+3)) $BASE_INDENT 
	echo '3) Clear Project'
	tput cup $(($menu_header_height+4)) $BASE_INDENT 
	echo '4) Save Current Project'
	tput cup $(($menu_header_height+5)) $BASE_INDENT 
	echo '5) Load Saved Project'
	tput cup $(($menu_header_height+6)) $BASE_INDENT 
	echo '0) Exit'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection: ' selection
	handle_lotus_menu "$selection"
	return $?
}

handle_lotus_menu() {
	selection="$1"
	case $selection in
	[0,q]) exit 0
		;;
	1) 
		source $LIB/attack_menu.sh
		attack_menu
		;;
	2) 
		source $LIB/misc_menu.sh 
		misc_menu
		;;
	3) 
		source $LIB/clear_project.sh 
		clear_project
		;;
	4) 
		source $LIB/save_project.sh 
		save_project
		;;
	5) 
		source $LIB/load_project.sh 
		load_project
		;;
	*) echo "Invalid selection" 
		;;
	esac
	return $?
}

init() {
    parse_flags "$@"
    if [[ ! -w $LOTUS_DIR ]]; then
        echo -n "Lotus requires write-permissions to this directory: "
        echo -e "$LOTUS_DIR"
        echo -e "Exiting."
        exit 1;
    fi
}

parse_flags() {
	while [ ! $# -eq 0 ]
	do
		case "$1" in
			--help | -h)
				helpmenu
				exit
				;;
			--menu | -m)
			    shift
				handle_misc_menu "$1"
				exit
				;;
			--dir | -d)
			    shift
			    $LOTUS_DIR="$1"
		esac
		shift
	done
}

helpmenu() {
	echo -e "Lotus"
	echo -e "A script runner and library for system administration and auditing"
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--menu <num>, -m <num>:\t\t\tSelect menu item <num>"
	echo -e "\t--dir <path>, -d <path>:\t\t\tSet the folder to treat as $LOTUS_DIR for the sake of $LIB and $DATA etc (there be dragons)"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	lotus "$@"
fi
