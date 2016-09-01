#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

# these should be deleted by the runConjure script, but just in case.
# we really don't want them to stay since they can be so large.
find problems -name '*.eprime-dimacs' -delete
find problems -name '*.eprime-minion' -delete

# these can now be deleted, assuming the collect_info was exeuted.
find problems -name '*.eprime-info'   -delete
find problems -name '*.eprime-infor'  -delete

# the eprimes are duplicated during solving. remove them here.
# problems/${PROBLEM}/${ESSENCE_BASE}-models/${CONJURE_MODE}/${SAVILEROW_MODE}/${SOLVER}
rm -f problems/*/*-models/*/*/*/*.eprime
