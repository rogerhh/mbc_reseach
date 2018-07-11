#include <iostream>
#include <fstream>
#include <stdexcept>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{
    if(argc != 1)
    {
        cout << "Usage: [path to new files list]\n";
        return 0;
    }

    // read from database
    try
    {
        read_from_database();
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when reading from database.\n" << e.what() << "\n";
    }

    char line_cstr[256];

    while(fin.getline(line, 256))
    {
        string line = string(line_cstr);
        string path, longitude, latitude, start_time, end_time;
        int pos = 0, lastpos;
        pos = line.find(";");
        path = line.substr(0, pos);
        lastpos = pos + 1;
        pos = line.find(";", lastpos);
        longitude = line.substr(lastpos, pos - lastpos);
        lastpos = pos + 1;
        pos = line.find(";", lastpos);
        latitude = line.substr(lastpos, pos - lastpos);
        lastpos = pos + 1;
        if(lastpos != line.length())
        {
            pos = line.find(";", lastpos);
            start_time = line.substr(lastpos, pos - lastpos);
            lastpos = pos + 1;
            pos = line.find(";", lastpos);
            end_time = line.substr(lastpos, pos - lastpos);
        }
        // fix input format
    }


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
