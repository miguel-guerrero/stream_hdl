#!/bin/bash

# remove python run time
python3 -m pip uninstall antlr4-python3-runtime

# remove development files
sudo rm /usr/local/lib/antlr-4.11.1-complete.jar

