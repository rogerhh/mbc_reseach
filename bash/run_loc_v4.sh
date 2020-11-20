#!/bin/bash

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOC_DIR=~/butterfly_localization

hobo_files=$(ls "$LOC_DIR"/tmp/*hobo*.mat)

for hobo_f in $hobo_files
do
    resampled_f="$(basename $hobo_f | sed "s/hobo/resampled/1" | cut -d '.' -f1)"
    echo $resampled_f
    hobo_f="$(basename $hobo_f | cut -d '.' -f1)"
    echo $hobo_f

    cd $LOC_DIR/python
    echo "Running localization on $hobo_f"
    python3 $LOC_DIR/python/test.py $hobo_f
    echo "Running localization on $resampled_f"
    python3 $LOC_DIR/python/test.py $resampled_f

done
