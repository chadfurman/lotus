#!/usr/bin/env bash
DIR=${DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )}
DATA=${DATA:-"$DIR/data"}

clear_project() {
	echo "Clearing project..."
	if [[ ! $DATA ]] || [[ "$DATA" == "" ]]; then
		echo "Data variable is not set."
		return 1
	fi
	echo "Current data directory: $DATA"
	if [ ! -d $DATA ]; then
		echo "$DATA does not exist. Exiting."
		return 2
	fi
	read -p "Are you sure? Type 'clear' to proceed: " confirm
	if [[ "$confirm" =~ 'clear' ]]; then
		rm -rf $DATA
		echo "Deleted."
		return $?
	else
		echo "Cancelled."
	fi
	return 0
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
	clear_project "$@"
fi
