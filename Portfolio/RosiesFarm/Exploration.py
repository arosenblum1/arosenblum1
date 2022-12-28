#%% load dependencies
import pandas as pd
import numpy as np
import datetime

pd.set_option('display.max_rows', 100)

#%% load data
raw_data = pd.read_excel('pH Dose Up Experiment.xls', 
                         sheet_name=None, 
                         header=None)
date = '12/10/2022'

#%% 

# Function to parse row-by-row with df.apply()
def process_row(row):
    measurement, value = row.Reading.split(':', 1)
    measurement = measurement.strip(' <')
    value = value.strip('>')
    
    relay_ids = {'0:0': 'Mix Pump',
                 '0:1': 'Main Pump',
                 '1:0': 'Mixing Fans'}
    
    if measurement == 'Relay':
        relay = relay_ids[value[:3]]
        measurement = relay
        value = value[-1]
        
    elif measurement == 'Dosing':
        value = value.split(':')[1]
    
    
    time = row.Datetime[:-3]
    new_row = [time, measurement, value]
    return new_row


#%% tidy ESP32 data
temps = raw_data['ESP32'].iloc[:,0].str.split('->', expand=True)
temps.columns = 'Datetime', 'Reading'
temps['Date'] = date
temps = temps.apply(process_row, axis=1, result_type='expand')

#%% tidy Arduino data
arduino = raw_data['Arduino'].iloc[:,0].str.split('->', expand=True)
arduino.columns = 'Datetime', 'Reading'
arduino = arduino.apply(process_row, axis=1, result_type='expand')

#%% combine dataframes
df = pd.concat([temps, arduino])
df.columns = 'Time', 'Measurement', 'Value'
df = df[df.Measurement != 'Received Chars']
df = df[df.Measurement != 'CMD']
df = df[df.Measurement != 'Channel']
df = df[df.Value != '']
df.index = range(len(df))

# recast to proper dtypes
df.Time = df.Time.astype(np.datetime64)
df.Value = df.Value.astype(float)


def process_timestamp(row):
    time_i = row.Time
    if time_i.hour != 0:
        day = 10
    else:
        day = 11
    time = datetime.datetime(year = 2022, 
                             month = 12, 
                             day = day, 
                             hour = time_i.hour, 
                             minute = time_i.minute,
                             second = time_i.second,
                             microsecond = time_i.microsecond)
    
    row.Time = time
    return row

df = df.apply(process_timestamp, axis=1)

# pivot so sensors are columns
df = df.pivot_table(columns='Measurement', index='Time', 
                    values='Value', aggfunc=sum)

# forward fill all NaNs except the Dosing column
df.loc[:, df.columns!='Dosing'] = df.loc[:, df.columns!='Dosing'].fillna(method='ffill')
print(df.head(25))


#%% incorporate time-dummy and lag variables - see Kaggle page in bookmarks

#%% Visualizations
import matplotlib.pyplot as plt
from matplotlib.dates import HourLocator, ConciseDateFormatter
plt.rcParams["figure.figsize"] = (20,10)

fig, ax = plt.subplots()
ax.plot(df.index, df['EC'])
ax.xaxis.set_major_formatter(ConciseDateFormatter(HourLocator()))

doses = np.array(df[~df.Dosing.isna() & df.Dosing!=0].index)
plt.vlines(x=doses, ymin=300, ymax=400, colors='red', linewidth=.5)
plt.ylim([320, 380])
plt.show()


