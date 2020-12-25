#!/bin/sh

csl="$1"
ref_file="$2"
out_format="${3:-html}"
if [[ -z "$csl" -o -z "$ref_file" ]]
then
	echo "Usage: $0 citationstyle.csl references.yaml [out-format]"
	exit 1
fi

if [[ $out_format == "markdown" ]]
then
	append="--wrap=none"
fi

pandoc --bibliography="$ref_file" --to html --csl=$csl <<- 'EOF' \
	| pandoc --from html-native_divs-native_spans --to $out_format $append
	---
	nocite: |
	    @*
	---
	
	EOF
