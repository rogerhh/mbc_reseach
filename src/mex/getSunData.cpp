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
        throw std::runtime_error("Usage: getSunData('start_time', 'end_time', lat, lon)\n" \
                                 "Dates should be in the form mm/dd/yy\n");
    }

    std::tm start_tm, end_tm;
    char cstr[2048];
    if(mxGetString(prhs[0], cstr, 2048))
    {
        throw std::runtime_error("Invalid start date. Not a string");
    }
    start_tm = read_tm_format(std::string(cstr) + "-00:00:00", 0);

    if(mxGetString(prhs[1], cstr, 2048))
    {
        throw std::runtime_error("Invalid end date. Not a string");
    }
    end_tm = read_tm_format(std::string(cstr) + "-00:00:00", 0);

    long double latitude = mxGetScalar(prhs[2]), longitude = mxGetScalar(prhs[3]);

    std::vector<SunriseSunsetData> v;
    while(start_tm <= end_tm)
    {
        SunriseSunsetData temp = get_sunrise_sunset_time(tm_to_string(start_tm).substr(0, 8),
                                                         latitude,
                                                         longitude);
        std::cout << "debug: temp" << temp.sunrise_time << "\n";
        v.emplace_back(temp);
        start_tm.tm_mday++;
    }

    // use mxCreateStructMatrix to create a 1*n array of SunriseSunsetData's

    mxArray* struct_arr = mxCreateStructMatrix(1, v.size(),
                                               SunriseSunsetData::SIZE_OF_FIELD_NAMES,
                                               SunriseSunsetData::FIELD_NAMES);
    for(int i = 0; i < v.size(); i++)
    {
        mxArray* mx_ptr = mxCreateDoubleScalar(v[i].sunrise_time);
        std::cout << "debug: " << v[i].sunrise_time << "\n";
        mxSetFieldByNumber(struct_arr, i, 0, mx_ptr);
        mx_ptr = mxCreateDoubleScalar(v[i].sunset_time);
        mxSetFieldByNumber(struct_arr, i, 1, mx_ptr);
    }

    plhs[0] = struct_arr;

    return;
}
