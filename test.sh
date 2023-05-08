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
        
        
        
        # removes all characters after a , / or \ in the fifth field
 
        # cuts off non-needed fields
        cut --complement -f6,7 "$2" | awk '{print}' > mid.tsv

        awk 'BEGIN{FS=OFS="\t"} {sub(/[,\/].*/, "", $5)} 1' mid.tsv > "temp.tsv"

        awk 'BEGIN{FS=OFS="\t"} {
            split($4, date, /[\/]/)
            month = date[1]
            year = date[3]
            $(6) = month
            $(7) = year
            print
        }' temp.tsv > Clean.tsv

        echo Clean.tsv > stdout
        
        #rm mid.tsv temp.tsv
        
        exit 1
        
        #echo $cutoff

        ;;
    breaches_per_month)
        echo "breach time"
        cut -f4 "$2" | awk '{print}'

        
        ;;
    *)
        echo "Usage: cyber_breaches [preprocess OR breaches_per_month] [filename]"
        exit 1
        ;;

esac

input=$2

#echo $(cat $input)