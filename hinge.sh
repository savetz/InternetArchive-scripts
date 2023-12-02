#!/bin/sh
# HINGE - a dating app

if [ "$1" ]
   then
   SEARCH=$1
   else
   echo "What is the search string for the items you're going to muck dates on?"
   read SEARCH
fi

for item in `ia search ${SEARCH} -i`
    do
    echo "=== $item"
    DATEFIELD=`ia metadata $item | sed 's/.*\"date\": \"//g' | cut -f1 -d'"'`
    TITLEFIELD=`ia metadata $item | sed 's/.*\"title\": \"//g' | cut -f1 -d'"'`
    if [ ! "$DATEFIELD" = "{" ]
       then
           echo "$item already has a date field: $DATEFIELD"
   else
           GUESS=`echo "$TITLEFIELD" | grep -Eo "(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])" | tail -1` #YYYY-MM-DD
           if [ -z "$GUESS" ]
           then
               GUESS=`echo "$TITLEFIELD" | grep -Eo "(19|20)\d\d-(0[1-9]|1[012])" | tail -1` #YYYY-MM
               if [ -z "$GUESS" ]
               then
                   GUESS=`echo "$TITLEFIELD" | grep -Eo "(19|20)\d\d" | tail -1` #YYYY
               fi
           fi

           echo "Title of $item is: $TITLEFIELD"
           echo "My guess is $GUESS"
           echo "Enter a replacement date, or return for my guess, or x to skip."
           read REPLACE
           if [ "$REPLACE" ]
           then
               if [ "$REPLACE" != "x" ]
               then 
                   ia metadata $item -m "date:${REPLACE}"
               else
                   echo "OK, skipping..."
               fi
           else
               ia metadata $item -m "date:${GUESS}"
           fi
      fi
done

