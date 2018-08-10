#include <iostream>
#include <string.h>
#include <cstring>
#include <locale>
#include <stdexcept>

#include "mex.h"
#include "matrix.h"
#include "../MBCFunctions.hpp"

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

// makes a constraint statement from given parameters
// Usage (in matlab): constraint = makeConstraint('variable name', 'operator', value)
void mexFunction(int nlhs, mxArray* plhs[], const int nrhs, const mxArray* prhs[])
{
    // check number of arguments
    if(nrhs > 3)
    {
        throw std::runtime_error("Too many arguments. Usage: makeConstraint('variable name', 'operator', value)\n");
    }
    else if(nrhs < 3)
    {
        throw std::runtime_error("Too few arguments. Usage: makeConstraint('variable name', 'operator', value)\n");
    }

    char cstr[64];
    std::string var_name, op, val, strout;
    
    // checks if first argument is a string
    if(mxGetString(prhs[0], cstr, 64))
    {
        throw std::runtime_error("First argument invalid. Not a string\n");
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
        throw std::runtime_error("First argument invalid. Field name not supported\n");
    }

    // checks if second argument is a string
    mxGetString(prhs[1], cstr, 3);
    if(mxGetString(prhs[1], cstr, 3))
    {
        throw std::runtime_error("Second argument invalid. Not a string\n");
    }

    // checks if second argument is valid
    op = std::string(cstr);
    if(op != "==" && op != "!=" && op != "<=" && op != ">=" && op != "<" && op != ">")
    {
        throw std::runtime_error("Second argument invalid. Comparison operator not supported\n");
    }

    // checks val type and converts val to string
    if(var_name == "SECONDS_AFTER_EPOCH")
    {
        // checks if third argument is string
        // if not, read number
        if(mxGetString(prhs[2], cstr, 64))
        {
            int64_t i = mxGetScalar(prhs[2]);
            val = std::to_string(i);
        }
        else
        {
            val = std::to_string(read_time_format(std::string(cstr), 0));
        }
    }
    else if(var_name == "SN")
    {
        int64_t i = mxGetScalar(prhs[2]);
        val = std::to_string(i);
    }
    else
    {
        long double d = mxGetScalar(prhs[2]);
        val = std::to_string(d);
    }
    strout = var_name + " " + op + " " + val;
    plhs[0] = mxCreateString(strout.c_str());
    return;
}
