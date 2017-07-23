#!/usr/bin/env bash
DIR=${DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )}
DATA=${DATA:-"$DIR/data"}
SAVED_DATA=${SAVED_DATA:-"$DIR/saved_data"}

NAME=""
FORCE=false

load_project() {
	init "$@"

	cd "$DATA"
	cp "$SAVED_DATA/$NAME.tar.gz" ./
	if tar -xvzf "$NAME.tar.gz"; then
		echo "Loaded $NAME"
		rm "$NAME.tar.gz"
		read -p "Press return to continue..."
		return 0
	fi
	echo "Error loading.  Exiting."
	return 1
}

init() {
	echo "Initializaing loader..."
	parse_flags "$@"
	if [[ ! $DATA ]] || [[ "$DATA" == "" ]]; then
		echo "Path to data directory not set.  Cannot load to nowhere.  Exiting."
		return 1
	fi
	if [[ -d $DATA ]]; then
		if  [[ "${FORCE}" == true ]]; then
			echo "Forced. Truncating existing data directory."
		else
			read -p "$DATA exists. Loading will overwrite all existing data.  Type 'load' without the quotes to continue: " confirm
			if [[ ! $confirm =~ "load" ]]; then
				echo "Cancelled.  Exiting."
				return 0
			fi
		fi
		rm -rf "$DATA"
		mkdir -p "$DATA"
	else
		echo "No existing data directory at $DATA -- nothing to worry about."
		mkdir -p "$DATA"
	fi
	if [[ ! $SAVED_DATA ]] || [[ "$SAVED_DATA" == "" ]]; then
		echo "Path to save directory is not set.  Cannot load from nowhere.  Exiting."
		return 1
	fi
	if [[ ! -d $SAVED_DATA ]]; then
		echo "$SAVED_DATA does not exist. Nothing to load."
		return 1
	fi
	if [[ ! "$NAME" ]]; then
		show_saved_projects
		read -p "Enter project name to load (i.e. my_project.1500829210): " NAME
	fi
	if [[ ! -f "$SAVED_DATA/$NAME.tar.gz" ]]; then
		echo "Project save not found: $SAVED_DATA/$NAME.tar.gz"
		return 1
	fi
	echo "Loading project: $NAME"
}

show_saved_projects() {
	for project in $SAVED_DATA/*; do
		echo "$project"
	done;
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
			--force | -f)
				FORCE=true
				;;
		esac
		shift
	done
}

helpmenu() {
	echo -e "Load Project"
	echo -e "\tLoad the specify'd .tar.gz from the saved data directory ($SAVED_DATA)"
	echo -e "\tto the data directory ($DATA)"
	echo -e ""
	echo -e "Optional arguments:"
	echo -e "\t--help, -h:\t\t\tThis message"
	echo -e "\t--data <dir>, -d <dir>:\t\tSet path to project data"
	echo -e "\t--saved-data <dir>, -s <dir>:\tSet destination directory"
	echo -e "\t--name <name>, -n <name>:\tSpecify name to (i.e. yourproject.1500829210 ))"
	echo -e "\t--force, -f:\tDon't prompt to overwrite existing data directory"
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	load_project "$@"
fi
