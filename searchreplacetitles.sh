#!/bin/bash

# Check for the -f or --force option and capture the search string
FORCE=false
SEARCH=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--force) FORCE=true ;; # Set force mode to true
        *) SEARCH="$1" ;; # Set search string if provided
    esac
    shift
done

# If search string is not provided, prompt the user
if [ -z "$SEARCH" ]; then
   echo "What is the search string for the items you're going to change titles on?"
   read SEARCH
fi

# Prompt for the search pattern and read it as a whole line
echo -n "Enter the search pattern: "
IFS= read -r SEARCH_PATTERN

# Prompt for the replace pattern and read it as a whole line
echo -n "Enter the replace pattern: "
IFS= read -r REPLACE_PATTERN

# Perform the search and replace
for ITEM_ID in $(ia search "$SEARCH" -i); do
    ORIGINAL_TITLE=$(ia md "$ITEM_ID" | jq -r '.metadata.title')

    # Handle the search pattern with leading or trailing spaces
    NEW_TITLE=$(echo "$ORIGINAL_TITLE" | sed "s/$SEARCH_PATTERN/$REPLACE_PATTERN/g")

    # Normalize spaces: Replace multiple spaces with a single space
    NEW_TITLE=$(echo "$NEW_TITLE" | tr -s ' ')

    # Show the potential change
    if [ "$ORIGINAL_TITLE" != "$NEW_TITLE" ]; then
        echo ""
        echo "Item ID: $ITEM_ID"
        echo "Original Title: $ORIGINAL_TITLE"
        echo "Proposed Title: $NEW_TITLE"
        
        # If force mode is enabled, skip confirmation
        if [ "$FORCE" = true ]; then
            echo "Force mode enabled: Updating title for $ITEM_ID..."
            ia metadata "$ITEM_ID" -m "title:$NEW_TITLE"
        else
            # Ask for confirmation
            read -rp "Do you want to update the title? (y/N): " CONFIRMATION
            if [ "$CONFIRMATION" = "y" ]; then
                echo "Updating title for $ITEM_ID..."
                ia metadata "$ITEM_ID" -m "title:$NEW_TITLE"
            else
                echo "Skipping $ITEM_ID"
            fi
        fi
    else
        echo "No change for $ITEM_ID"
    fi
done