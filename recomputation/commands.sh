
function gen_eprimes {

    # remove old eprimes
    rm problems/*/*/*.eprime

    # prepare the commands to be run
    find problems -name "*.essence" > essences_all.temp
    cp essences_all.temp essences_compact.temp
    # cat essences_all.temp | grep -v 'prob131\|prob116\|prob115\|prob123\|prob038\|prob031\|prob037\|prob128' > essences_noch.temp
    cp essences_all.temp essences_noch.temp
    parallel -j1 "echo conjure --smart-filenames -qf -ac {} --channelling=no -o {.}-compact" \
        :::: essences_compact.temp > all_commands.temp
    parallel -j1 "echo conjure --smart-filenames -qf -ax {} --channelling=no -o {.}-noch --representations-givens=c --representations-auxiliaries=c --representations-quantifieds=c --representations-cuts=c" \
        :::: essences_noch.temp >> all_commands.temp

    # run the commands
    parallel --tag --joblog parallel-joblog --results parallel-results :::: all_commands.temp

    # remove temp files
    rm *.temp

    # strip the json bits from the eprimes
    parallel "[ -f {} ] && (cat {} | grep -v '\\$' > {}.temp ; mv {}.temp {})" ::: $(find problems -name "*.eprime")
}
