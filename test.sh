#!/bin/bash

# check if input file exists
if [[ ! -f $2 ]]; then
    echo "Error: File does not exist or is zero-length"
    exit 1
fi

case "$1" in
    preprocess)
        #preprocess code
        echo "preprocess time"
        # cuts off non-needed fields
        #sed -i 's/\([^,\/]*\).*/\1/' "$2"
        cleantype=$(awk 'BEGIN{FS=OFS="\t"} {sub(/[,\/].*/, "", $5)} 1' $2 > "temp.tsv")

        cutoff=$(cut --complement -f6,7 "temp.tsv" | awk '{print}')
        echo $cutoff
        ;;
    breaches_per_month)
        echo "breach time"
        ;;
    *)
        echo "Usage: cyber_breaches preprocess or breaches_per_month"
        exit 1
        ;;

esac

input=$2

#echo $(cat $input)