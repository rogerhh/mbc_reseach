#!/bin/bash

PROJECT_DIR=~/mbc_research

ls "$PROJECT_DIR"/data/src/compression_sim/sample_data/*light_sample_times.csv

echo "There are around $(ls "$PROJECT_DIR"/data/src/compression_sim/sample_data/*light_sample_times.csv | wc -l) valid files"
