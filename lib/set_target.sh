#!/usr/bin/env bash
HEADER_HEIGHT=${HEADER_HEIGHT:-0}
BASE_INDENT=${BASE_INDENT:-0}
PROMPT_LINE=${PROMPT_LINE:-20}
DATA=${DATA:-'./'}
 
PLUGIN_NAME="set_target"
PLUGIN_DATA="$DATA/$PLUGIN_NAME"
HOST_DATA="$PLUGIN_DATA/host"
DOMAIN_DATA="$PLUGIN_DATA/domain"
EMAIL_DATA="$PLUGIN_DATA/email"
BINARY_DATA="$PLUGIN_DATA/binary"
WEBSITE_DATA="$PLUGIN_DATA/website"

set_target() {
	init

	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	tput ed
	echo "Set Target"
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	menu_header_height=$(($HEADER_HEIGHT+2))

	tput cup $(($menu_header_height+1)) $BASE_INDENT 
	echo '1) IP or CIDR (for scanning, exploitation, etc)'
	tput cup $(($menu_header_height+2)) $BASE_INDENT 
	echo '2) Domain (for subdomain brute-forcing and email harvesting)'
	tput cup $(($menu_header_height+3)) $BASE_INDENT 
	echo '3) Email (for social engineering)'
	tput cup $(($menu_header_height+4)) $BASE_INDENT 
	echo '4) Binary (for fuzzing)'
	tput cup $(($menu_header_height+5)) $BASE_INDENT 
	echo '5) Website (for webapp attacks)'
	tput cup $(($menu_header_height+6)) $BASE_INDENT 
	echo '0) Back to attack menu'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection (1-5, 0 to go back to attack menu): ' selection
	if handle_set_target "$selection"; then
		read -p 'Press any key to continue...'
		set_target
		return $?
	fi
	return 1
}

init() {
	tput cup $HEADER_HEIGHT 0
	tput ed
	if [ ! -d "$PLUGIN_DATA" ]; then
		mkdir -p "$PLUGIN_DATA"
		touch "$PLUGIN_DATA/host"
		touch "$PLUGIN_DATA/domain"
		touch "$PLUGIN_DATA/email"
		touch "$PLUGIN_DATA/binary"
		touch "$PLUGIN_DATA/website"
	fi;
}

handle_set_target() {
	selection="$1"
	tput el1
	case $selection in
		1) read -p 'Enter an IP address or CIDR notation: ' host && echo "$host" > "$HOST_DATA"
			;;
		2) read -p 'Enter domain name to enumerate: ' domain && echo "$domain" > "$DOMAIN_DATA"
			;;
		3) read -p 'Enter email to spearfish: ' email && echo "$email" > "$EMAIL_DATA"
			;;
		4) read -p 'Enter path to binary for fuzzing: ' binary && echo "$binary" > "$BINARY_DATA"
			;;
		5) read -p 'Enter URL of website for SQLi/XSS/CSRF scanning: ' website && echo "$host" > "$WEBSITE_DATA"
			;;
		[0,q]) return 1
			;;
		*) echo "Invalid selection"
			;;
	esac
	echo "New target information: "
	echo "Host: $(cat "$HOST_DATA")"
	echo "Domain: $(cat "$DOMAIN_DATA")"
	echo "Email: $(cat "$EMAIL_DATA")"
	echo "Binary: $(cat "$BINARY_DATA")"
	echo "Website: $(cat "$WEBSITE_DATA")"
	return 0

}
