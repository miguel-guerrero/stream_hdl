#!/bin/bash
python3 -m pip install antlr4-python3-runtime
cd /usr/local/lib
echo "Please enter password for sudo to install anlr-4.5.3 under $CWD"
sudo curl -O http://www.antlr.org/download/antlr-4.5.3-complete.jar
