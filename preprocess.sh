#!/bin/bash

# Created by Connor Grayden (23349066)

# check argc
if [ "$#" -ne 1 ]; then
    echo "Usage: preprocess [filename]" > "/dev/stderr"
    exit 1
fi

# check if input file exists
if [[ ! -f $1 ]]; then
    echo "Error: File does not exist or is zero-length" > "/dev/stderr"
    exit 1
fi

# Cuts off non-needed fields
cut --complement -f6,7 "$1" | awk '{print}' | 

awk ' {
        FS=OFS="\t"

        # Removing unnecessary information in the Type_of_Breach field
        sub(/[,\/].*/, "", $5)

        # Splitting and assigning the values for the date
        split($4, date, /[\/]/)
        month = date[1]
        day = date[2]
        year = date[3]

        # Check if the month is within the range of 1-12 and the year is positive
        if (month >= 1 && month <= 12) {
            # If the month starts with a 0, remove it
            if (substr(month,1,1) == "0")
                $(6) = substr(month,2,2)
            else
                $(6) = month

            # Fixing the years if they are only 2 digits
            if (length(year) == 2)
                if (year > 70)
                    $(7) = "19" year
                else
                    $(7) = "20" year
            # If the dates are a range, only take the first year
            else
                $(7) = substr(year, 1, 4)
            print
        }
    }' > Clean.tsv

# Finalizes the header line
sed -i '1s/.*/Name_of_Covered_Entity\tState\tIndividuals_Affected\tDate_of_Breach\tType_of_Breach\tMonth\tYear/' Clean.tsv

awk '{print}' Clean.tsv > "/dev/stdout"

rm Clean.tsv

exit 0
