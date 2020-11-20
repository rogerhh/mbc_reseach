#!/bin/bash

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOC_DIR=~/butterfly_localization
export PROJECT_DIR="$(dirname $BASH_DIR)"

# read all csv files
loc_files_start=0
loc_files_end=5
files=$(ls $PROJECT_DIR/data/src/compression_sim/sample_data/*light_sample_times.csv | tail -n +$loc_files_start | head -n $(($loc_files_end - $loc_files_start)))

cnt=0
for sample_f in $files
do
    rm $LOC_DIR/tmp/*

    ((cnt++))
    sample_f="$(echo $sample_f | cut -d '.' -f1)"
    hobo_f="$(echo $sample_f | sed "s/sample_times/HOBO/1")"
    dir_path="$(dirname $sample_f)/"
    file_path="$(basename $sample_f)"
    fname="$(echo $file_path | sed "s/light_sample_times//1")"

    echo "$file_path"

    if [[ $(ls "$LOC_DIR/Testdata" | grep "$fname") ]]
    then
        echo "Copying files over"
        cp $LOC_DIR/Testdata/$fname* $LOC_DIR/tmp/
    else
        if [[ $(ls "$LOC_DIR/loc" | grep "$fname") ]]
        then
            cd $LOC_DIR
            echo "Creating resampled .mat files..."
            cmd="-nodisplay -nodesktop -r \"try, main_func_v3('$dir_path', '$file_path'), catch, exit, end, exit\""
            /usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"

            echo "Creating HOBO .mat files..."
            file_path="$(basename $hobo_f)"
            cmd="-nodisplay -nodesktop -r \"try, main_func_v3('$dir_path', '$file_path'), catch, exit, end, exit\""
            /usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"

            cp $LOC_DIR/Testdata/$fname* $LOC_DIR/tmp/
        else 
            echo "Error finding location files for $fname"
        fi
    fi

    mat_files="$(ls $LOC_DIR/tmp/*light_sample_times*.mat)"

    for mat_f in $mat_files
    do
        # find if there's a corresponding hobo file
        hobo_f="$(echo $mat_f | sed "s/sample_times/HOBO/1")"
        if [[ $(ls $hobo_f) ]]
        then
            cd "$LOC_DIR/python/"
            fname_resampled="$(basename $mat_f | cut -d '.' -f1)"
            echo "Running localization on $fname_resampled.mat"
            python3 test.py "$fname_resampled"

            fname_hobo="$(basename $hobo_f | cut -d '.' -f1)"
            echo "Running localization on $fname_hobo.mat"
            python3 test.py "$fname_hobo"

            cd "$LOC_DIR"
            cmd="-nodisplay -nodesktop -r \"show_result_func_v3('$fname_resampled'), show_result_func_v3('$fname_hobo'), summarize_v3('$LOC_DIR/tmp/"$fname_hobo"_results.mat', '$LOC_DIR/tmp/"$fname_resampled"_results.mat'), exit\""
            /usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"
        fi

    done
    
done
