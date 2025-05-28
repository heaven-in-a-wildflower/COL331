#!/bin/bash

# Create tar.gz archive
tar czvf assignment2_easy_2022CS11078_2022CS11116.tar.gz *

# Copy the archive to check_scripts directory
cp assignment2_easy_2022CS11078_2022CS11116.tar.gz ../check_scripts

# Change to check_scripts directory
cd ../check_scripts

# Run the check script
bash check.sh assignment2_easy_2022CS11078_2022CS11116.tar.gz
