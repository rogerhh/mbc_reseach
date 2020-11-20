#!/bin/bash

# read all csv files

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
export PROJECT_DIR="$(dirname $BASH_DIR)"

echo '' > $PROJECT_DIR/data/src/compression_sim/sunrise_time_diff.csv
echo '' > $PROJECT_DIR/data/src/compression_sim/sunset_time_diff.csv
echo '' > $PROJECT_DIR/data/src/compression_sim/csv_files_list.txt
echo '' > $PROJECT_DIR/data/src/compression_sim/code_diff.txt
echo '' > $PROJECT_DIR/data/src/compression_sim/csv_files_list_v2.txt
echo '' > $PROJECT_DIR/data/src/compression_sim/histogram.txt

#v3 stuff
echo '' > $PROJECT_DIR/data/src/compression_sim/csv_files_list_v3.txt
echo '' > $PROJECT_DIR/data/src/compression_sim/light_histogram.txt
echo '' > $PROJECT_DIR/data/src/compression_sim/temp_histogram.txt
rm $PROJECT_DIR/data/src/compression_sim/sample_data/*
