
# timestamp: 20141203-115734
function conjure_noch {
    parallel --tag --joblog parallel-joblog-noch --results parallel-results-noch \
        "conjure --smart-filenames -q f -a x {} -o {.}-noch --channelling=no" ::: $(find problems -name *.essence)
    find parallel-results-noch -type f -size 0 -delete
}

# timestamp: 20141203-115937
function conjure_compact {
    parallel --tag --joblog parallel-joblog-compact --results parallel-results-compact \
        "conjure --smart-filenames -q f -a c {} -o {.}-compact" ::: $(find problems -name *.essence)
    find parallel-results-compact -type f -size 0 -delete
}
