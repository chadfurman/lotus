#!/usr/bin/env bash

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
	tput rev
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	main_menu_HEADER_HEIGHT=$(($HEADER_HEIGHT+2))

	tput cup $(($main_menu_HEADER_HEIGHT+1)) $BASE_INDENT 
	echo '1) Set Target'
	tput cup $(($main_menu_HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '2) Passive Information Gathering'
	tput cup $(($main_menu_HEADER_HEIGHT+3)) $BASE_INDENT 
	echo '3) Active Information Gathering'
	tput cup $(($main_menu_HEADER_HEIGHT+4)) $BASE_INDENT 
	echo '4) Buffer Overflows'
	tput cup $(($main_menu_HEADER_HEIGHT+5)) $BASE_INDENT 
	echo '5) Shells'
	tput cup $(($main_menu_HEADER_HEIGHT+6)) $BASE_INDENT 
	echo '6) File Transfers'
	tput cup $(($main_menu_HEADER_HEIGHT+7)) $BASE_INDENT 
	echo '7) Privilege Escalation'
	tput cup $(($main_menu_HEADER_HEIGHT+8)) $BASE_INDENT 
	echo '8) Client-side attacks'
	tput cup $(($main_menu_HEADER_HEIGHT+9)) $BASE_INDENT 
	echo '9) Web application attacks'
	tput cup $(($main_menu_HEADER_HEIGHT+10)) $BASE_INDENT 
	echo '10) Networking, pivoting, and tunneling'
	tput cup $(($main_menu_HEADER_HEIGHT+11)) $BASE_INDENT 
	echo '11) Metasploit Framework'
	tput cup $(($main_menu_HEADER_HEIGHT+12)) $BASE_INDENT 
	echo '12) Bypassing Antivirus Software'
	tput cup $(($main_menu_HEADER_HEIGHT+13)) $BASE_INDENT 
	echo '0) Exit'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection (1-12, 0 to exit): ' selection
	handle_main_menu "$selection"
}

handle_main_menu() {
	selection="$1"
	case $selection in
	0) exit 0
		;;
	1) source $LIB/set_target && set_target
		;;
	2) source $LIB/passive_information_gathering && passive_information_gathering
		;;
	3) source $LIB/active_information_gathering && active_information_gathering
		;;
	4) source $LIB/buffer_overflows && buffer_overflows
		;;
	5) source $LIB/shells && shells
		;;
	6) source $LIB/file_transfers && file_transfers
		;;
	7) source $LIB/privilege_escalation && privilege_escalation
		;;
	8) source $LIB/client_side_attacks && client_side_attacks
		;;
	9) source $LIB/web_application_attacks && web_application_attacks
		;;
	10)source $LIB/ networking_pivoting_and_tunneling &&  networking_pivoting_and_tunneling
		;;
	11)source $LIB/ metasploit_framework &&  metasploit_framework
		;;
	12)source $LIB/ bypassing_antivirus &&  bypassing_antivirus
		;;
	*) echo "Invalid selection" 
		;;
	esac
}

set_target() {
	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	tput ed
	echo "Set Target"
	tput rev
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	main_menu_header_height=$(($HEADER_HEIGHT+2))

	tput cup $(($main_menu_header_height+1)) $BASE_INDENT 
	echo '1) IP or CIDR (for scanning, exploitation, etc)'
	tput cup $(($main_menu_header_height+2)) $BASE_INDENT 
	echo '2) Domain (for subdomain brute-forcing and email harvesting)'
	tput cup $(($main_menu_header_height+3)) $BASE_INDENT 
	echo '3) Email (for social engineering)'
	tput cup $(($main_menu_header_height+4)) $BASE_INDENT 
	echo '4) Binary (for fuzzing)'
	tput cup $(($main_menu_header_height+5)) $BASE_INDENT 
	echo '5) Website (for webapp attacks)'
	tput cup $(($main_menu_header_height+6)) $BASE_INDENT 
	echo '0) Back to main menu'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection (1-5, 0 to go back to main menu): ' selection
	if handle_set_target "$selection"; then
		read -p 'Press any key to continue...'
		set_target
		return $?
	fi
	return 1
}

handle_set_target() {
	selection="$1"
	tput el1
	case $selection in
		1) read -p 'Enter an IP address or CIDR notation: ' host && echo "$host" > "$CONFIG/host"
			;;
		2) read -p 'Enter domain name to enumerate: ' domain && echo "$domain" > "$CONFIG/domain"
			;;
		3) read -p 'Enter email to spearfish: ' email && echo "$email" > "$CONFIG/email"
			;;
		4) read -p 'Enter path to binary for fuzzing: ' binary && echo "$binary" > "$CONFIG/binary"
			;;
		5) read -p 'Enter URL of website for SQLi/XSS/CSRF scanning: ' website && echo "$host" > "$CONFIG/host"
			;;
		0) return 1
			;;
		*) echo "Invalid selection"
			;;
	esac
	echo "New target information: "
	echo "Host: $(cat "$"
	echo "Domain: $DOMAIN"
	echo "Email: $EMAIL"
	echo "Binary: $BINARY"
	echo "Website: $WEBSITE"
	return 0

}

main
