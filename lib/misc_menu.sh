#!/usr/bin/env bash

DIR=${DIR:-"$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"}
HEADER_HEIGHT=${HEADER_HEIGHT:-0}
BASE_INDENT=${BASE_INDENT:-0}
PROMPT_LINE=${PROMPT_LINE:-10}
LIB=${LIB:-"$DIR"}

misc_menu() {
	init "$@"

	if [ "$1" ]; then
		handle_misc_menu "$1"
		return $?
	fi

	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	echo "Misc. Menu"
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	misc_menu_header_height=$(($HEADER_HEIGHT+2))

	tput cup $(($misc_menu_header_height+1)) $BASE_INDENT 
	echo '1) Colors'
	tput cup $(($misc_menu_header_height+2)) $BASE_INDENT 
	echo '2) Encode'
	tput cup $(($misc_menu_header_height+3)) $BASE_INDENT 
	echo '3) Decode'
	tput cup $(($misc_menu_header_height+4)) $BASE_INDENT 
	echo '0) Back to main menu'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection: ' selection
	
	if handle_misc_menu "$selection"; then
		misc_menu
		return $?
	fi

	return 1
}

init() {
	parse_flags "$@"
	tput cup $HEADER_HEIGHT 0
	tput ed
}

handle_misc_menu() {
	selection="$1"
	case $selection in
	[0,q]) return 1
		;;
	1) source "$LIB/colors.sh"
		colors
		;;
	2) source "$LIB/encode.sh" 
		encode
		;;
	3) source "$LIB/decode.sh" 
		decode
		;;
	*) echo "Invalid selection" 
		;;
	esac
	return 0
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
		esac
		shift
	done
}

helpmenu() {
	echo -e "Misc Menu"
	echo -e "A set of miscellaneous tools that can come in handy when dealing with linuxy stuff."
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--menu <num>, -m <num>:\t\t\tSelect menu item <num>"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	misc_menu "$@"
fi
