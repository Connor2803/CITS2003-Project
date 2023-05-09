#!/bin/bash

# check if input file exists
if [[ ! -f $2 ]]; then
    echo "Error: File does not exist or is zero-length"
    exit 1
fi

case "$1" in
    preprocess)
        # Preprocess driver code
 
        # Cuts off non-needed fields
        cut --complement -f6,7 "$2" | awk '{print}' > mid.tsv

        # Removes all characters after a , / or \ in the fifth field
        awk ' {
                FS=OFS="\t"
                sub(/[,\/].*/, "", $5)
            } 1' mid.tsv > "temp.tsv"

        # Adds the new columns Month and Year
        awk ' {
                FS=OFS="\t"


                split($4, date, /[\/]/)
                month = date[1]
                year = date[3]
                if (substr(month,1,1) == "0")
                    $(6) = substr(month,2,2)
                else
                    $(6) = month
                if (length(year) == 2)
                    if (year > 70)
                        $(7) = "19" year
                    else
                        $(7) = "20" year
                else
                    $(7) = substr(year, 1, 4)
            } 1' temp.tsv > Clean.tsv

        # Fixes the header line
        sed -i '1s/.*/Name_of_Covered_Entity\tState\tIndividuals_Affected\tDate_of_Breach\tType_of_Breach\tMonth\tYear/' Clean.tsv

        awk '{print}' Clean.tsv
        
        rm mid.tsv temp.tsv Clean.tsv
        
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