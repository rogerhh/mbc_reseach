#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>
#include <cmath>

using namespace std;

int main(int argc, char** argv)
{
    if(argc != 4)
    {
        cout << "Usage: [file1] [file2] [out file]" << endl;
        return 0;
    }
    ifstream ifs1, ifs2;
    ifs1.open(string(argv[1]));
    ifs2.open(string(argv[2]));
    if(!ifs1.is_open())
    {
        cout << "Error opening file: " << argv[1] << endl;
        return 0;
    }
    if(!ifs2.is_open())
    {
        cout << "Error opening file: " << argv[2] << endl;
        return 0;
    }
    string time1, time2, val1, val2, logVal1, logVal2;
    string out_filename = string(argv[3]);
    ofstream ofs(out_filename);
    if(!ofs.is_open())
    {
        cout << "Error opening file: " << out_filename << endl;
        return 0;
    }
    ifs1.ignore(256);
    ifs1.ignore(256);
    ifs2.ignore(256);
    ifs2.ignore(256);
    while(getline(ifs1, time1, ',') &&
          getline(ifs1, val1, ',') &&
          getline(ifs1, logVal1) &&
          getline(ifs2, time2, ',') &&
          getline(ifs2, val2, ',') &&
          getline(ifs2, logVal2))
    {
        ofs << time1 << ", " << stod(val1) - stod(val2) << endl;
    }
    return 0;
}
