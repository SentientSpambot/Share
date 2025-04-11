#!/bin/bash

#Log file w/ data
log_file="flac_conversion_$(date +%Y%m%d_%H%M%S).log"

#Start log
echo "Starting FLAC to ALAC conversion at $(date)" | tee "$log_file"

#Find all flac files in current and sub directories
find . -type f -name "*.flac" -print0 | while IFS= read -d '' -r f; do
    #Remove any leading slash
    fixed_path="${f#/}"
    #Get the path and filename
    dir=$(dirname "$fixed_path")
    filename=$(basename "$fixed_path")
    #Create output filename
    output_file="${dir}/${filename%.flac}.m4a"
    echo "Converting: \"$fixed_path\"" | tee -a "$log_file"
    ffmpeg -i "$fixed_path" -map 0 -c:a alac -c:v mjpeg "$output_file" 2>&1 | tee -a "$log_file"
    #Check if conversion was successful
    if [ $? -eq 0 ]; then
        echo "Successfully converted to \"$output_file\"" | tee -a "$log_file"
    else
        echo "Failed to convert: \"$fixed_path\"" | tee -a "$log_file"
    fi
done
echo "## Conversion Complete at $(date) ##" | tee -a "$log_file"
echo "Log file saved as: $log_file" | tee -a "$log_file"

#v6
