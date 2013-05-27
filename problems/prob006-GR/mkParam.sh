#!/bin/bash

# Use this like so: parallel " bash mkParam.sh " ::: $(seq -w 5 15)

echo "language Essence 1.3" >  "${1}.param"
echo "letting n be $1"      >> "${1}.param"

