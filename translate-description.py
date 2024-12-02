#!/usr/bin/env python3

import sys
import json
import requests
import subprocess
import shlex

API_KEY = 'your chatGPT API key goes here'
MODEL = 'gpt-4o-mini'

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <internet_archive_url_or_identifier>")
    sys.exit(1)

# Extract the identifier
identifier = sys.argv[1].replace('https://archive.org/details/', '').split('/')[0]

# Fetch the existing metadata
response = requests.get(f'https://archive.org/metadata/{identifier}')
if response.status_code != 200:
    print(f"Failed to fetch metadata for identifier: {identifier}")
    sys.exit(1)

try:
    metadata_json = response.json()
except json.JSONDecodeError as e:
    print("Error parsing JSON:", e)
    sys.exit(1)

# Extract the original description
description = metadata_json.get('metadata', {}).get('description', '')
if not description:
    print("No valid description found.")
    sys.exit(0)

#print("Original Description:")
#print(description)

# Translate the description
headers = {
    'Authorization': f'Bearer {API_KEY}',
    'Content-Type': 'application/json',
}

data = {
    "model": MODEL,
    "messages": [
        {"role": "system", "content": "You are a helpful assistant skilled at translating text to English."},
        {"role": "user", "content": description}
    ]
}

response = requests.post('https://api.openai.com/v1/chat/completions', headers=headers, json=data)
if response.status_code != 200:
    print("Failed to translate the description.")
    print("API Response:", response.text)
    sys.exit(1)

translated_description = response.json()['choices'][0]['message']['content']
print("---------------------------------")
print(f"{identifier}:")
print(translated_description)

# Prepare the new description
preface = '''Episode description translated into English by machine:

'''
notes_content = preface + translated_description

# Remove trailing newlines to avoid issues
notes_content = notes_content.strip()

# Construct the `ia` command
command = ["ia", "md", identifier, "-m", f"notes:{notes_content}"]

# Execute the command
result = subprocess.run(command, capture_output=True, text=True)


if result.returncode == 0:
    print("Metadata updated successfully.")
else:
    print("Failed to update metadata.")
    print("Command Output:", result.stdout)
    print("Command Error:", result.stderr)
    sys.exit(1)
