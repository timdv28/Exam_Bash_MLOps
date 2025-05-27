"""
-------------------------------------------------------------------------------
This script runs the training of an XGBoost model to predict graphics card sales 
from the preprocessed data.

1. It starts by searching for the latest preprocessed CSV file in the 'data/processed/' directory.
2. If a standard model (model.pkl) does not exist, it loads the data, splits it into training and test sets, trains a model on this data, evaluates it, and then saves it as 'model/model.pkl'.
3. If a standard model already exists, it trains a new model on the latest data, evaluates it, and saves the model in the 'model/' folder in the format: model_YYYYMMDD_HHMM.pkl.
4. Performance metrics (RMSE, MAE, R²) are displayed and saved in the log file.
5. Any errors are handled and reported in the logs.

The models are saved in the 'model/' folder with the name 'model.pkl' for the standard model and with a timestamp for later versions.
The model metrics are recorded in the script’s log files.
-------------------------------------------------------------------------------
"""
import pandas as pd
import xgboost as xgb
import pickle
import os
from datetime import datetime

from sklearn.metrics import mean_absolute_error as mae
from sklearn.metrics import mean_squared_error as mse
from sklearn.metrics import r2_score as rsq

# Timestamp
YYYYMMDD_HHMM = datetime.now().strftime("%Y%m%d_%H%M")
graphics_card= os.getenv('graphics_card')

model_flag=False

model_path = "/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/model/"

# Create a few features based on the time
def features(df):
    for i in range(df.shape[0]):
        df['step'] = i+1
    return df

# Splitting train and test data
def tt_split(df,graphics_card):
    train_size = int(round(df.shape[0]*0.8))
    train = df.iloc[:train_size][:]
    test = df.iloc[train_size:df.shape[0]][:]

    train = features(train)
    test = features(test)

    feats = ['step']
    target = [str(graphics_card)]

    X_train = train[feats]
    y_train = train[target]
    X_test = test[feats]
    y_test = test[target] 
    return X_train, y_train, X_test, y_test

# from sklearn.model_selection import train_test_split
path_to_file = f"/home/ubuntu/exam_DEVRIES/exam_bash/exam_Bash_MLOps/data/processed/sales_processed_{YYYYMMDD_HHMM}.csv"

# Get the time series file
df = pd.read_csv(path_to_file)

if model_flag==True:
    # Load the existing model
    model_pkl = model_path+"model.pkl"
    with open(model_pkl, 'rb') as file:  
        model_pkl = pickle.load(file)
    
# Make the train test split and the features using tt_split
X_train, y_train, X_test, y_test = tt_split(df,graphics_card)

# Define the XGBoost model
reg = xgb.XGBRegressor(n_estimators=500, early_stopping_rounds=50, learning_rate=0.1)
reg.fit(X_train,y_train,eval_set=[(X_train,y_train), (X_test,y_test)],verbose=False)

# Use the fitted model for a prediction on the test set
y_pred = reg.predict(X_test)

# Export the model using pickle
model_pkl = model_path+"model.pkl"  
with open(model_pkl, 'wb') as file:  
    pickle.dump(model_pkl, file)

# Performance metrics
MAE = mae(y_test,y_pred)
RMSE = mse(y_test,y_pred,squared=False)
R2 = rsq(y_test,y_pred)

#Print the performance metrics to be written into the log file via the bash script
print(f"""    
MAE: {MAE}
RMSE: {RMSE}
R^2: {R2}


""")
    
