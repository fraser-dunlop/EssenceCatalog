#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

PROBLEM=$1
ESSENCE=$2
CONJURE_MODE=$3
ESSENCE_BASE="${ESSENCE%.*}"
ESSENCE_FULL="problems/${PROBLEM}/${ESSENCE}"
TARGET_DIR="problems/${PROBLEM}/${ESSENCE_BASE}-models/${CONJURE_MODE}"
mkdir -p "${TARGET_DIR}"

if [ "${CONJURE_MODE}" == "compact" ]; then
    FLAGS="-ac --smart-filenames --channelling=no"
elif [ "${CONJURE_MODE}" == "noch" ]; then
    FLAGS="-ax --smart-filenames --channelling=no --representations-givens=c --representations-auxiliaries=c --representations-quantifieds=c --representations-cuts=c"
else
    echo "CONJURE_MODE not recognised: ${CONJURE_MODE}"
    exit 1
fi

conjure modelling ${FLAGS} ${ESSENCE_FULL} -o ${TARGET_DIR}

