#!/bin/bash

# read all csv files
#ls /home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_*/*.csv | head -n 3
files=$(ls /home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_*/*.csv | head -n 200)
# files=$(ls /home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_10/SN_20680267*.csv | head -n 200)

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
export PROJECT_DIR="$(dirname $BASH_DIR)"

OIFS="$IFS"

IFS=$'\n'

cnt=0
for f in $files
do
    ((cnt++))
    echo "$cnt $f"
    #$PROJECT_DIR/build/src/compression_sim/run_sim.exe ~/Dropbox/UMICH/EE\ Research/data/csv_files_4/SN_20418688_2018-10-26_15_01_38_-0400.csv
    $PROJECT_DIR/build/src/compression_sim/run_sim.exe "$f" > /dev/null
done

$PROJECT_DIR/build/src/compression_sim/huffman_tree_gen.exe

sim_files=$(ls /home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_*/*.csv | head -n 10)

for f in $sim_files
do
    $PROJECT_DIR/build/src/compression_sim/run_compression_sim.exe "$f"
done

IFS="$OIFS"
