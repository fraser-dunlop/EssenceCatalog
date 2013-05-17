#!/bin/bash

set -o nounset

rm -rf efpa-champion
cp -r efpa-df-better efpa-champion
../../tools/runExperiment_solveAll.sh $1 > solveAll-${1}.stdout 2> solveAll-${1}.stderr

