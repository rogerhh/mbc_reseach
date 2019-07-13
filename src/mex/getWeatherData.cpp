#include <iostream>
#include <sstream>
#include <string.h>
#include <cstring>
#include <locale>
#include <stdexcept>
#include <algorithm>

#include "../MBCFunctions.hpp"
#include "mex.h"
#include "matrix.h"

using namespace MBC;

void mexFunction(int nlhs, mxArray* plhs[], const int nrhs, const mxArray* prhs[])
{
    if(nrhs != 4)
    {
        throw std::runtime_error("Usage: getWeatherData('start_time', 'end_time', lat, lon)\n" \
                                 "Dates should be in the form mm/dd/yy\n");
    }

    std::string start_time_str, end_time_str;
    char cstr[2048];
    if(mxGetString(prhs[0], cstr, 2048))
    {
        throw std::runtime_error("Invalid start date. Not a string");
    }
    start_time_str = std::string(cstr) + "-00:00:00";

    if(mxGetString(prhs[1], cstr, 2048))
    {
        throw std::runtime_error("Invalid end date. Not a string");
    }
    end_time_str = std::string(cstr) + "-00:00:00";

    long double latitude = mxGetScalar(prhs[2]), longitude = mxGetScalar(prhs[3]);

    std::vector<WeatherData> v;
    get_weather_data(v, latitude, longitude, start_time_str, end_time_str);

    // use mxCreateStructMatrix to create a 1*n array of WeatherData's
    mxArray* struct_arr = mxCreateStructMatrix(1, v.size(),
                                               WeatherData::SIZE_OF_FIELD_NAMES,
                                               WeatherData::FIELD_NAMES);
    for(int i = 0; i < v.size(); i++)
    {
        mxArray* mx_ptr;
        mx_ptr = mxCreateDoubleScalar(v[i].time);
        mxSetFieldByNumber(struct_arr, i, 0, mx_ptr);
        for(int j = 0; j < WeatherData::SIZE_OF_DATA_FIELDS; j++)
        {
            mx_ptr = mxCreateDoubleScalar(v[i].data[j]);
            mxSetFieldByNumber(struct_arr, i, j + 1, mx_ptr);
        }
    }

    plhs[0] = struct_arr;

    return;
}
