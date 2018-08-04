#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <string>

using namespace std;

void single_file_scalar(int argc, char** argv);

void multi_file_scalar(int argc, char** argv);

int main(int argc, char** argv)
{
    if(argc < 2)
    {
        cout << "Usage: [option 0-1] ...";
    }
    int option = stoi(string(argv[1]));
    if(option == 0)
    {
        single_file_scalar(argc, argv);
        return 0;
    }
    else if(option == 1)
    {
        multi_file_scalar(argc, argv);
        return 0;
    }
    return 0;
}

void single_file_scalar(int argc, char** argv)
{
    if(argc != 5)
    {
        cout << "single file scalar modification\n" << "Usage: [option 0] [in file] [out file] [scale]" << endl;
        return;
    }
    ifstream ifs;
    ofstream ofs;
    vector<double> data;
    ifs.open(string(argv[2]));
    if(!ifs.is_open())
    {
        cout << "Error opening file: " << argv[2] << endl;
        return;
    }
    ofs.open(string(argv[2]));
    if(!ofs.is_open())
    {
        cout << "Error opening file: " << argv[3] << endl;
        return;
    }
    string str;
    getline(ifs, str);
    ofs << str << endl;
    getline(ifs, str);
    ofs << str << endl;
    string time, val, logVal;
    double scalar = stod(string(argv[4]));
    while(getline(ifs, time, ',') &&
          getline(ifs, val, ',') &&
          getline(ifs, logVal)) 
    {
        ofs << stod(time) << ", " << stod(val) * scalar << ", " << log10(stod(val) * scalar + 1) << endl;
    }
    ifs.close();
}

void multi_file_scalar(int argc, char** argv)
{
    if(argc < 4)
    {
        cout << "multiple files scalar modification\n" << "Usage: [option 1] [standard max] [in_file] ...";
        return;
    }
    ifstream ifs;
    ofstream ofs;
    for(int i = 3; i < argc; i++)
    {
        ifs.open(string(argv[i]));
        if(!ifs.is_open())
        {
            cout << "Error opening file: " << argv[i] << endl;
            return;
        }

        string out_file = string(argv[i]);
        out_file = out_file.substr(0, out_file.length() - 4) + "_normalized.csv";
        out_file = out_file.substr(0, 10) + "/scalar_normalized_data" + out_file.substr(10);
        ofs.open(out_file);
        if(!ofs.is_open())
        {
            cout << "Error opening file: " << out_file << endl;
            return;
        }

        string title;
        getline(ifs, title);
        ofs << title << endl;
        getline(ifs, title);
        ofs << title << endl;

        double max = 0, standard_max = stod(string(argv[2]));
        string time, val, logVal;
        vector<double> time_data, val_data, logVal_data;
        while(getline(ifs, time, ',') &&
              getline(ifs, val, ',') &&
              getline(ifs, logVal))
        {
            time_data.push_back(stod(time));
            val_data.push_back(stod(val));
            logVal_data.push_back(stod(logVal));
            if(max < stod(val))
            {
                max = stod(val);
            }
        }
        for(int i = 0; i < time_data.size(); i++)
        {
           ofs << time_data[i] << "," << val_data[i] * standard_max / max << "," << logVal_data[i] << endl; // does not scale logVal
        }

        cout << "Writing to " << out_file << "\tMax: " << max << endl;
        ifs.close();
        ofs.close();
    }
}
