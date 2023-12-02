#!/bin/bash

# Check if an identifier is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <identifier or URL>"
    exit 1
fi

identifier=`echo "$1" | sed -E 's/\https:\/\/archive.org\/details\///'`
identifier=`echo "$identifier" | sed 's/\/.*//'`

# Fetch metadata using the ia tool
metadata_json=$(ia metadata "$identifier")

# Function to extract and encode a metadata field
extract_and_encode() {
    local field_name="$1"
    local value=$(echo "$metadata_json" | jq -r ".metadata.$field_name // empty")
    if [[ -n "$value" ]]; then
        echo "&$field_name=$(echo "$value" | jq -sRr @uri)"
    else
        echo ""
    fi
}

# Extract and encode metadata fields
DESCRIPTION=$(extract_and_encode "description")
DATE=$(extract_and_encode "date")
CREATOR=$(extract_and_encode "creator")
TITLE=$(extract_and_encode "title")
LANGUAGE=$(extract_and_encode "language")
SOURCE=$(extract_and_encode "source")
LICENSEURL=$(extract_and_encode "licenseurl")

# Handle topics and only the first collection
TOPICS=$(echo "$metadata_json" | jq -r '.metadata.subject[] // empty' | tr '\n' ',' | sed 's/,$//' | jq -sRr @uri)
FIRST_COLLECTION=$(echo "$metadata_json" | jq -r '.metadata.collection[0] // empty' | jq -sRr @uri)

# Construct the upload link
UPLOAD_LINK="https://archive.org/upload/?${DESCRIPTION}${DATE}${CREATOR}${TITLE}${LANGUAGE}${SOURCE}${LICENSEURL}&collection=$FIRST_COLLECTION&subject=$TOPICS"

echo "$UPLOAD_LINK"

