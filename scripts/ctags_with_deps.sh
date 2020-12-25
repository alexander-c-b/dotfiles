#!/usr/bin/env bash

# ./ctags_with_dep.sh file1.c file2.c ... to generate a tags file for these files.

# for extra libraries, e.g. editline, append -I commands to gcc below:
# `gcc -M -I ~/include "$@"`
gcc -M "$@" | sed -e 's/[\\ ]/\n/g' | \
        sed -e '/^$/d' -e '/\.o:[ \t]*$/d' | \
        ctags -L - --c++-kinds=+p --fields=+iaS --extra=+q
