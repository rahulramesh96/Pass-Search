#!/bin/bash

# Define the output file
OUTPUT_FILE="report.txt"

# Clear the output file if it exists
> $OUTPUT_FILE

# Define the search terms and regex patterns for hashes
SEARCH_TERMS=("password" "pass" "hash")
HASH_PATTERNS=(
  '[a-f0-9]{32}'                      # MD5
  '[A-Fa-f0-9]{64}'                   # SHA-256
  '[A-Fa-f0-9]{40}'                   # SHA-1
  '[A-Fa-f0-9]{128}'                  # SHA-512
)

# Function to search and highlight terms
search_and_highlight() {
  local term="$1"
  grep -Ri --include="*.{pass,password}" --color=always "$term" / 2>/dev/null | while read -r line; do
    # Extract the file path from the grep output
    FILE_PATH=$(echo "$line" | awk -F: '{print $1}')
    # Highlight the matching term in the line
    HIGHLIGHTED_LINE=$(echo "$line" | sed "s/$term/\x1b[1;31m&\x1b[0m/Ig")
    # Print the result to the console
    echo "$HIGHLIGHTED_LINE"
    # Save the result to the output file
    echo "$HIGHLIGHTED_LINE" >> "$OUTPUT_FILE"
  done
}

# Search for the defined search terms in specific file extensions
for term in "${SEARCH_TERMS[@]}"; do
  search_and_highlight "$term"
done

# Search for the hash patterns in specific file extensions
for pattern in "${HASH_PATTERNS[@]}"; do
  grep -RPoi --include="*.{pass,password}" --color=always "$pattern" / 2>/dev/null | while read -r line; do
    # Extract the file path from the grep output
    FILE_PATH=$(echo "$line" | awk -F: '{print $1}')
    # Highlight the matching hash pattern in the line
    HIGHLIGHTED_LINE=$(echo "$line" | sed "s/$pattern/\x1b[1;31m&\x1b[0m/Ig")
    # Print the result to the console
    echo "$HIGHLIGHTED_LINE"
    # Save the result to the output file
    echo "$HIGHLIGHTED_LINE" >> "$OUTPUT_FILE"
  done
done

echo "Results saved to $OUTPUT_FILE"
