#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>

using namespace std;

// updates src to after delim
char* read_delim(char* res, char* src, char delim) {
    while(1) {
        if(*src == delim || *src == '\0') {
            *res = '\0';
            src++;
            break;
        }
        *res = *src;
        src++;
        res++;
    }
    return src;
}

int main(int argc, char** argv) {
    if(argc != 6) {
        cout << "Usage: ./process electrometer_data.exe <mode> <input file> <start time: hh:mm:ss.ms> <end time: hh:mm:ss.ms> <shortest period>\n";
        return 1;
    }
    ifstream fin(argv[1]);
    if(!fin.is_open()) {
        cout << "Error opening file: " << argv[1] << "\n";
        return 1;
    }

    char res[64], src[64];
    char* start_str = argv[2];
    char* end_str = argv[3];
    double hr, min, sec;
    start_str = read_delim(res, start_str, ':');
    hr = atof(res);
    start_str = read_delim(res, start_str, ':');
    min = atof(res);
    start_str = read_delim(res, start_str, '\0');
    sec = atof(res);
    double start_time = hr * 3600 + min * 60 + sec;
    bool start_found = false;
    // double start_data;

    end_str = read_delim(res, end_str, ':');
    hr = atof(res);
    end_str = read_delim(res, end_str, ':');
    min = atof(res);
    end_str = read_delim(res, end_str, ',');
    sec = atof(res);
    double end_time = hr * 3600 + min * 60 + sec;
    bool end_found = false;
    // double end_data;

    int shortest_period = atoi(argv[4]);
    vector<pair<double, double>> v;
    vector<string> str_v;

    if(start_time >= end_time) {
        cout << "Error: start time must be less than end time\n";
        return 1;
    }

    // ignore the first 2 lines
    fin.ignore(1000, '\n');
    fin.ignore(1000, '\n');

    while(fin.getline(src, 64, '\n')) {
        char* src_ptr = src;
        src_ptr = read_delim(res, src_ptr, ',');
        src_ptr = read_delim(res, src_ptr, ':');
        hr = atoi(res);
        src_ptr = read_delim(res, src_ptr, ':');
        min = atoi(res);
        src_ptr = read_delim(res, src_ptr, ',');
        sec = atof(res);
        double time = hr * 3600 + min * 60 + sec;

        if(!start_found && time >= start_time && abs(time - start_time) < 0.5) {
            start_found = true;
        }

        if(start_found) {
            src_ptr = read_delim(res, src_ptr, '\0');
            v.push_back({time, atof(res)});

            char* time_ptr = src;
            time_ptr = read_delim(res, time_ptr, ',');
            time_ptr = read_delim(res, time_ptr, ',');

            str_v.push_back(string(res));
        }

        if(!end_found && time >= end_time && abs(time - end_time) < 0.5) {
            end_found = true;
            break;
        }

    }

    ofstream fout("out.csv");

    if(!start_found) {
        cout << "Error: start time not found\n";
        return 1;
    }
    else if(!end_found) {
        cout << "Error: end time not found\n";
        return 1;
    }
    else {
        int mode = (string(argv[5]) == "SPECIFIC_POINTS")? 0 : 1;
        if(mode == 1) {
            double slope = 0, v1 = 0, v2 = 0;
            string t1, t2;
            for(int i = 0; i < v.size() - 1; i++) {
                if(v[i].second - v[i + 1].second > 2) { continue; }
                t1 = str_v[i];
                v1 = v[i].second;
                double min_v = 100;
                int index = 0;

                for(int j = i + shortest_period; j < v.size(); j++) {
                    if(v[j].second < min_v) {
                        min_v = v[j].second;
                        index = j;
                    }
                }
                slope = (min_v - v1) / (v[index].first - v[i].first);
                t2 = str_v[index];
                v2 = min_v;
                break;
            }
            cout << "Minimum slope calculated: " << slope << "\nBetween " 
                << "t = " << t1 << " and t = " << t2 << "\nFrom "
                << "v = " << v1 << " to v = " << v2 << "\n";
            fout << t1 << "," << v1 << "," << t2 << "," << v2 << "," << slope << "\n";
        }
        else {
            double slope, v1 = v.front().second, v2 = v.back().second;
            string t1 = str_v.front(), t2 = str_v.back();
            slope = (v2 - v1) / (v.front().second - v.front().second);
            cout << "Slope calculated: " << slope << "\nBetween "
                 << "t = " << t1 << " and t = " << t2 << "\nFrom "
                 << "v = " << v1 << " to v = " << v2 << "\n";
            fout << t1 << "," << v1 << "," << t2 << "," << v2 << "," << slope << "\n";
        }
    }

    return 0;
}
