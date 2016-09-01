#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)
mkdir -p "${ROOT_DIR}/logs"

INFO_FILE="${ROOT_DIR}/logs/infos.tsv"
touch ${INFO_FILE}

                                                        # go through all problems in EssenceCatalog
pushd problems > /dev/null
for prob in *; do
    pushd "${prob}" > /dev/null
    for essence in *.essence; do                        # go through all essence files for this problem
        essence_base="${essence%.*}"
        if [ -d params ]; then
            pushd params > /dev/null
        elif [ -d "${essence_base}-params" ] ; then
            pushd "${essence_base}-params" > /dev/null
        else
            continue                                    # skip this essence, it has no params
        fi
        for param in *.param; do
            param_base="${param%.*}"
            for conjure_mode in compact noch; do
                pushd "${ROOT_DIR}/problems/${prob}/${essence_base}-models/${conjure_mode}" > /dev/null
                for eprime in *.eprime; do
                    eprime_base="${eprime%.*}"
                    for savilerow_mode in O0 O2; do
                        for solver in minion lingeling; do
                            INFO_FILE="${ROOT_DIR}/problems/${prob}/${essence_base}-models/${conjure_mode}/${savilerow_mode}/${solver}/${eprime_base}-${param_base}.eprime-info"
                            if [ -f "${INFO_FILE}" ]; then
                                cat "${INFO_FILE}" | tr ':' '\t' | while read name value; do
                                    echo -e "${prob}\t${essence}\t${param}\t${conjure_mode}\t${savilerow_mode}\t${eprime}\t${solver}\t${name}\t${value}" >> ${INFO_FILE}
                                done
                            fi
                        done
                    done
                done
                popd > /dev/null
            done
        done
        popd > /dev/null
    done
    popd > /dev/null
done
popd > /dev/null

# "LC_ALL=C" seems to be a way of getting a consistent ordering between mac and linux
# at least for the 2 machines I tried this on...
# -d consider only blanks and alphanumeric characters
# -f ignore case
LC_ALL=C sort -df ${INFO_FILE} -o ${INFO_FILE}

