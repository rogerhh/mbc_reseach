#include "read_data.hpp"
#include "Sim.hpp"

#include <string>
#include <iostream>

using namespace std;

int main(int argc, char** argv) {
    string filename = string(argv[1]);
    Sim sim(filename);
    // sim.start_sim(78600, 10000, 22, 96, 29340, 60657, 1577670600, "sample_times.csv");
    
    sim.start_sim(57000, 10000, 16, 24*31, 26504, 71122, 1537127400, "sample_times_1_month.csv");

    // map<time_t, double> data_map = read_file(filename);
    // cout << get_data(data_map, 1576103505) << " " << get_data(data_map, 1576103510) << " " << get_data(data_map, 1576103515) << " " << get_data(data_map, 1576103520) << endl;
}
