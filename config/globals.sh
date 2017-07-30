#!/usr/bin/env bash

DIR=${DIR:-"$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"}
CONFIG=${CONFIG:-"$DIR/config"}
VERSION=${VERSION:-"0.0.1-alpha.1"}
DATA=${DATA:-"$DIR/data"}
SAVED_DATA=${SAVED_DATA:-"$DIR/saved_data"}
LIB=${LIB:-"$DIR/lib"}
BASE_INDENT=${BASE_INDENT:-2}
HEADER_HEIGHT=${HEADER_HEIGHT:-3}
PROMPT_LINE=${PROMPT_LINE:-20}

if [ ! -d $DATA ]; then
	mkdir $DATA
fi
if [ ! -d $SAVED_DATA ]; then
	mkdir $SAVED_DATA
fi
