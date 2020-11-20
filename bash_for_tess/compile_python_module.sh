#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_DIR="$DIR/.."
BUILD_DIR="$PROJECT_DIR/build"

cd "$BUILD_DIR"
cmake ..
make -j

mv "$BUILD_DIR/src/libweatherStation.so" "$BUILD_DIR/src/weatherStation.so"
