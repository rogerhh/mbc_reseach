#include <iostream>
#include <string.h>
#include <cstring>
#include <locale>

#include "mex.h"
#include "matrix.h"

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

// makes a constraint statement from given parameters
// Usage (in matlab): constraint = makeConstraint('variable name', 'operator', value)
void mexFunction(int nlhs, mxArray* plhs[], const int nrhs, const mxArray* prhs[])
{
    // check number of arguments
    if(nrhs > 3)
    {
        std::cout << "Too many arguments. Usage: makeConstraint('variable name', 'operator', value)\n";
        return;
    }
    else if(nrhs < 3)
    {
        std::cout << "Too few arguments. Usage: makeConstraint('variable name', 'operator', value)\n";
        return;
    }

    char cstr[64];
    std::string var_name, op, val, strout;
    
    // checks if first argument is a string
    if(mxGetString(prhs[0], cstr, 64))
    {
        std::cout << "First argument invalid.\n";
        return;
    }

    // checks if variable name is valid 
    // and converts var_name to appropriate string
    stringtoupper(cstr);
    var_name = std::string(cstr);
    if(var_name.find("TIME") != std::string::npos || 
       var_name.find("SECOND") != std::string::npos)
    {
        var_name = "SECONDS_AFTER_EPOCH";
    }
    else if(var_name.find("SN") != std::string::npos ||
            var_name.find("SERIAL") != std::string::npos)
    {
        var_name = "SN";
    }
    else if(var_name.find("LAT") != std::string::npos)
    {
        var_name = "LATITUDE";
    }
    else if(var_name.find("LON") != std::string::npos ||
            var_name.find("LNG") != std::string::npos)
    {
        var_name = "LONGITUDE";
    }
    else if(var_name.find("LIGHT") != std::string::npos)
    {
        var_name = "LIGHT_INTENSITY";
    }
    else if(var_name.find("TEMP") != std::string::npos)
    {
        var_name = "TERMPERATURE";
    }
    else
    {
        std::cout << "First argument invalid.\n";
        return;
    }

    // checks if second argument is a string
    mxGetString(prhs[1], cstr, 3);
    if(mxGetString(prhs[1], cstr, 3))
    {
        std::cout << "Second argument invalid.\n";
        return;
    }

    // checks if second argument is valid
    op = std::string(cstr);
    if(op != "==" && op != "<=" && op != ">=")
    {
        std::cout << "Second argument invalid.\n";
        return;
    }

    // checks val type and converts val to string
    std::cout << *mxGetPr(prhs[2]) << "\n";
    std::cout << mxGetClassID(prhs[2]) << "\n";
    std::cout << mxIsUint16(prhs[2]) << "\n";
    if(var_name == "SECONDS_AFTER_EPOCH" || 
       var_name == "SN")
    {
        int64_t* ptr = mxGetInt64s(prhs[2]);
        if(!mxGetInt16s(prhs[2]))
        {
            std::cout << "xThird argument invalid.\n";
            return;
        }
        // val = std::to_string(*ptr);
    }
    else
    {
        double* ptr = mxGetDoubles(prhs[2]);
        if(!ptr)
        {
            std::cout << "Third argument invalid.\n";
            return;
        }
        val = std::to_string(*ptr);
    }
    strout = var_name + " " + op + " " + val;
    std::cout << strout << "\n";
}
