#include <iostream>
#include <sstream>
#include <string.h>
#include <cstring>
#include <locale>
#include <stdexcept>

#include "mex.h"
#include "matrix.h"

void mexFunction(int nlhs, mxArray* plhs[], const int nrhs, const mxArray* prhs[])
{
    if(nrhs != 1)
    {
        throw std::runtime_error("Must have only one argument.\n");
    }

    std::string res = "(NOT ";
    char cstr[2048];
    if(mxGetString(prhs[0], cstr, 2048))
    {
        throw std::runtime_error("Invalid argument. Not a string");
    }
    res = res + std::string(cstr) + " )";

    plhs[0] = mxCreateString(res.c_str());
    return;
}
