#!/bin/bash

export PROJECT_DIR=~/"mbc_research"
TARGET_DIR="$PROJECT_DIR"/data/training_set/sampled_data
LOC_DIR="$PROJECT_DIR"/data/training_set/loc
EXE="$PROJECT_DIR"/build/src/compression_sim/resample_test.exe
files="$(ls "$PROJECT_DIR"/data/training_set/*.csv)"

(cd "$PROJECT_DIR"/build; make)

cnt=0
for file in $files
do
    echo $cnt
    ((cnt++))
    name=$(basename $file | cut -d '.' -f1)
    "$EXE" "$file" "$TARGET_DIR"/"${name}"_hobo.csv /dev/null "$TARGET_DIR"/"${name}"_resampled.csv /dev/null "$LOC_DIR"/"${name}"_loc.csv
done
