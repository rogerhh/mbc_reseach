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
    if(nrhs != 1)
    {
        throw std::runtime_error("Usage: selectDatapoints(constraint)\n");
    }

    std::string constraint_str, datatype;
    int data_index;
    char cstr[2048];
    if(mxGetString(prhs[0], cstr, 2048))
    {
        throw std::runtime_error("Invalid constraint. Not a string.\n");
    }
    constraint_str = std::string(cstr);

    std::vector<std::vector<DataPoint>> matrix;
    std::vector<int> serial_v;

    select_datapoints(matrix, serial_v, constraint_str);

    // use mxCreateStructMatrix to create a 1*n(i) array of DataPoint's
    // then use mxCreateCellArray to create a m*1 array of struct matrices
    
    mxArray* cellarr = mxCreateCellMatrix(matrix.size(), 1);

    for(int i = 0; i < matrix.size(); i++)
    {
        mxArray* struct_arr = mxCreateStructMatrix(1, matrix[i].size(), 
                                                   DataPoint::SIZE_OF_FIELD_NAMES,
                                                   DataPoint::FIELD_NAMES);
        for(int j = 0; j < matrix[i].size(); j++)
        {
            mxArray* mx_ptr = mxCreateDoubleScalar(matrix[i][j].serial_num);
            mxSetFieldByNumber(struct_arr, j, 0, mx_ptr);
            mx_ptr = mxCreateDoubleScalar(matrix[i][j].time);
            mxSetFieldByNumber(struct_arr, j, 1, mx_ptr);
            for(int k = 0; k < DataPoint::SIZE_OF_FIELD_NAMES - 2; k++)
            {
                mx_ptr = mxCreateDoubleScalar(matrix[i][j].data[k]);
                mxSetFieldByNumber(struct_arr, j, k + 2, mx_ptr);
            }
        }
        mxSetCell(cellarr, i, struct_arr);
    }

    plhs[0] = cellarr;

    return;
}
