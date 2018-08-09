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
    if(nrhs < 2)
    {
        throw std::runtime_error("Too few arguments. Must have at least 2.\n");
    }

    // converts each constraint to string and concatenates them
    std::string res = "(";
    for(int i = 0; i < nrhs; i++)
    {
        char cstr[2048];
        if(mxGetString(prhs[i], cstr, 2048))
        {
            std::stringstream ss;
            ss << "Argument " << i + 1 << " invalid. Not a string.\n";
            throw std::runtime_error(ss.str());
        }
        res = res + std::string(cstr);

        if(i != nrhs - 1)
        {
            res = res + " AND ";
        }
    }
    res = res + ")";

    plhs[0] = mxCreateString(res.c_str());
    return;
}
