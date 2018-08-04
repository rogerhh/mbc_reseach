#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>

using namespace std;

int main(int argc, char** argv)
{
    ifstream ifs;
    for(int i = 1; i < argc; i++)
    {
        ifs.open(string(argv[i]));
        if(!ifs.is_open())
        {
            cout << "Error opening file: " << argv[i] << endl;
            return 0;
        }
        ifs.ignore(256);
        ifs.ignore(256);
        double max = 0;
        string maxTime;
        string time, val, logVal;
        while(getline(ifs, time, ',') &&
              getline(ifs, val, ',') &&
              getline(ifs, logVal))
        {
            if(max < stod(val))
            {
                max = stod(val);
                maxTime = time;
            }
        }
        cout << argv[i] << ": " << maxTime << " " << max << endl;
        ifs.close();
    }
    return 0;
}
