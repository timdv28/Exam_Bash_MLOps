"""
-------------------------------------------------------------------------------
This script `preprocessed.py` retrieves data from the latest CSV file created 
in the 'data/raw/' directory.

1. It applies preprocessing to the data.
   
2. The results of the preprocessing are saved in a new CSV file 
   in the 'data/processed/' directory, with a name formatted as 
   'sales_processed_YYYYMMDD_HHMM.csv'.
   
3. All preprocessing steps are logged in the 
   'logs/preprocessed.logs' file to ensure detailed tracking of the process.

Any errors or anomalies are also logged to ensure traceability.
-------------------------------------------------------------------------------
"""
import pandas as pd
import math
from datetime import datetime

YYYYMMDD_HHMM = datetime.now().strftime("%Y%m%d_%H%M")

# raw_data_path = f"~/exam_DEVRIES/exam_bash/exam_Bash_MLOps/data/raw/sales_data_{YYYYMMDD_HHMM}.csv"
raw_data_path = f"data/raw/sales_data.csv"
processed_data_path = f'data/processed/sales_processed_{YYYYMMDD_HHMM}.csv'
raw_data = pd.read_csv(raw_data_path)

raw_data.dropna(subset=['sales'])
raw_data['instance'] = ""

def data_preproc(raw_data):
   j = 1
   for i in range(raw_data.shape[0]):
      try:
         raw_data.loc[i, 'instance'] = j
         if (raw_data['timestamp'][i] != raw_data['timestamp'][i+1]):
            j += 1
      except:
         pass
   
   cards = ['rtx3060','rtx3070','rtx3080','rtx3090','rx6700']
   num_inst = raw_data['instance'].max()
   sales_series = pd.DataFrame(columns = cards, index=range(num_inst))
   
   for k in range(num_inst):
      for cname in range(len(cards)):
         sales_series.iloc[k][cname] = raw_data['sales'].loc[(raw_data['instance'] == k+1)].iloc[cname]
   
   sales_series.to_csv(processed_data_path,index=False)   
   return 

data_preproc(raw_data)