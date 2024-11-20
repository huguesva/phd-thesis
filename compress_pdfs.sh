#!/bin/bash

# Check if the required directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

# Input folder
INPUT_FOLDER="$1"

# Output directory for compressed PDFs
OUTPUT_FOLDER="${INPUT_FOLDER}/compressed_pdfs"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Function to compress a single PDF
compress_pdf() {
    local input_file="$1"
    local output_file="$2"

    echo "Compressing: $input_file"
    # Use Ghostscript to compress the PDF
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
       -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -dQUIET \
       -sOutputFile="$output_file" "$input_file"

    if [ $? -eq 0 ]; then
        echo "Compressed: $output_file"
    else
        echo "Error compressing: $input_file"
    fi
}

# Export function for use in find -exec
export -f compress_pdf

# Recursively find and compress all PDFs
find "$INPUT_FOLDER" -type f -iname "*.pdf" | while read -r pdf_file; do
    # Compute output path
    output_file="${OUTPUT_FOLDER}/$(basename "$pdf_file")"
    compress_pdf "$pdf_file" "$output_file"
done

echo "Compression complete. Compressed files are located in: $OUTPUT_FOLDER"
