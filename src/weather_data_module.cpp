// #include <python3.5/Python.h>
#include "MBCFunctions.hpp"
#include <iostream>
#include <cstring>
#include <vector>

using namespace std;
using namespace MBC;

string convert_tm_to_string(std::tm tm)
{
    std::string yr, mon, day, hr, min, sec;
    int year = tm.tm_year;
    year = (year + 1900) & 100;
    yr = std::to_string(tm.tm_year % 100).length() < 2? "0" + std::to_string(tm.tm_year % 100) : std::to_string(tm.tm_year % 100);
    mon = std::to_string(tm.tm_mon + 1);
    mon = (mon.length() < 2)? "0" + mon : mon;
    day = std::to_string(tm.tm_mday);
    day = (day.length() < 2)? "0" + day : day;
    cout << "hour = " << tm.tm_hour << "\n";
    hr = std::to_string(tm.tm_hour);
    hr = (hr.length() < 2)? "0" + hr : hr;
    min = std::to_string(tm.tm_min);
    min = (min.length() < 2)? "0" + min : min;
    sec = std::to_string(tm.tm_sec);
    sec = (sec.length() < 2)? "0" + sec : sec;
    return mon + "/" + day + "/" + yr + "-" + hr + ":" + min + ":" + sec;
}

string get_date_string(int year, int mon, int day) {
    string yr_str = std::to_string(year % 100).length() < 2? "0" + std::to_string(year % 100) : std::to_string(year % 100);
    string mon_str = to_string(mon);
    mon_str = mon_str.length() < 2? "0" + mon_str : mon_str;
    string day_str = to_string(day);
    day_str = day_str.length() < 2? "0" + day_str : day_str;
    return mon_str + "/" + day_str + "/" + yr_str;
}

/*
static PyObject* weather_station_get_weather_data(PyObject* self, PyObject* args) {
    int year, mon, day;
    double lat, lon;

    if(!PyArg_ParseTuple(args, "iiidd", &year, &mon, &day, &lat, &lon)) return NULL;

    tm t;
    t.tm_year = year - 1900;
    t.tm_mon = mon - 1;
    t.tm_mday = day;
    t.tm_hour = 0;
    t.tm_min = 0;
    t.tm_sec = 0;

    cout << t.tm_year << " " << t.tm_mon << " " << t.tm_mday << "\n";
    reset_tm(&t);
    cout << t.tm_year << " " << t.tm_mon << " " << t.tm_mday << "\n";
    
    string start_time = convert_tm_to_string(t);
    t.tm_hour += 25;
    reset_tm(&t);
    string end_time = convert_tm_to_string(t);

    cout << start_time << " " << end_time << "\n";

    vector<WeatherData> weather_v;
    cout << "getting weather data\n";
    get_weather_data(weather_v, lat, lon, start_time, end_time);
    
    cout << "getting sunrise sunset data\n";
    SunriseSunsetData sun_data = get_sunrise_sunset_time(get_date_string(year, mon, day), lat, lon);

    PyObject* weather_tuple = PyTuple_New(weather_v.size());
    int count = 0;
    for(const auto& weather : weather_v) {
        PyObject* data_ptr = Py_BuildValue("[Kdd]", weather.time, weather.data[WeatherData::TEMPERATURE], weather.data[WeatherData::PRESSURE]);
        PyTuple_SetItem(weather_tuple, count++, data_ptr);
    }
    PyObject* sun_tuple = Py_BuildValue("[ll]", sun_data.sunrise_time, sun_data.sunset_time);
    PyObject* return_data = PyTuple_New(3);
    PyTuple_SetItem(return_data, 0, Py_BuildValue("i", weather_v.size()));
    PyTuple_SetItem(return_data, 1, weather_tuple);
    PyTuple_SetItem(return_data, 2, sun_tuple);

    return return_data;
}

static PyMethodDef WeatherStationMethods[] = {
    {"getWeatherData", weather_station_get_weather_data,
     METH_VARARGS, "Get weather and sunrise sunset data."},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef weatherStationmodule {
    PyModuleDef_HEAD_INIT,
    "weatherStation",
    NULL,
    -1,
    WeatherStationMethods
};

// Changed in Python3.5
PyMODINIT_FUNC PyInit_weatherStation(void) {
    return PyModule_Create(&weatherStationmodule);
}
*/

int main(int argc, char** argv) {
    int year = atoi(argv[1]), mon = atoi(argv[2]), day = atoi(argv[3]);
    double lat = stold(argv[4]), lon = stold(argv[5]);

    // if(!PyArg_ParseTuple(args, "iiidd", &year, &mon, &day, &lat, &lon)) return NULL;

    tm t;
    t.tm_year = year - 1900;
    t.tm_mon = mon - 1;
    t.tm_mday = day;
    t.tm_hour = 0;
    t.tm_min = 0;
    t.tm_sec = 0;
    t.tm_isdst = -1;

    cout << t.tm_year << " " << t.tm_mon << " " << t.tm_mday << " " << t.tm_hour << " " << t.tm_min << " " << t.tm_sec << "\n";
    reset_tm(&t);
    cout << t.tm_year << " " << t.tm_mon << " " << t.tm_mday << " " << t.tm_hour << " " << t.tm_min << " " << t.tm_sec << "\n";
    
    string start_time = convert_tm_to_string(t);
    t.tm_hour += 25;
    reset_tm(&t);
    string end_time = convert_tm_to_string(t);

    cout << start_time << " " << end_time << "\n";

    vector<WeatherData> weather_v;
    cout << "getting weather data\n";
    get_weather_data(weather_v, lat, lon, start_time, end_time);
    
    cout << "getting sunrise sunset data\n";
    SunriseSunsetData sun_data = get_sunrise_sunset_time(get_date_string(year, mon, day), lat, lon);

    // PyObject* weather_tuple = PyTuple_New(weather_v.size());
    cerr << weather_v.size() << ",";
    int count = 0;
    for(const auto& weather : weather_v) {
        // PyObject* data_ptr = Py_BuildValue("[Kdd]", weather.time, weather.data[WeatherData::TEMPERATURE], weather.data[WeatherData::PRESSURE]);
        // PyTuple_SetItem(weather_tuple, count++, data_ptr);
        cerr << weather.time << "," << weather.data[WeatherData::TEMPERATURE] << "," << weather.data[WeatherData::PRESSURE] << ",";
        count++;
    }
    cerr << sun_data.sunrise_time << "," << sun_data.sunset_time;
    
    /*
    PyObject* sun_tuple = Py_BuildValue("[ll]", sun_data.sunrise_time, sun_data.sunset_time);
    PyObject* return_data = PyTuple_New(3);
    PyTuple_SetItem(return_data, 0, Py_BuildValue("i", weather_v.size()));
    PyTuple_SetItem(return_data, 1, weather_tuple);
    PyTuple_SetItem(return_data, 2, sun_tuple);
    */

    return 0;
    // return return_data;
}
