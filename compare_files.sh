#!/bin/bash

if [ -z $1 -o -z $2 ]; then
    echo "use: compare_files <file1> <file2>"
    exit 2
fi

file1='md5sum $1'
file2='md5sum $2'

if [ *$file1* = *$file2* ]; then
    echo "files are the same"
else
    echo "files are not the same"
fi
