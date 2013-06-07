#/bin/bash

set -o nounset

echo "conjure repository is at ${CONJURE_REPO}"

COUNT_ESSENCE=$(ls -1 *.essence 2> /dev/null | wc -l)
COUNT_PARAM=$(ls -1 *.param 2> /dev/null | wc -l)
COUNT_SOLUTION=$(ls -1 *.solution 2> /dev/null | wc -l)

if (( $COUNT_ESSENCE != 1 )); then
    WD="$(pwd)"
    echo "ERROR: Only 1 *.essence file should be in: $WD"
    exit 1
fi


if (( $# != 1 )); then
    echo "ERROR: Give a single parameter, mode to be used by Conjure."
    echo "       Options: {df, compact, random, first}"
    exit 1
fi

export WD="$(pwd)"

export MODE=$1
export FAIL_FILE="${MODE}_fail.txt"
export FAIL_REFINE_FILE="${MODE}_refine_fail.txt"
export FAIL_PARAM_FILE="${MODE}_param_fail.txt"


export PASS_FILE="${MODE}_pass.txt"

export SPEC=$(ls -1 *.essence | head -n 1)
export SPEC=${SPEC%.essence}

export OUT_DIR="$SPEC-$MODE"
if [ $MODE == "df" ] ; then
    OUT_DIR="${SPEC}-df"
elif [ $MODE == "df-no-channelling" ] ; then
    OUT_DIR="${SPEC}-df-no-channelling"
fi

function perModelperParam {
    MODEL=$1
    PARAM=$2

    MSG_TEMPLATE="$MODE $WD $MODEL $PARAM"


    RESULTOF_REFINEPARAM=0
    MSG_REFINEPARAM="[refineParam] $MSG_TEMPLATE"
    echo "$MSG_REFINEPARAM"
    # echo "conjure --mode refineParam --in-essence $SPEC.essence --in-eprime $MODEL.eprime --in-essence-param $PARAM.param --out-eprime-param $MODEL-$PARAM.eprime-param"
    conjure                                                                 \
        --mode       refineParam                                            \
        --in-essence $SPEC.essence                                          \
        --in-eprime  $MODEL.eprime                                          \
        --in-essence-param $PARAM.param                                     \
        --out-eprime-param $MODEL-`basename $PARAM`.eprime-param
    RESULTOF_REFINEPARAM=$?
    if (( $RESULTOF_REFINEPARAM != 0 )) ; then
        echo "$MSG_REFINEPARAM" >> "$FAIL_FILE"
        echo "$MSG_REFINEPARAM" >> "$FAIL_PARAM_FILE"
        exit 1
	else 
		echo "$MSG_REFINEPARAM" >> "$PASS_FILE"
    fi

}

export -f perModelperParam;

rm -f "$FAIL_FILE" "$PASS_FILE"
touch "$FAIL_FILE" "$PASS_FILE"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
if [[ $MODE == df* ]] ; then
    conjure --mode $MODE --in "$SPEC.essence" --limit-models 15             +RTS -M16G -s 2> >(tee "${MODE}_conjure.stats" >&2)
else
    conjure --mode $MODE --in "$SPEC.essence" --out "$OUT_DIR/$MODE.eprime" +RTS -M16G -s 2> >(tee "${MODE}_conjure.stats" >&2)
fi

NB_EPRIMES=$(ls -1 "$OUT_DIR"/*.eprime 2> /dev/null | wc -l)

if (( $NB_EPRIMES == 0 )) ; then
    echo "[generatesZeroModels] $MODE $WD" >> "$FAIL_FILE"
    echo "[generatesZeroModels] $MODE $WD" >> "$FAIL_REFINE_FILE"
else
	echo "[refine] $MODE $WD" >> "$PASS_FILE"
	[ -d "params" ] &&  parallel -j3                                                            \
	perModelperParam {1.} {2.}                                          \
		::: $(ls -1 "$OUT_DIR"/*.eprime | head -n 10)                                \
		::: $(ls -1 params/*.param | head -n 2 )
fi
