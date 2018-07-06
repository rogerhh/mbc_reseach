#include <iostream>
#include <fstream>
#include <stdexcept>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{

    // read files
    int count = 1;
    try
    {
        read_from_database();
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when reading from database.\n" << e.what() << "\n";
    }

    // write to database
    try
    {
        write_to_database("/home/rogerhh/mbc_research/data/test_database.csv");
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when writing to database.\n" << e.what() << "\n";
    }
    return 0;
}
