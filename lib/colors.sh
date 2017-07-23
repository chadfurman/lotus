#!/bin/bash
colors=$(for color in $(seq 0 256); do
	tput setaf $color
	echo $color
done;)
echo $colors | xargs -n 30
