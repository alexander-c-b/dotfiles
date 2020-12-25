#!/bin/sh

function filenamer {
    echo "print-$1.pdf"
}

i=0
while [ -e $(filenamer $i) ]
do
    i=$(expr $i + 1)
done
filename="$HOME/$(filenamer $i)"

# cat "$QUTE_HTML" > $filename

pandoc \
    "$QUTE_HTML" \
    --out    "$filename" \
    --from   html \
    --to     context \
    --filter ~/scripts/flvs-tooltip.hs \
    --metadata-file=$HOME/Documents/normal.yaml \
    --metadata=author:
# wkhtmltopdf "$QUTE_HTML" $filename
