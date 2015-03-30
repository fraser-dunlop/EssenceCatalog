#!/bin/bash

OUTDIR="results/baseline"

conjure -qf -ac prob013-party.essence -o ${OUTDIR}

parallel --eta "conjure refine-param --eprime {1} --essence-param {2} --eprime-param ${OUTDIR}/{1/.}-{2/.}.eprime-param" \
    ::: ${OUTDIR}/*.eprime \
    ::: params/*.param

parallel --eta "savilerow -in-eprime {1} -in-param ${OUTDIR}/{1/.}-{2/.}.eprime-param -out-solution ${OUTDIR}/{1/.}-{2/.}.eprime-solution -run-solver -minion -solver-options '-cpulimit 60'" \
    ::: ${OUTDIR}/*.eprime \
    ::: params/*.param

parallel --eta "conjure translate-solution --eprime {1} --essence-param {2} --eprime-solution ${OUTDIR}/{1/.}-{2/.}.eprime-solution --essence-solution ${OUTDIR}/{1/.}-{2/.}.solution" \
    ::: ${OUTDIR}/*.eprime \
    ::: params/*.param

