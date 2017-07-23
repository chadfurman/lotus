#!/usr/bin/env bash
colors() {
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

if [[ "$0" == "$BASH_SOURCE" ]]; then
	colors "$@"
fi
