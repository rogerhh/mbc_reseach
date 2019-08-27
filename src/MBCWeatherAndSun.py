import sys
import os
scriptDirectory = os.path.dirname(os.path.realpath(__file__))
path = scriptDirectory + '/../build/src/'
sys.path.insert(0, path)

import weatherStation as ws
import numpy as np

def getWeatherAndSunData(year, mon, day, lat, lon):
    ws_data = ws.getWeatherData(year, mon, day, lat, lon)
    # [arg0 = num of data points in arg1, arg1 = [timestamp, temp, pres], arg2 = [sunrise timestamp, sunset timestamp]]
    return [ws_data[0], np.array(ws_data[1]), np.array(ws_data[2])]
