#!/bin/bash

# Step 1: Run download.sh to get wi.txt
./download.sh

# Step 2: Count lines with "Multifamily" (case-insensitive)
count=$(grep -i "Multifamily" wi.txt | wc -l)

# Step 3: Print the result
echo "Number of lines containing 'Multifamily': $count"
