#include <iostream>
#include <sstream>
#include <string.h>
#include <cstring>
#include <locale>
#include <stdexcept>
#include <algorithm>

#include "../DataPoint.hpp"
#include "../MBCFunctions.hpp"
#include "mex.h"
#include "matrix.h"

using namespace MBC;

// converts input string to upper case
void stringtoupper(char* ptr)
{
    char* str = ptr;
    while(*str != '\0')
    {
        *str = std::toupper(*str);
        str++;
    }
}

void mexFunction(int nlhs, mxArray* plhs[], const int nrhs, const mxArray* prhs[])
{
    std::string constraint_str, datatype;
    int data_index;
    if(nrhs != 2)
    {
        throw std::runtime_error("Usage: selectDatapoints(constraint, field name)\n");
    }

    char cstr[2048];
    if(mxGetString(prhs[0], cstr, 2048))
    {
        throw std::runtime_error("Invalid constraint. Not a string.\n");
    }
    constraint_str = std::string(cstr);

/*
    stringtoupper(cstr);
    datatype = std::string(cstr);
    if(datatype.find("TIME") != std::string::npos || 
       datatype.find("SECOND") != std::string::npos)
    {
        datatype = "SECONDS_AFTER_EPOCH";
    }
    else if(datatype.find("SN") != std::string::npos ||
            datatype.find("SERIAL") != std::string::npos)
    {
        datatype = "SN";
    }
    else if(datatype.find("LAT") != std::string::npos)
    {
        datatype = "LATITUDE";
    }
    else if(datatype.find("LON") != std::string::npos ||
            datatype.find("LNG") != std::string::npos)
    {
        datatype = "LONGITUDE";
    }
    else if(datatype.find("LIGHT") != std::string::npos)
    {
        datatype = "LIGHT_INTENSITY";
    }
    else if(datatype.find("TEMP") != std::string::npos)
    {
        datatype = "TERMPERATURE";
    }
    else
    {
        throw std::runtime_error("Second argument invalid. Field name not supported\n");
    }
*/

    std::vector<std::vector<DataPoint>> matrix;
    std::vector<int> serial_v;

    select_datapoints(matrix, serial_v, constraint_str);

    if(matrix.size() != 0)
    {
        plhs[0] = mxCreateDoubleMatrix(matrix.size(), matrix[0].size(), mxREAL);
        plhs[1] = mxCreateDoubleMatrix(matrix.size(), matrix[0].size(), mxREAL);
        plhs[2] = mxCreateDoubleMatrix(matrix.size(), 1, mxREAL);
        double* indices = mxGetPr(plhs[0]);
        double* time_index = mxGetPr(plhs[1]);
        double* serial_index = mxGetPr(plhs[2]);
        for(int i = 0; i < matrix.size(); i++)
        {
            std::sort(matrix[i].begin(), matrix[i].end(), DataPoint::less());
            for(int j = 0; j < matrix[0].size(); j++)
            {
                indices[i + matrix.size() * j] = matrix[i][j].data[DataPoint::LIGHT_INTENSITY];
                time_index[i + matrix.size() * j] = matrix[i][j].time;
                std::cout << matrix[i][j].serial_num << " " << matrix[i][j].time << " " << matrix[i][j].data[DataPoint::LATITUDE] << " " << matrix[i][j].data[DataPoint::LONGITUDE] << " " << matrix[i][j].data[DataPoint::LIGHT_INTENSITY] << "\n";
            }
            serial_index[i] = serial_v[i];
        }
    }
    else
    {
        std::cout << "No datapoint selected.\n";
    }

    return;
}
