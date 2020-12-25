#!/bin/sh
if [[ -z "$1" ]]
then
    >&2 echo "Provide file argument for $0"
    exit 1
fi

cat "$QUTE_HTML" > "$1"
