#!/bin/bash

DATA_DIR=~/volunteer_data

ls "$DATA_DIR"/csv_files_*/*.csv

echo "There are around $(ls "$DATA_DIR"/csv_files_*/*.csv | wc -l) valid files"
