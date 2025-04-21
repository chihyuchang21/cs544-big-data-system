#!/bin/bash

# Download the files
wget https://pages.cs.wisc.edu/~harter/cs544/data/wi2021.csv.gz
wget https://pages.cs.wisc.edu/~harter/cs544/data/wi2022.csv.gz
wget https://pages.cs.wisc.edu/~harter/cs544/data/wi2023.csv.gz

# Decompress the files
gunzip wi2021.csv.gz
gunzip wi2022.csv.gz
gunzip wi2023.csv.gz

# Concatenate the files into wi.txt
cat wi2021.csv wi2022.csv wi2023.csv > wi.txt
