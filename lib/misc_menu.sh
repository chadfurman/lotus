#!/usr/bin/env bash

DIR=${DIR:-"$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"}
HEADER_HEIGHT=${HEADER_HEIGHT:-0}
BASE_INDENT=${BASE_INDENT:-0}
PROMPT_LINE=${PROMPT_LINE:-10}
LIB=${LIB:-"$DIR"}

misc_menu() {
	init

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
	read -p 'Enter selection (1-3, 0 to go back to main menu): ' selection
	if ! handle_misc_menu "$selection"; then
		misc_menu
	fi
	return $?
}

init() {
	tput cup $HEADER_HEIGHT 0
	tput ed
}

handle_misc_menu() {
	selection="$1"
	case $selection in
	[0,q]) return 1
		;;
	1) 
		source "$LIB/colors.sh"
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

if [[ $_ != $0 ]]; then 
	misc_menu "$@"
fi
