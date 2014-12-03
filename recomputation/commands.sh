# timestamp: 20141203-115734
function conjure_noch {
    clear ; parallel --tag --joblog parallel-joblog-noch --results parallel-results-noch "conjure --channelling=no -q f -a x {} -o {.}-noch" ::: $(find problems -name *.essence) ; find parallel-results-noch -type f -size 0 -delete
}

# timestamp: 20141203-115937
function conjure_compact {
    clear ; parallel --tag --joblog parallel-joblog-compact --results parallel-results-compact "conjure -q f -a f {} -o {.}-compact" ::: $(find problems -name *.essence) ; find parallel-results-compact -type f -size 0 -delete
}

