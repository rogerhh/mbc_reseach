#include <iostream>
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <string.h>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{
    if(argc != 3)
    {
        cout << "Usage: [path to csv file] [path to sql database]\n";
        return 0;
    }

    // read from csv file
    try
    {
        string csv_file_path = string(argv[1]);
        read_from_database(csv_file_path);
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when reading from database.\n" << e.what() << "\n";
    }

    try
    {
        string sql_file_path = string(argv[2]);
        dump_to_database(sql_file_path);
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when writing to sql database.\n" << e.what() << "\n";
    }
    return 0;
}
