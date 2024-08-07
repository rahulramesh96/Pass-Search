#!/bin/bash

# Define the output file
OUTPUT_FILE="report.txt"

# Clear the output file if it exists
> $OUTPUT_FILE

# Define the search terms
SEARCH_TERMS=("password" "pass" "hash")

# Recursively search for the terms in all files
for term in "${SEARCH_TERMS[@]}"; do
  # Use grep to search for the term case-insensitively and output the line number and file name
  grep -Ri --include="*" --color=always "$term" / 2>/dev/null | while read -r line; do
    # Extract the file path from the grep output
    FILE_PATH=$(echo "$line" | awk -F: '{print $1}')
    # Highlight the matching term in the line
    HIGHLIGHTED_LINE=$(echo "$line" | sed "s/$term/\x1b[1;31m&\x1b[0m/Ig")
    # Print the result to the console
    echo "$HIGHLIGHTED_LINE"
    # Save the result to the output file
    echo "$HIGHLIGHTED_LINE" >> "$OUTPUT_FILE"
  done
done

echo "Results saved to $OUTPUT_FILE"
