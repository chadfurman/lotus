#!/usr/bin/env bash

DIR=${DIR:-"$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"}
HEADER_HEIGHT=${HEADER_HEIGHT:-0}
BASE_INDENT=${BASE_INDENT:-0}
PROMPT_LINE=${PROMPT_LINE:-20}
LIB=${LIB:-"$DIR"}

attack_menu() {
	init "$@"

	if [ "$1" ]; then
		handle_misc_menu "$1"
		return $?
	fi

	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	echo "Attack Menu"
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	menu_header_height=$(($HEADER_HEIGHT+2))

	tput cup $(($menu_header_height+1)) $BASE_INDENT 
	echo '1) Target'
	tput cup $(($menu_header_height+2)) $BASE_INDENT 
	echo '2) Passive Information Gathering'
	tput cup $(($menu_header_height+3)) $BASE_INDENT 
	echo '3) Active Information Gathering'
	tput cup $(($menu_header_height+4)) $BASE_INDENT 
	echo '4) Buffer Overflows'
	tput cup $(($menu_header_height+5)) $BASE_INDENT 
	echo '5) Shells'
	tput cup $(($menu_header_height+6)) $BASE_INDENT 
	echo '6) File Transfers'
	tput cup $(($menu_header_height+7)) $BASE_INDENT 
	echo '7) Privilege Escalation'
	tput cup $(($menu_header_height+8)) $BASE_INDENT 
	echo '8) Client-side attacks'
	tput cup $(($menu_header_height+9)) $BASE_INDENT 
	echo '9) Web application attacks'
	tput cup $(($menu_header_height+10)) $BASE_INDENT 
	echo '10) Networking, pivoting, and tunneling'
	tput cup $(($menu_header_height+11)) $BASE_INDENT 
	echo '11) Metasploit Framework'
	tput cup $(($menu_header_height+12)) $BASE_INDENT 
	echo '12) Bypassing Antivirus Software'
	tput cup $(($menu_header_height+13)) $BASE_INDENT 
	echo '0) Back to main menu'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection: ' selection
	if handle_attack_menu "$selection"; then
		attack_menu
		return $?
	fi
	return 1
}

init() {
    parse_flags "$@"
	tput cup $HEADER_HEIGHT 0
	tput ed
}

handle_attack_menu() {
	selection="$1"
	case $selection in
	[0,q]) return 1
		;;
	1) 
		source "$LIB/target.sh"
		target
		;;
	2) source "$LIB/passive_information_gathering.sh" 
		passive_information_gathering
		;;
	3) source "$LIB/active_information_gathering.sh" 
		active_information_gathering
		;;
	4) source "$LIB/buffer_overflows.sh" 
		buffer_overflows
		;;
	5) source "$LIB/shells.sh" 
		shells
		;;
	6) source "$LIB/file_transfers.sh" 
		file_transfers
		;;
	7) source "$LIB/privilege_escalation.sh" 
		privilege_escalation
		;;
	8) source "$LIB/client_side_attacks.sh" 
		client_side_attacks
		;;
	9) source "$LIB/web_application_attacks.sh" 
		web_application_attacks
		;;
	10) source "$LIB/networking_pivoting_and_tunneling.sh" 
		networking_pivoting_and_tunneling
		;;
	11) source "$LIB/metasploit_framework.sh" 
		metasploit_framework
		;;
	12) source "$LIB/bypassing_antivirus.sh" 
		bypassing_antivirus
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
	echo -e "Attack Menu"
	echo -e "A set of aggressive tools for exploitation of websites, binary files, servers, etc."
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--menu <num>, -m <num>:\t\t\tSelect this menu item"
}

if [[ $0 == "$BASH_SOURCE" ]]; then
	attack_menu "$@"
fi
