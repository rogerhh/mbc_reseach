#!/bin/bash

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"

mkdir $BASH_DIR/HOBO
mkdir $BASH_DIR/sample_times

files="$(ls $BASH_DIR/*HOBO*.jpg)"

for f in $files
do
    sample_f="$(echo $f | sed "s/HOBO/sample_times/1")"
    if (mv $sample_f $BASH_DIR/sample_times/ > /dev/null)
    then 
        mv $f $BASH_DIR/HOBO/
    else
        rm $f
    fi
done

