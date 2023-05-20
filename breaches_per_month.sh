#!/bin/bash

# Created by Connor Grayden (23349066)

# check argc
if [ "$#" -ne 1 ]; then
    echo "Usage: breaches_per_month [filename]"
    exit 1
fi

# check if input file exists
if [[ ! -f $1 ]]; then
    echo "Error: File does not exist or is zero-length"
    exit 1
fi

# Analysis driver code
cut -f6 "$1" | sort | uniq -c | sort -k2n | awk '{print}' > prelim.txt

sed '1d' prelim.txt > data.txt


awk ' {
    FS=OFS=" "
    split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", months, " ")
    month = $(2)
    $(2) = months[month]
} 1' data.txt > "temp.txt"

awk '{
        temp = $1
        $1 = $2
        $2 = temp
        print
    }' temp.txt > almostdone.txt

sort -k2n almostdone.txt | awk '{print}' > sorteddata.txt

awk ' {
    data[NR-1] = $2
    months[NR-1] = $1
} END {
    total = 0
    for(i=0;i<12;i++)
        total += data[i]

    #for(i=0;i<12;i++)
    #    print data[i], months[i]

    #print "total is: " total
    median = (data[5] + data[6])/2
    print median

    for(i=0;i<12;i++) {
        value = data[i] - median
        new = value
        if (value < 0)
            meddata[i] = value * -1
        else
            meddata[i] = value
        print meddata[i]
    }

    #MAD = (meddata[5] + meddata[6])/2
    #print "MAD is " MAD
}' sorteddata.txt > meddata.txt

cut -f 1 meddata.txt | head -n 1 | awk '{print}' > median.txt
median=$(cat median.txt)

sed -i '1d' meddata.txt

sort -k1n meddata.txt | awk '{print}' > finaldata.txt


awk ' {
    data[NR-1] = $1
} END {
    MAD = (data[5] + data[6])/2
    print MAD
}' finaldata.txt > MAD.txt

MAD=$(cat MAD.txt)

echo $median $MAD

awk -v MAD="$MAD" -v median="$median" ' {
    months[NR-1] = $1
    data[NR-1] = $2
} END {
    for(i=0;i<12;i++) {
        diff = (data[i]-median)
        if (diff < (MAD * (-1) ) )
            print months[i],data[i],"--"
        else if (diff <= MAD )
            print months[i],data[i]
        else
            print months[i],data[i],"++"
    }
}' almostdone.txt > output.txt

echo $(cat output.txt)

rm prelim.txt data.txt temp.txt finaldata.txt MAD.txt meddata.txt median.txt output.txt sorteddata.txt almostdone.txt

#cut -f6 "$1" | sort | uniq -c | sort -nr | head -1 | awk '{print "State with greatest number of incidents is: "$2" with count "$1}' ;;

        
exit 0