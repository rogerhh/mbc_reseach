#include <fstream>
#include <iostream>
#include <regex>
#include <locale>

using namespace std;

int main(int argc, char** argv) {
    if(argc != 4) {
        cout << "Usage: [info_table_path] [raw_file_name] [detail_path]" << endl; 
        return 1;
    }

    string info_table_path = string(argv[1]);
    ofstream fout;
    fout.open(info_table_path, ios::out | ios::app);
    if(!fout.is_open()) {
        cout << "Error opening file: " << info_table_path << endl;
        return 1;
    }
    string raw_file_name = string(argv[2]);
    string detail_path = string(argv[3]);
    ifstream fin(detail_path);
    if(!fin.is_open()) {
        cout << "Error opening file: " << detail_path << endl;
        return 1;
    }

    string s;
    while(fin >> s) {
        if(s == "Latitude:") {
            int a, b, c;
            string d, e, f, g;
            fin >> a >> f >> b >> g >> c >> d >> e;
            fout << raw_file_name << ".csv," << a << "o" << b << "\'" << c << "\"" << e;
        }
        else if(s == "Longitude:") {
            int a, b, c;
            string d, e, f, g;
            fin >> a >> f >> b >> g >> c >> d >> e;
            fout << "," << a << "o" << b << "\'" << c << "\"" << e << endl;
            return 0;
        }
    }
    cout << "Cannot find lon, lat info for " << raw_file_name << endl;
    return 1;

}
