#!/bin/bash

echo "Enter sudo password for installation"

# cd /usr/local/lib && sudo curl -O http://www.antlr.org/download/antlr-4.5.3-complete.jar
sudo cp antlr-4.5.3-complete.jar /usr/local/lib || echo "ERROR during antlr-4.5.3 installation"

if [ ! -d antlr4-python3-runtime-4.5.3 ]; then
    tar xvfz antlr4-python3-runtime-4.5.3.tar.gz
fi

pushd antlr4-python3-runtime-4.5.3 && \
  sudo python3 ./setup.py install && \
popd && \
sudo rm -rf antlr4-python3-runtime-4.5.3
