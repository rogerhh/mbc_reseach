#!/bin/bash

# read all csv files
files=$(ls /home/rogerhh/mbc_research/data/src/compression_sim/sample_data/*0_sample_times.csv | tail -n 10)

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOC_DIR="/home/rogerhh/butterfly_localization"
export PROJECT_DIR="$(dirname $BASH_DIR)"

cnt=0
for sample_f in $files
do
    rm $LOC_DIR/tmp/*

    ((cnt++))
    sample_f="$(echo $sample_f | cut -d '.' -f1)"
    hobo_f="$(echo $sample_f | sed "s/sample_times/HOBO/1")"
    dir_path="$(dirname $sample_f)/"
    file_path="$(basename $sample_f)"
    fname="$(echo $file_path | sed "s/_sample_times//1")"

    echo "$file_path"

    if [[ $(ls "$LOC_DIR/Testdata" | grep "$fname") ]]
    then
        cp $LOC_DIR/Testdata/$fname* $LOC_DIR/tmp/
    else
        if [[ $(ls "$LOC_DIR/loc" | grep "$fname") ]]
        then
            cd $LOC_DIR
            echo "Creating resampled .mat files..."
            cmd="-nodisplay -nodesktop -r \"try, main_func('$dir_path', '$file_path'), catch, exit, end, exit\""
            /usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"

            echo "Creating HOBO .mat files..."
            file_path="$(basename $hobo_f)"
            cmd="-nodisplay -nodesktop -r \"try, main_func('$dir_path', '$file_path'), catch, exit, end, exit\""
            /usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"

            cp $LOC_DIR/Testdata/$fname* $LOC_DIR/tmp/
        else 
            echo "Error finding location files for $fname"
        fi
    fi

    mat_files="$(ls $LOC_DIR/tmp/*.mat)"


    for mat_f in $mat_files
    do
        cd "$LOC_DIR/python/"
        fname="$(basename $mat_f | cut -d '.' -f1)"
        echo "Running localization on $fname.mat"
        python3 test.py "$fname"
        cd "$LOC_DIR"

        echo "Printing images"
        cmd="-nodisplay -nodesktop -r \"try, show_result_func('$fname'), catch, exit, end, exit\""
        /usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"

    done
    
done
