#!/bin/bash

echo "Get required git submodules"
git submodule update --init --recursive

VER=4.11.1

# install python run-time  
python3 -m pip install antlr4-python3-runtime==$VER

echo "Enter sudo password for installation of antlr binaries"
# install antlr4 development flow (optional)
pushd /usr/local/lib && \
    sudo curl -O https://www.antlr.org/download/antlr-${VER}-complete.jar && \
popd

# this is also optional, pregenrated files are included
pushd scripts/grammar
    make clean
    make build
popd
