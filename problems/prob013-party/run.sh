#!/bin/bash

if [ $# = 2 ] ; then
    if [ $1 = "baseline" ]; then
        ESSENCE="prob013-party.essence"
        CPULIMIT="$2"
        OUTDIR="results/${CPULIMIT}/baseline"
    elif [ $1 = "implied" ] ; then
        ESSENCE="prob013-party-implied.essence"
        CPULIMIT="$2"
        OUTDIR="results/${CPULIMIT}/implied"
    else
        echo "first arg should be either 'baseline' or 'implied'"
        exit 1
    fi
else
    echo "requires 2 args"
    exit 1
fi

conjure -qf -ac ${ESSENCE} -o ${OUTDIR}

parallel --eta "conjure refine-param --eprime {1} --essence-param {2} --eprime-param ${OUTDIR}/{1/.}-{2/.}.eprime-param" \
    ::: ${OUTDIR}/*.eprime \
    ::: params/*.param

parallel --eta "savilerow -in-eprime {1} -in-param ${OUTDIR}/{1/.}-{2/.}.eprime-param -out-solution ${OUTDIR}/{1/.}-{2/.}.eprime-solution -run-solver -minion -solver-options '-cpulimit ${CPULIMIT}'" \
    ::: ${OUTDIR}/*.eprime \
    ::: params/*.param

parallel --eta "conjure translate-solution --eprime {1} --essence-param {2} --eprime-solution ${OUTDIR}/{1/.}-{2/.}.eprime-solution --essence-solution ${OUTDIR}/{1/.}-{2/.}.solution" \
    ::: ${OUTDIR}/*.eprime \
    ::: params/*.param

