import sys
import os
scriptDirectory = os.path.dirname(os.path.realpath(__file__))
path = scriptDirectory + '/../build/src/'
#sys.path.insert(0, path)

#import weatherStation as ws
import numpy as np
import subprocess

def getWeatherAndSunData(year, mon, day, lat, lon):
    args = [path + 'weatherStation', str(year), str(mon), str(day), str(lat), str(lon)]
    p = subprocess.Popen(args, stderr=subprocess.PIPE)
    res = p.communicate()
    arr = res[1].decode("utf-8").split(",")
    new_arr = []
    for data_str in arr:
        new_arr.append(float(data_str))
    length = new_arr[0]
    weather_arr = []
    for i in range(1, len(new_arr) - 2):
        weather_arr.append(new_arr[i])
    sun_arr = [new_arr[len(new_arr) - 2], new_arr[len(new_arr) - 1]]

    print([length, np.array(weather_arr), np.array(sun_arr)])
    return [length, np.array(weather_arr), np.array(sun_arr)]

    

    #ws_data = ws.getWeatherData(year, mon, day, lat, lon)
    # [arg0 = num of data points in arg1, arg1 = [timestamp, temp, pres], arg2 = [sunrise timestamp, sunset timestamp]]
    return 0
    # return [ws_data[0], np.array(ws_data[1]), np.array(ws_data[2])]

getWeatherAndSunData(2019, 5, 4, 38, -75)
