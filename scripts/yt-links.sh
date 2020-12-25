#!/bin/sh
file=${1:--}
grep --only-matching '/watch?v=[0-9a-zA-Z_-]\+' -- "$file" \
	| uniq \
	| sed 's+\(.*\)+https://www.youtube.com\1+'
