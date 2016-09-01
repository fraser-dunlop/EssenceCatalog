#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)
CMD_FILE="${ROOT_DIR}/scripts/solutions/conjure_commands.txt"

rm -f ${CMD_FILE}
touch ${CMD_FILE}

export LIMIT_TIME=${LIMIT_TIME:60}
                                                        # go through all problems in EssenceCatalog
pushd problems > /dev/null
for prob in *; do
    pushd "${prob}" > /dev/null
    for essence in *.essence; do                        # go through all essence files for this problem
        essence_base="${essence%.*}"
        for param in params/*.param "${essence_base}-params"/*.param; do
            for conjure_mode in compact noch; do
                pushd "${ROOT_DIR}/problems/${prob}/${essence_base}-models/${conjure_mode}" > /dev/null
                for eprime in *.eprime; do
                    for savilerow_mode in O0 O2; do
                        for solver in minion lingeling; do
                            echo "scripts/solutions/runConjure.sh ${prob} ${essence} ${param} ${conjure_mode} ${savilerow_mode} ${eprime} ${solver}" >> ${CMD_FILE}
                        done
                    done
                done
                popd > /dev/null
            done
        done
    done
    popd > /dev/null
done
popd > /dev/null

# "LC_ALL=C" seems to be a way of getting a consistent ordering between mac and linux
# at least for the 2 machines I tried this on...
# -d consider only blanks and alphanumeric characters
# -f ignore case
LC_ALL=C sort -df ${CMD_FILE} -o ${CMD_FILE}

