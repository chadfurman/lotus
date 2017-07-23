#!/usr/bin/env bash

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
