#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

nb_commands=$(cat conjure_commands.txt | wc -l)
nb_cores=$1

if (( ${nb_commands} > 0 )) ; then
    echo "Number of commands to run: ${nb_commands}"
    echo "Number of cores to use   : ${nb_cores}"
    echo "Time limit in seconds    : ${LIMIT_TIME}"
    rm -rf versions models logs
    mkdir versions models logs
    conjure --version               | tee versions/conjure_version.txt
    savilerow | head -n2 | tail -n1 | tee versions/savilerow_version.txt
    minion | head -n2               | tee versions/minion_version.txt
    parallel                                    \
        -j"${nb_cores}"                         \
        --eta                                   \
        --results logs/gnuparallel-results      \
        --joblog  logs/gnuparallel-joblog       \
        :::: conjure_commands.txt
else
    echo 'No commands found in "conjure_commands.txt"'
    echo 'You may want to run "scripts/gen_conjure_commands.sh" first.'
fi

