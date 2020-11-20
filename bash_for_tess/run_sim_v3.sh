#!/bin/bash

# read all csv files
DATA_DIR=~/volunteer_data

train_range_start=0
train_range_end=200
files="$(ls "$DATA_DIR"/csv_files_*/*.csv | tail -n +$train_range_start | head -n $(($train_range_end - $train_range_start)))"

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
export LOC_DIR=~/butterfly_localization
export PROJECT_DIR="$(dirname $BASH_DIR)"

cd $PROJECT_DIR/build
make

OIFS="$IFS"

IFS=$'\n'

cnt=0
for f in $files
do
    ((cnt++))
    echo "$cnt $f"
    $PROJECT_DIR/build/src/compression_sim/run_sim_v3.exe "$f" > /dev/null
done

$PROJECT_DIR/build/src/compression_sim/huffman_tree_gen_v3.exe
 
sim_range_start=250
sim_range_end=260
sim_files=$(ls "$DATA_DIR"/csv_files_*/*.csv | tail -n +$sim_range_start | head -n $(($sim_range_end - $sim_range_start)))

for f in $sim_files
do
    $PROJECT_DIR/build/src/compression_sim/run_compression_sim_v3.exe "$f" > /dev/null
done

IFS="$OIFS"
