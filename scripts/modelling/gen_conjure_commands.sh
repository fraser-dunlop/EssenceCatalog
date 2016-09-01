#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)
mkdir -p "${ROOT_DIR}/models"

rm -f conjure_commands.txt
touch conjure_commands.txt                              # create an empty file to store all conjure commands

pushd EssenceCatalog/problems > /dev/null               # go through all problems in EssenceCatalog
for prob in *; do
    pushd "${prob}" > /dev/null
    for essence in *.essence; do                        # go through all essence files for this problem
        echo "scripts/runConjure.sh ${prob} ${essence} compact" >> "${ROOT_DIR}/conjure_commands.txt"
        echo "scripts/runConjure.sh ${prob} ${essence} noch"    >> "${ROOT_DIR}/conjure_commands.txt"
    done
    popd > /dev/null
done
popd > /dev/null

# "LC_ALL=C" seems to be a way of getting a consistent ordering between mac and linux
# at least for the 2 machines I tried this on...
# -d consider only blanks and alphanumeric characters
# -f ignore case
LC_ALL=C sort -df conjure_commands.txt -o conjure_commands.txt
