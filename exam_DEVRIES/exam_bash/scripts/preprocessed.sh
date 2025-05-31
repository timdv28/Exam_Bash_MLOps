#!/bin/bash 

YYYYMMDD_HHMM=$(date -u +"%Y%m%d_%H%M")

log_file="logs/preprocessed.logs"
preproc_start=$(date -u +"%Y-%m-%d %H:%M")
preproc_filepath="src/preprocessed.py"
all_sales_files="data/processed/sales_processed_*.csv"
sales_processed="data/processed/sales_processed_${YYYYMMDD_HHMM}.csv"

echo "=== Start of tests (${preproc_start}) ===" >> "$log_file"

if [ -f "${preproc_filepath}" ]
then
    python3 "${preproc_filepath}"
    echo "Preprocessing executed" >> "$log_file"
    rows=$(awk 'END {print NR - 1}' "${sales_processed}")
    echo "Rows of sales data appended. Current number of rows: ${rows}" >> "$log_file"

else
    echo "No preprocessing script found" >> "$log_file"
fi

echo "=== End of preprocessing ===" >> "$log_file"
echo "     " >> "$log_file"

# =============================================================================
# This script preprocessed.sh runs the program src/preprocessed.py
# and logs the execution details in the log file
# logs/preprocessed.logs.
# =============================================================================

