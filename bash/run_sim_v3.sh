#!/bin/bash

# read all csv files
DATA_DIR=~/"Dropbox/UMICH/EE Research/data"
files="$(ls "$DATA_DIR"/csv_files_*/*.csv | head -n 100)"

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
 
sim_files=$(ls "$DATA_DIR"/csv_files_*/*.csv | tail -n 10)

for f in $sim_files
do
    $PROJECT_DIR/build/src/compression_sim/run_compression_sim_v3.exe "$f" > /dev/null
done

IFS="$OIFS"
