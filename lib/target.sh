#!/usr/bin/env bash
DIR=${DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )}
DATA=${DATA:-"$DIR/data"}
HEADER_HEIGHT=${HEADER_HEIGHT:-0}
BASE_INDENT=${BASE_INDENT:-0}
PROMPT_LINE=${PROMPT_LINE:-20}
TARGET_LINE=${TARGET_LINE:-12}
 
PLUGIN_NAME="target"
PLUGIN_DATA="$DATA/$PLUGIN_NAME"
HOST_DATA="$PLUGIN_DATA/host"
DOMAIN_DATA="$PLUGIN_DATA/domain"
EMAIL_DATA="$PLUGIN_DATA/email"
BINARY_DATA="$PLUGIN_DATA/binary"
WEBSITE_DATA="$PLUGIN_DATA/website"

target() {
	init "$@"

	tput setaf 69
	tput cup $(($HEADER_HEIGHT+1)) $BASE_INDENT 
	tput ed
	echo "Set Target"
	tput cup $(($HEADER_HEIGHT+2)) $BASE_INDENT 
	echo '---------------'
	tput sgr0
	menu_header_height=$(($HEADER_HEIGHT+2))

	show_target

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
	echo '0) Back out'
	tput cup "$PROMPT_LINE" 0
	read -p 'Enter selection: ' selection
	if handle_target "$selection"; then
		target
		return $?
	fi
	return 1
}

init() {
    parse_flags "$@"
	tput cup $HEADER_HEIGHT 0
	tput ed
	if [ ! -d "$DATA" ]; then
		mkdir -p "$DATA"
	fi
	if [ ! -d "$PLUGIN_DATA" ]; then
		mkdir -p "$PLUGIN_DATA"
		touch "$HOST_DATA"
		touch "$DOMAIN_DATA"
		touch "$EMAIL_DATA"
		touch "$BINARY_DATA"
		touch "$WEBSITE_DATA"
	fi;
}

show_target() {
	tput cup $TARGET_LINE $BASE_INDENT 
	echo "Host: $(cat "$HOST_DATA")"
	echo "Domain: $(cat "$DOMAIN_DATA")"
	echo "Email: $(cat "$EMAIL_DATA")"
	echo "Binary: $(cat "$BINARY_DATA")"
	echo "Website: $(cat "$WEBSITE_DATA")"
	return 0
}

handle_target() {
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
			--host)
			    shift
			    echo "$1" > "$HOST_DATA"
				exit
			    ;;
			--domain)
			    shift
			    echo "$1" > "$DOMAIN_DATA"
				exit
			    ;;
			--email)
			    shift
			    echo "$1" > "$EMAIL_DATA"
				exit
			    ;;
			--binary)
			    shift
			    echo "$1" > "$BINARY_DATA"
				exit
			    ;;
			--website)
			    shift
			    echo "$1" > "$WEBSITE_DATA"
				exit
			    ;;
		esac
		shift
	done
}

helpmenu() {
	echo -e "Target"
	echo -e "Convenient central store for details on the location of targets"
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--menu <num>, -m <num>:\t\t\tSelect this menu item"
	echo -e "\t--<host|domain|email|binary|website> <value>:\t\t\tSet the target item (i.e. host, domain, etc) to <value>"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	target "$@"
fi
