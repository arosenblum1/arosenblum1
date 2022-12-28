'''
A second draft of the tasks done in 
Exploration.py, coded top-down and 
expanded upon.
'''
import pandas as pd
import numpy as np
import datetime


class FarmAnalysis():
    '''
    Main analysis function. Performs time-series analysis on experimental data.
    '''
    
    def __init__(self, file, startdate):
        self.file = file
        self.startdate = startdate
        self.data = self.tidyData()    
    
    def tidyData(self):
        # read raw data to dict of dataframe objects
        raw_data = pd.read_excel(self.file, sheet_name=None, header=None)        
        # parse b/w dfs and combine 
        temps = raw_data['ESP32'].iloc[:,0].str.split('->', expand=True)
        arduino = raw_data['Arduino'].iloc[:,0].str.split('->', expand=True)        
        data = pd.concat([temps, arduino])
        # parse raw data row-by-row
        data.columns = 'Time', 'Reading'
        data = data.apply(self.process_row, axis=1, result_type='expand')
        data.columns = 'Time', 'Measurement', 'Value'
        # remove unwanted rows
        data = data[data.Measurement != 'Received Chars']
        data = data[data.Measurement != 'CMD']
        data = data[data.Measurement != 'Channel']
        data = data[data.Value != '']
        data.index = range(len(data))
        # recast to proper dtypes and re-interpret timestamp
        data.Time = data.Time.astype(np.datetime64)
        data.Value = data.Value.astype(float)
        data = data.apply(self.process_timestamp, axis=1)
        # pivot so sensors are columns
        data = data.pivot_table(columns='Measurement', index='Time', 
                            values='Value', aggfunc=sum)

        # forward fill all NaNs except the Dosing column
        data.loc[:, data.columns!='Dosing'
                 ] = data.loc[:, data.columns!='Dosing'].fillna(method='ffill')
        
        return data
    
    def process_row(self, row):
        '''
        Function for use with pd.apply(). Parses sensor outputs into 
        Measurement and Value. Also rounds time to nearest tenth of
        a second.
        '''
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
        
        
        time = row.Time[:-3]
        new_row = [time, measurement, value]
        return new_row

    def process_timestamp(self, row):
        '''
        Function for use with pd.apply().
        Specific to data collected on 12/10/2022; target rewrite to make 
        more generalized.
        '''
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




file = 'C:\\Users\\Alex\\Projects\\Rosies_Farm\\pH Dose Up Experiment.xls'
startdate = '12/10/2022'
x = FarmAnalysis(file, startdate)