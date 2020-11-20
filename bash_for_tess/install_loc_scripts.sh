#!/bin/bash

BASH_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
PROJECT_DIR="$(dirname $BASH_DIR)"
LOC_DIR="/home/rogerhh/butterfly_localization"

cp $PROJECT_DIR/src/loc_scripts/*.m $LOC_DIR/
cp $PROJECT_DIR/src/loc_scripts/*.py $LOC_DIR/python/
cp $PROJECT_DIR/src/loc_scripts/sort_images.sh $LOC_DIR/images/
