#!/usr/bin/env bash
DIR=${DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )}
DATA=${DATA:-"$DIR/data"}

FORCE=false

clear_project() {
	echo "Clearing project..."
	init "$@"
	if [[ ! $DATA ]] || [[ "$DATA" == "" ]]; then
		echo "Data variable is not set."
		return 1
	fi
	echo "Current data directory: $DATA"
	if [ ! -d $DATA ]; then
		echo "$DATA does not exist. Exiting."
		return 2
	fi
    if  [[ "${FORCE}" == false ]]; then
        read -p "Are you sure? Type 'clear' to proceed: " confirm
    fi
	if [[ "$confirm" =~ 'clear' || "${FORCE}" == true ]]; then
		rm -rf $DATA
		echo "Deleted."
		return $?
	else
		echo "Cancelled."
	fi
	return 0
}

init() {
	parse_flags "$@"
}

parse_flags() {
	while [ ! $# -eq 0 ]
	do
		case "$1" in
			--help | -h)
				helpmenu
				exit
				;;
			--force | -f)
				FORCE=true
				;;
		esac
		shift
	done
}

helpmenu() {
	echo -e "Clear Project"
	echo -e "Prompt to confirm, and then delete the data directory"
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--force, -f:\tDon't prompt to confirm (DANGEROUS)"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	clear_project "$@"
fi
