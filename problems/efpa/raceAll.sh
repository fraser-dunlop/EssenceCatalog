#!/bin/bash

set -o nounset

ESSENCE=$(ls *.essence | head -n 1)
ESSENCEBASE=${ESSENCE%.essence}

WHICH_OUTPUT="df-better"

rm -rf ${ESSENCE}-champion
cp -r ${ESSENCE}-${WHICH_OUTPUT} ${ESSENCE}-champion

for param in *.param ; do
    echo ${param}
    ../../tools/race_full_linux.sh ${param} 1 | tee race-1.stdout
done

