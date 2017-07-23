#!/usr/bin/env bash
DIR=${DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )}
DATA=${DATA:-"$DIR/data"}
SAVED_DATA=${SAVED_DATA:-"$DIR/saved_data"}

NAME=""

save_project() {
	init "$@"

	if [[ ! "$NAME" ]]; then
		read -p "Enter save name: " NAME
	fi

	if tar -C "$DATA" -cvzf "$SAVED_DATA/$NAME.$(date +%s).tar.gz" "./" ; then
		echo "Saved $SAVED_DATA/$NAME.$(date +%s).tar.gz"
		read -p "Press return to continue..."
		return 0
	fi
	echo "Error creating save.  Exiting."
	return 1
}

init() {
	parse_flags "$@"
	if [[ ! $DATA ]] || [[ "$DATA" == "" ]]; then
		echo "Path to data directory not set.  Cannot save without destination.  Exiting."
		return 1
	fi
	if [ ! -d $DATA ]; then
		echo "$DATA does not exist. Creating."
		mkdir -p $DATA
	fi
	if [[ ! $SAVED_DATA ]] || [[ "$SAVED_DATA" == "" ]]; then
		echo "Path to save directory is not set.  Cannot save without destination.  Exiting."
		return 1
	fi
	if [ ! -d $SAVED_DATA ]; then
		echo "$SAVED_DATA does not exist. Creating."
		mkdir -p $SAVED_DATA
	fi
	echo "Saving to data directory: $SAVED_DATA"
}

parse_flags() {
	while [ ! $# -eq 0 ]
	do
		case "$1" in
			--help | -h)
				helpmenu
				exit
				;;
			--data | -d)
				shift
				DATA=$1
				;;
			--saved-data | -s)
				shift
				SAVED_DATA=$1
				;;
			--name | -n)
				shift
				NAME=$1
				;;
		esac
		shift
	done
}

helpmenu() {
	echo -e "Save Project"
	echo -e "\tCreates a timestamp'd .tar.gz of the data directory ($DATA)"
	echo -e "\tin the saved data directory ($SAVED_DATA)"
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--data <dir>, -d <dir>:\t\tSet path to project data"
	echo -e "\t--saved-data <dir>, -s <dir>:\tSet destination directory"
	echo -e "\t--name <name>, -n <name>:\tSpecify name to save as (avoids prompt)"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	save_project "$@"
fi
