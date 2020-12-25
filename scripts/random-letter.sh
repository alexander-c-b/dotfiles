#!/bin/sh
</dev/urandom tr --delete --complement a-z | head -c 1
echo
