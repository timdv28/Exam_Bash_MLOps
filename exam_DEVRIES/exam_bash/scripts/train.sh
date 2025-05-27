# -----------------------------------------------------------------------------
# This script train.sh runs the Python program src/train.py.
# This program trains a prediction model and saves the final model
# in the model/ directory. The script also logs all execution details
# in the file logs/train.logs.
# -----------------------------------------------------------------------------

YYYYMMDD_HHMM=$(date -u +"%Y%m%d_%H%M")
train_start=$(date -u +"%Y-%m-%d %H:%M")
graphics_card=$1
cards=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")

# Log file
log_file="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/logs/train.logs"
echo "=== Start of training (${train_start}) ===" >> "$log_file"

counter=0
for item in "${cards[@]}"; do
    if [[ "$graphics_card" == "$item" ]]; then
        counter=1
        echo "Graphics card to train on: $item" >> "$log_file"
        break
    fi
done

if [ $counter -eq 0 ]
then
    echo "Error: Input string for the graphics card is incorrect, training aborted" >> "$log_file"
    echo "=== End of model training and evaluation ===" >> "$log_file"
    echo "     " >> "$log_file"
    exit 1
fi

processed_data="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/data/processed/sales_processed_${YYYYMMDD_HHMM}.csv"
model_path="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/model_${YYYYMMDD_HHMM}.pkl"
training_script_path="/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/src/train.py"

# Check for preprocessed data, and if it exists, display the number of rows and columns
if [ -f "${processed_data}" ]
then
    num_rows=$(awk 'END {print NR - 1}' "${processed_data}")
    num_cols=$(awk -F',' 'NR==1 {print NF}' "${processed_data}")
    echo "File with preprocessed sales data found with ${num_rows} rows and ${num_cols} columns" >> "$log_file"
else
    echo "Error: File with preprocessed sales data not found, training process aborted" >> "$log_file"
    echo "=== End of model training and evaluation ===" >> "$log_file"
    echo "     " >> "$log_file"
    exit 1
fi
echo "$graphics_card" >> "$log_file"
results=$(graphics_card="$graphics_card" python3 "$training_script_path")

# Log the training and evaluation results
echo "Model trained and evaluated for graphics card model '$graphics_card':

    Convergence Results
    $results" >> "$log_file"

# End of the script and the log
echo "=== End of model training and evaluation ===" >> "$log_file"
echo "     " >> "$log_file"

#### Possible errors
# Wrong graphic card string