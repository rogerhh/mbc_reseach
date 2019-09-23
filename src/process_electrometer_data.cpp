#include <iostream>
#include <fstream>
#include <cmath>

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
    if(argc != 4) {
        cout << "Usage: ./process electrometer_data.exe <input file> <start time: hh:mm:ss.ms> <end time: hh:mm:ss.ms>\n";
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
    double start_data;

    end_str = read_delim(res, end_str, ':');
    hr = atof(res);
    end_str = read_delim(res, end_str, ':');
    min = atof(res);
    end_str = read_delim(res, end_str, ',');
    sec = atof(res);
    double end_time = hr * 3600 + min * 60 + sec;
    bool end_found = false;
    double end_data;

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

        if(!start_found && time >= start_time && abs(time - start_time) < 1) {
            start_found = true;
            start_time = time;
            src_ptr = read_delim(res, src_ptr, ',');
            start_data = atof(res);
        }
        if(!end_found && time >= end_time && abs(time - end_time) < 1) {
            end_found = true;
            end_time = time;
            src_ptr = read_delim(res, src_ptr, ',');
            end_data = atof(res);
            break;
        }
    }

    if(!start_found) {
        cout << "Error: start time not found\n";
        return 1;
    }
    else if(!end_found) {
        cout << "Error: end time not found\n";
        return 1;
    }
    else {
        cout << "Average dV/dt = " << (end_data - start_data) / (end_time - start_time) << "\n";
    }

    return 0;
}
