#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

PROBLEM=$1
ESSENCE=$2
PARAM=$3
CONJURE_MODE=$4
SAVILEROW_MODE=$5
EPRIME=$6
SOLVER=$7
ESSENCE_BASE="${ESSENCE%.*}"
ESSENCE_FULL="problems/${PROBLEM}/${ESSENCE}"
PARAM_FULL="problems/${PROBLEM}/${PARAM}"
EPRIME_SRC="problems/${PROBLEM}/${ESSENCE_BASE}-models/${CONJURE_MODE}/${EPRIME}"
TARGET_DIR="problems/${PROBLEM}/${ESSENCE_BASE}-models/${CONJURE_MODE}/${SAVILEROW_MODE}/${SOLVER}"
mkdir -p "${TARGET_DIR}"

SAVILEROW_OPTIONS="-timelimit ${LIMIT_TIME}000"
if [ "${SAVILEROW_MODE}" == "O0" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O0"
elif [ "${SAVILEROW_MODE}" == "O1" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O1"
elif [ "${SAVILEROW_MODE}" == "O2" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O2"
elif [ "${SAVILEROW_MODE}" == "O3" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O3"
else
    echo "SAVILEROW_MODE not recognised: ${SAVILEROW_MODE}"
    exit 1
fi

if [ "${SOLVER}" == "minion" ]; then
    SOLVER_OPTIONS="-cpulimit ${LIMIT_TIME}"
elif [ "${SOLVER}" == "lingeling" ]; then
    SOLVER_OPTIONS="-t ${LIMIT_TIME} --seed 0"
else
    echo "SOLVER not recognised: ${SOLVER}"
    exit 1
fi

cp ${EPRIME_SRC} ${TARGET_DIR}/${EPRIME}

conjure solve --use-existing-models=${EPRIME} ${ESSENCE_FULL} ${PARAM_FULL} -o ${TARGET_DIR} \
    --log-level LogNone \
    --savilerow-options "${SAVILEROW_OPTIONS}" \
    --solver "${SOLVER}" \
    --solver-options "${SOLVER_OPTIONS}"

rm -f ${TARGET_DIR}/*.eprime-minion         # no need to keep: generated minion file
rm -f ${TARGET_DIR}/*.eprime-dimacs         # no need to keep: generated sat file
rm -f ${TARGET_DIR}/${EPRIME}

