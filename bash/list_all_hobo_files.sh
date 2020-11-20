#!/bin/bash

DATA_DIR=~/"Dropbox/UMICH/EE Research/data"

ls "$DATA_DIR"/csv_files_*/*.csv

echo "There are around $(ls "$DATA_DIR"/csv_files_*/*.csv | wc -l) valid files"
