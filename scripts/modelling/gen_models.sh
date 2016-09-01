#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)
CMD_FILE="${ROOT_DIR}/scripts/modelling/conjure_commands.txt"

nb_commands=$(cat ${CMD_FILE} | wc -l)
nb_cores=$1

if (( ${nb_commands} > 0 )) ; then
    echo "Number of commands to run: ${nb_commands}"
    echo "Number of cores to use   : ${nb_cores}"
    mkdir -p logs/versions logs/gnuparallel
    conjure --version | tee logs/versions/conjure_version.txt
    parallel                                                \
        -j"${nb_cores}"                                     \
        --eta                                               \
        --results logs/gnuparallel/modelling-results        \
        --joblog  logs/gnuparallel/modelling-joblog         \
        :::: ${CMD_FILE}
else
    echo "No commands found in \"${CMD_FILE}\""
    echo "You may want to run \"scripts/modelling/gen_conjure_commands.sh\" first."
fi


# strip the json bits from the eprimes
# parallel "[ -f {} ] && (cat {} | grep -v '\\$' > {}.temp ; mv {}.temp {})" ::: $(find problems -name "*.eprime")

