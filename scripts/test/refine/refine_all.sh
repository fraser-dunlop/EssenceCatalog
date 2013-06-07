#/bin/bash

set -o nounset


if (( $# < 3 )); then
    echo "ERROR:"
    echo "    - Give a directory path."
    echo "    - a build_frequency value."
    echo "        one of: {all, continuous, weekly}"
    echo "        \"all\" would run all tests, independent of their build_frequency values."
    echo "    - and a list of arguments, each a mode to be used by Conjure."
    echo "        Modes: {df-no-channelling, df}"
    exit 1
fi

export WD="$1"
export BUILD_FREQ="$2"
export MODES="${*:3}"

export SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
export SCRIPT_TEST_SINGLE="$SCRIPT_DIR/refine_single.sh"


function perDirectory {
    MODE="$1"
    DIR="$2"

    if [ "$BUILD_FREQ" == "all" ] || [ "$BUILD_FREQ" == "$(cat ${DIR}/build_frequency 2> /dev/null)" ] ; then

    FAIL_FILE="$WD/${MODE}_fail.txt"
    FAIL_REFINE_FILE="$WD/${MODE}_refine_fail.txt"
    FAIL_PARAM_FILE="$WD/${MODE}_param_fail.txt"
    PASS_FILE="$WD/${MODE}_pass.txt"
    ALL_FILE="$WD/${MODE}_all.txt"

    cd "$DIR"
    rm -f "${MODE}_fail.txt" "${MODE}_pass.txt"
    rm -f "${MODE}_refine_fail.txt" "${MODE}_param_fail.txt"
    touch "${MODE}_fail.txt" "${MODE}_pass.txt"
    touch "${MODE}_refine_fail.txt" "${MODE}_param_fail.txt"
    
    time bash "$SCRIPT_TEST_SINGLE" "$MODE"
    
    cat "${MODE}_fail.txt" >> "$FAIL_FILE"
    cat "${MODE}_pass.txt" >> "$PASS_FILE"
    cat "${MODE}_fail.txt" >> "$ALL_FILE"
    cat "${MODE}_pass.txt" >> "$ALL_FILE"

    cat "${MODE}_refine_fail.txt"  >> "$FAIL_REFINE_FILE"
    cat "${MODE}_param_fail.txt"   >> "$FAIL_PARAM_FILE"


    fi
}

export -f perDirectory


for MODE in $MODES ; do
    FAIL_FILE="$WD/${MODE}_fail.txt"
    PASS_FILE="$WD/${MODE}_pass.txt"
    ALL_FILE="$WD/${MODE}_all.txt"


    FAIL_REFINE_FILE="$WD/${MODE}_refine_fail.txt"
    FAIL_PARAM_FILE="$WD/${MODE}_param_fail.txt"

    rm -f "$FAIL_FILE" "$PASS_FILE" "$ALL_FILE"
    touch "$FAIL_FILE" "$PASS_FILE" "$ALL_FILE"
    
    rm -f "$FAIL_REFINE_FILE" "$FAIL_PARAM_FILE"
    touch  "$FAIL_REFINE_FILE" "$FAIL_PARAM_FILE"    
done

parallel -k --tag perDirectory {2} {1//} ::: $(find "$WD" -name "*.essence") ::: $MODES

for MODE in $MODES ; do
    FAIL_FILE="$WD/${MODE}_fail.txt"
    PASS_FILE="$WD/${MODE}_pass.txt"
    ALL_FILE="$WD/${MODE}_all.txt"

    FAIL_COUNT_FILE="$WD/${MODE}_countFail.txt"
    PASS_COUNT_FILE="$WD/${MODE}_countPass.txt"
    ALL_COUNT_FILE="$WD/${MODE}_countAll.txt"

    FAIL_REFINE_FILE="$WD/${MODE}_refine_fail.txt"
    FAIL_PARAM_FILE="$WD/${MODE}_param_fail.txt"

    FAIL_REFINE_COUNT_FILE="$WD/${MODE}_countRefineFail.txt"
    FAIL_PARAM_COUNT_FILE="$WD/${MODE}_countParamFail.txt"

    FAIL_COUNT=$(cat "$FAIL_FILE" | wc -l | tr -d ' ')
    PASS_COUNT=$(cat "$PASS_FILE" | wc -l | tr -d ' ')
    ALL_COUNT=$( cat "$ALL_FILE"  | wc -l | tr -d ' ')

    FAIL_REFINE_COUNT=$( cat "$FAIL_REFINE_FILE"  | wc -l | tr -d ' ')
    FAIL_PARAM_COUNT=$( cat "$FAIL_PARAM_FILE"  | wc -l | tr -d ' ')


    echo "YVALUE=$FAIL_COUNT" > "$FAIL_COUNT_FILE"
    echo "YVALUE=$PASS_COUNT" > "$PASS_COUNT_FILE"
    echo "YVALUE=$ALL_COUNT"  > "$ALL_COUNT_FILE"

    echo "YVALUE=$FAIL_REFINE_COUNT" > "$FAIL_REFINE_COUNT_FILE"
    echo "YVALUE=$FAIL_PARAM_COUNT" > "$FAIL_PARAM_COUNT_FILE"


    echo "($MODE) Number of failing tests: "
    cat "$FAIL_COUNT_FILE"
    cat "$FAIL_FILE"

    echo "($MODE) Number of passing tests: "
    cat "$PASS_COUNT_FILE"

    echo "($MODE) Number of all tests: "
    cat "$ALL_COUNT_FILE"
    
    echo "($MODE) Number of failing spec refinments: "
    cat "$FAIL_REFINE_COUNT_FILE"
    
    echo "($MODE) Number of failing param refinments: "
    cat "$FAIL_PARAM_COUNT_FILE"
    
done

