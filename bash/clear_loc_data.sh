#!/bin/bash

LOC_DIR=~/butterfly_localization

rm $LOC_DIR/Testdata/*.mat
rm $LOC_DIR/images/HOBO/*.jpg
rm $LOC_DIR/images/sample_times/*.jpg
rm $LOC_DIR/tmp/*.mat
rm $LOC_DIR/results/*.mat

cd $LOC_DIR
cmd="-nodisplay -nodesktop -r \"try, clear_sim_results(), catch, exit, end, exit\""
/usr/local/MATLAB/R2018b/bin/matlab "$cmd > /dev/null"
