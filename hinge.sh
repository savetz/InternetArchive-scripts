#!/bin/sh
# HINGE - a dating app for metadata

if [ "$1" ]; then
   SEARCH=$1
else
   echo "What is the search string for the items you're going to modify dates on?"
   read SEARCH
fi

for item in $(ia search "${SEARCH}" -i)
do
    echo
    echo "=== $item"

    # Save metadata to a temporary file
    ia md "$item" > metadata.json

    # Clean the metadata file (remove control characters)
    tr -d '\000-\037' < metadata.json > cleaned_metadata.json

    # Now read the cleaned metadata using jq
    DATEFIELD=$(jq -r '.metadata.date // empty' cleaned_metadata.json)
    TITLEFIELD=$(jq -r '.metadata.title // empty' cleaned_metadata.json)

    echo "Title: $TITLEFIELD"

    if [ -n "$DATEFIELD" ] && [ "$DATEFIELD" != "{" ]; then
        echo "$item already has a date field: $DATEFIELD"
    else
        echo "$item does not have an existing date."
    fi

    # Remove non-numeric characters (including unicode and special characters) from the title for date guessing
    CLEAN_TITLE=$(echo "$TITLEFIELD" | tr -cd '[:alnum:]- ')
    
    # Guess the date from the cleaned title (including both YYYY-MM-DD and YYYY MM DD formats)
    GUESS=$(echo "$CLEAN_TITLE" | grep -Eo "(19|20)\d\d[- ](0[1-9]|1[012])[- ](0[1-9]|[12][0-9]|3[01])" | tail -1)
    GUESS=$(echo "$GUESS" | tr ' ' '-') # Ensure the guessed date is always in the format YYYY-MM-DD

    if [ -z "$GUESS" ]; then
        GUESS=$(echo "$CLEAN_TITLE" | grep -Eo "(19|20)\d\d[- ](0[1-9]|1[012])" | tail -1)
        GUESS=$(echo "$GUESS" | tr ' ' '-')
        if [ -z "$GUESS" ]; then
            GUESS=$(echo "$CLEAN_TITLE" | grep -Eo "(19|20)\d\d" | tail -1)
            if [ "$GUESS" ]; then
                # Add month guess based on month name in title
                case "$TITLEFIELD" in
                    *"Jan"*) GUESS="$GUESS-01" ;;
                    *"Feb"*) GUESS="$GUESS-02" ;;
                    *"Mar"*) GUESS="$GUESS-03" ;;
                    *"Apr"*) GUESS="$GUESS-04" ;;
                    *"May"*) GUESS="$GUESS-05" ;;
                    *"Jun"*) GUESS="$GUESS-06" ;;
                    *"Jul"*) GUESS="$GUESS-07" ;;
                    *"Aug"*) GUESS="$GUESS-08" ;;
                    *"Sep"*) GUESS="$GUESS-09" ;;
                    *"Oct"*) GUESS="$GUESS-10" ;;
                    *"Nov"*) GUESS="$GUESS-11" ;;
                    *"Dec"*) GUESS="$GUESS-12" ;;
                esac
            fi
        fi
    fi

    # Show the title and guessed date
    if [ "$GUESS" ]; then
        echo "My guess is: $GUESS"

        # Check if the guessed date is the same as the existing date
        if [ "$GUESS" = "$DATEFIELD" ]; then
            echo "   ...which is the same. Moving on."
            continue
        fi

        # Check date precision (Year: 0, Year-Month: 1, Year-Month-Day: 2)
        GUESS_PRECISION=$(echo "$GUESS" | grep -o '[- ]' | wc -l)
        DATEFIELD_PRECISION=$(echo "$DATEFIELD" | grep -o '[- ]' | wc -l)

        if [ "$GUESS_PRECISION" -lt "$DATEFIELD_PRECISION" ]; then
            echo "   ...but my guess is less precise than the existing date. Skipping."
            continue
        fi

        # Prompt for user input if the guessed date is more precise or if there's no existing date
        echo "Enter a replacement date, or return for my guess, or 'x' to skip."
        read REPLACE
        if [ "$REPLACE" ]; then
            if [ "$REPLACE" != "x" ]; then
                ia metadata "$item" -m "date:${REPLACE}"
            else
                echo "OK, skipping..."
            fi
        else
            ia metadata "$item" -m "date:${GUESS}"
        fi
    else
        echo "No valid date found in the title. Skipping..."
    fi
done
