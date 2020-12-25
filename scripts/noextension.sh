#!/bin/sh
filename="$1"
echo "$(basename "$filename" | sed 's/\(.*\)\..*/\1/')"
