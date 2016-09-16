#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

export LIMIT_TIME=${LIMIT_TIME:-600}

ROOT_DIR=$(pwd)
CMD_FILE="${ROOT_DIR}/scripts/solutions/conjure_commands.txt"

nb_commands=$(cat ${CMD_FILE} | wc -l)
nb_cores=$1

if (( ${nb_commands} > 0 )) ; then
    echo "Number of commands to run: ${nb_commands}"
    echo "Number of cores to use   : ${nb_cores}"
    echo "Time limit in seconds    : ${LIMIT_TIME}"
    mkdir -p logs/gnuparallel
    parallel                                                \
        -j"${nb_cores}"                                     \
        --eta                                               \
        --results logs/gnuparallel/solutions-results        \
        --joblog  logs/gnuparallel/solutions-joblog         \
        :::: ${CMD_FILE} || true        # allowed to fail due to SR timeouts
    LC_ALL=C sort -n logs/gnuparallel/solutions-joblog -o logs/gnuparallel/solutions-joblog
    # this is to drop the 2nd and the 3rd columns
    # 2nd is the host, which we always expect to be ":"
    # 3rd is the StartTime
    cat logs/gnuparallel/solutions-joblog | cut -f 1,4- > logs/gnuparallel/solutions-joblog.cropped
    mv logs/gnuparallel/solutions-joblog.cropped logs/gnuparallel/solutions-joblog
else
    echo "No commands found in \"${CMD_FILE}\""
    echo "You may want to run \"scripts/solutions/gen_conjure_commands.sh\" first."
fi

