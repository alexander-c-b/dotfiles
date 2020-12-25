#!/bin/sh

i=0
while [ -e "$HOME/print-$i.pdf" ]
do
    i=$(expr $i + 1)
done
filename="$HOME/print-$i.pdf"

wkhtmltopdf "$QUTE_HTML" $filename
