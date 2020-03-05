#include <iostream>
#include <fstream>
#include <bitset>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char** argv) {
    vector<uint32_t> v;
    bitset<96> bits(0);
    for(int i = 0; i < 3; i++) {
        cout << 0 << endl;
        cin >> v[i];
        // bits <<= 32;
        // bits |= bitset<96>(v[i]);
    }
    cout << 1 << endl;
    bool temp_or_light = (v[2] >> 15) & 1;
    uint8_t packet_num = (v[2] >> 12) & 0x7;
    uint8_t chip_id = (v[2] >> 8) & 0xF;
    uint32_t xo_final_time = 0;
    cout << temp_or_light << " " << packet_num << " " << chip_id << endl;
    if(temp_or_light == 0) {
        xo_final_time = (v[2] & 0xFF) << 3 | (v[1] >> 29 & 0x7);
        cout << xo_final_time<< endl;
        uint8_t log_temp_plus_1 = 1;
        do {
            bits &= ((((uint64_t) 1) << 57) - 1);
            log_temp_plus_1 = bits.to_ullong() & 0b11111;
            cout << log_temp_plus_1 << endl;
            bits = bits >> 5;
        } while(log_temp_plus_1 != 0);
    }

}
