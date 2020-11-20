#!/bin/bash

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOC_DIR=~/butterfly_localization
export PROJECT_DIR="$(dirname $BASH_DIR)"

src_dir=~/'Dropbox/UMICH/EE Research/data/csv_files_14'
info_table="$src_dir"/../info_table_14.txt

echo '' > "$info_table"

src_files=$(ls -b "$src_dir"/*.csv)

OIFS="$IFS"

IFS=$'\n'

cd "$PROJECT_DIR"/build
make > /dev/null

cnt=0
for csv_file in $src_files
do
    fname="$(basename "$csv_file" | cut -d '.' -f1)"
    dname="$fname"_Details.txt
    "$PROJECT_DIR"/build/src/parse_details.exe "$info_table" "$fname" "$src_dir/$dname"
    ((cnt++))
    if (($cnt >= 5))
    then
        cnt=0
        echo "" >> $info_table
    fi
done

IFS="$OIFS"

