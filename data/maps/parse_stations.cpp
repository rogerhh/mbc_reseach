#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{
    ifstream fin("./stations.csv");
    if(!fin.is_open())
    {
        cout << "Error opening file\n";
        return 0;
    }
    char title_cstr[256];
    fin.getline(title_cstr, 256);
    int line_counter = 2000, file_counter = 0;
    char cstr[256];
    ofstream fout;
    while(fin.getline(cstr,256))
    {
        if(line_counter == 2000)
        {
            fout.close();
            string outfilename = "./US_stations" + to_string(file_counter) + ".csv";
            fout.open(outfilename);
            if(!fout.is_open())
            {
                cout << "Error opening file: " << outfilename << "\n";
            }
            fout << title_cstr << "\n";
            file_counter++;
            line_counter = 0;
        }
        string str = string(cstr);
        if(str.substr(str.length() - 2, 2) == "US")
        {
            fout << str << "\n";
            line_counter++;
        }
    }
    return 0;
}
