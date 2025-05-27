#!/bin/bash 
# Dates and times
coll_start=$(date -u +"%Y-%m-%d %H:%M")
YYYYMMDD_HHMM=$(date -u +"%Y%m%d_%H%M")
timestamp=$(date -u +"%Y-%m-%d %H:%M")

# Start of writing the logfile
log_file="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/logs/collect.logs"
echo "=== Start of collection (${coll_start}) ===" >> "$log_file"

# Two data files: now_data prints out the current data pull. The collected data is appended to sales_data
now_data="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/data/raw/sales_${YYYYMMDD_HHMM}.csv"
sales_data="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/data/raw/sales_data.csv"
models=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")


if [ -f "${sales_data}" ]
then
  num_rows=$(awk 'END {print NR - 1}' "${sales_data}")
  num_cols=$(awk -F',' 'NR==1 {print NF}' ${sales_data})
  echo "File with sales data found with ${num_rows} rows and ${num_cols} columns" >> "$log_file"
else
  echo "File with sales data not found, process aborted" >> "$log_file"
  echo "=== End of data collection ===" >> "$log_file"
  echo "     " >> "$log_file"
  exit 1
fi

columns=('timestamp','model','sales')
echo $columns >> "$now_data"
for model in "${models[@]}";
do
  sales=$(/usr/bin/curl -s "http://0.0.0.0:5000/$model")
if [ -z "${sales}" ]
then
  echo "No data collected, check if the API is activated" >> "$log_file"
  echo "=== End of data collection ===" >> "$log_file"
  echo "     " >> "$log_file"
  exit 1
else
  echo "$timestamp,$model,$sales" >> "$sales_data"
  echo "$timestamp,$model,$sales" >> "$now_data"
  
fi   
done

# End of the script and the log
echo "Data collection succesfull: Row with sales appended" >> "$log_file"
echo "=== End of data collection ===" >> "$log_file"
echo "     " >> "$log_file"

# ==============================================================================
# Script: collect.sh
# Description:
#   This script queries an API every minute for 3 minutes to retrieve sales data
#   for the following graphics card models:
#     - rtx3060
#     - rtx3070
#     - rtx3080
#     - rtx3090
#     - rx6700
#
#   The collected data is appended to a copy of the file:
#     data/raw/sales_data.csv
#
#   The output file is saved in the format:
#     data/raw/sales_YYYYMMDD_HHMM.csv
#   with the following columns:
#     timestamp, model, sales
#
#   Collection activity (requests, queried models, results, errors)
#   is recorded in a log file:
#     logs/collect.logs
#
#   The log should be human-readable and must include:
#     - The date and time of each request
#     - The queried models
#     - The retrieved sales data
#     - Any possible errors
# ==============================================================================