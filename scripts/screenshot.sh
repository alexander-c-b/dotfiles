#!/bin/sh
maim -s --hidecursor | convert png:- -trim png:- | to-clipboard image/png
