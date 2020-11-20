#!/bin/bash

DATA_DIR=~/"Dropbox/UMICH/EE Research/data"
TARGET_DIR=~/"mbc_research/data/training_set"

rm "$TARGET_DIR"/*.csv
rm "$TARGET_DIR"/sampled_data/*.csv

size=$(ls "$DATA_DIR"/csv_files_*/*.csv | wc -l)

for ((i = 0; i < 30; i++))
do
    num=$(($RANDOM % $size))
    filename="$(ls "$DATA_DIR"/csv_files_*/*.csv | tail -n +"$num" | head -n 1)"
    cp "$filename" "$TARGET_DIR"
done
