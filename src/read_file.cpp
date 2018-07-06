#include <iostream>
#include <fstream>
#include <stdexcept>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{
    if((argc - 1) % 5 != 0)
    {
        cout << "Usage: [file_path] [start_time] [end_time] [longtitude] [latitude]" << endl;
        return 0;
    }

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
    while(count < argc && (count = count + 5))
    {
        string filename = string(argv[1]);
        string start_time = string(argv[2]);
        string end_time = string(argv[3]);
        double longtitude = stod(string(argv[4]));
        double latitude = stod(string(argv[5]));
        try
        {
            add_file(filename, start_time, end_time, longtitude, latitude);
            cout << "Successfully read file " << filename << "\n";
        }
        catch(runtime_error& e)
        {
            cout << "runtime_error when reading file " << filename << "\n" << e.what() << "\n";
        }
    }

    // write to database
    try
    {
        write_to_database();
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when writing to database.\n" << e.what() << "\n";
    }
    return 0;
}
