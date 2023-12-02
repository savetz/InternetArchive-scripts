#!/bin/sh

if [ "$1" ]
   then
   SEARCH=$1
   else
   echo "What is the search string for the items you're checking thumbs for?"
   read SEARCH
fi

for i in $(ia search ${SEARCH} -i); do
result=$(ia list "$i" | grep '__ia_thumb.jpg')

if [ -z "$result" ]; then
    echo "$i"
fi
done

