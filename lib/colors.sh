#!/usr/bin/env bash
colors() {
    init "$@"

    for color in {0..256}; do
        tput setaf $color
        printf "%4d" "$color"
        if [[ $(expr $color % 24) = 0 ]]; then
            echo ''
        fi
    done;
    echo ""
    echo "ANSII Colors 0-256"
    read -p "Press return to continue..."
    return 0
}

init() {
    parse_flag "$@"
}

parse_flags() {
	while [ ! $# -eq 0 ]
	do
		case "$1" in
			--help | -h)
				helpmenu
				exit
				;;
		esac
		shift
	done
}

helpmenu() {
	echo -e "Colors"
	echo -e "Print a pretty array of numbers colored w/ their corresponding ASCII colors."
	echo -e "Great if you want to quickly find the right color for a shell script menu."
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	colors "$@"
fi
