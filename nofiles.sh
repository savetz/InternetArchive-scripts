#!/bin/bash

if [ "$1" ]
   then
   SEARCH=$1
   else
   echo "What is the search string for the items you're checking files for?"
   read SEARCH
fi

for identifier in $(ia search ${SEARCH} -i); do

    # Run 'ia list' and count the number of lines in the output
    file_count=$(ia list $identifier | grep -v '.xml' | wc -l)

    # Check if the file count is zero
    if [ "$file_count" -eq 0 ]; then
        echo $identifier
    fi

done