#include <iostream>
#include <fstream>
#include <sstream>
#include <bitset>
#include <string>
#include <vector>
#include <unordered_map>
#include <cmath>
#include <utility>
#include <stdexcept>
#include <map>

using namespace std;

void print_v(vector<uint32_t>& v) {
    for(int i = v.size() - 1; i >= 0; i--) {
        cout << bitset<32>(v[i]) << " ";
    }
    cout << endl;
}

uint32_t extend(uint16_t val, uint8_t len) {
    bitset<32> d(val);
    bool res = d.test(len - 1);
    for(int i = len; i < 32; i++) {
        d[i] = res;
    }

    return (uint32_t) d.to_ulong();
}

void shift_left(vector<uint32_t>& v, uint8_t shift) {
    for(int i = v.size() - 1; i >= 0; i--) {
        v[i] = v[i] << shift;
        if(i > 0) {
            v[i] |= v[i - 1] >> (32 - shift);
        }
    }
}

void shift_right(vector<uint32_t>& v, uint8_t shift) {
    for(int i = 0; i < v.size(); i++) {
        v[i] = v[i] >> shift;
        if(i < v.size() - 1) {
            v[i] |= (v[i + 1] & ((1 << shift) - 1));
        }
    }
}

uint8_t get_val(char c) {
    switch(c) {
        case '1':
            return 1;
        case '2':
            return 2;
        case '3':
            return 3;
        case '4':
            return 4;
        case '5':
            return 5;
        case '6':
            return 6;
        case '7':
            return 7;
        case '8':
            return 8;
        case '9':
            return 9;
        case 'A':
        case 'a':
            return 10;
        case 'B':
        case 'b':
            return 11;
        case 'C':
        case 'c':
            return 12;
        case 'D':
        case 'd':
            return 13;
        case 'E':
        case 'e':
            return 14;
        case 'F':
        case 'f':
            return 15;
        default:
            return 0;
    } 
}

#define XO_MAX_DAY_TIME_IN_SEC 86400
#define XO_TO_SEC_SHIFT 15
#define TEMP_RES 7
uint32_t LNT_INTERVAL[4] = {60, 120, 480, 1920};

uint32_t last_full_time = 0;
uint32_t last_hint = 0;

uint32_t find_full_timestamp(uint16_t xo_day_time_in_min, uint32_t hint) {
    uint32_t full_time = last_full_time == 0? hint : last_full_time;
    hint = last_full_time == 0? hint : last_hint;
    while((hint >> 6) > (xo_day_time_in_min + 1) || (hint >> 6) < (xo_day_time_in_min - 1)) {
        cout << hex << (hint >> 6) << " " << xo_day_time_in_min << endl;
        hint += LNT_INTERVAL[0];
        full_time += LNT_INTERVAL[0];
        if(hint >= XO_MAX_DAY_TIME_IN_SEC) {
            hint -= XO_MAX_DAY_TIME_IN_SEC;
        }
    }
    last_full_time = full_time;
    last_hint = hint;
    cout << hint << endl;
    return full_time;
}

class temp_unit {
    bitset<80> data;
    int size = 0;

public:
    temp_unit(vector<uint32_t>& v) {
        data |= (v[1] & 0x1FFFFFFF);
        data <<= 32;
        data |= v[0];
        size = 59;
    }

    uint16_t read(uint8_t len) {
        if(len > size) {
            throw runtime_error("Error reading len size " + to_string(len));
        }
        uint16_t res = (uint16_t) (data & bitset<80>((1 << len) - 1)).to_ullong();
        data >>= len;
        size -= len;
        return res;
    }

};

class light_unit {
    bitset<160> data;
    int size = 0;

public:
    light_unit() {}

    light_unit(vector<uint32_t> v0, vector<uint32_t> v1, int size_in) {
        data = bitset<160>(0);
        data |= bitset<160>(v0[2] & 0xFF);
        data <<= 32;
        data |= bitset<160>(v0[1]);
        data <<= 32;
        data |= bitset<160>(v0[0]);
        data <<= 8;
        data |= bitset<160>(v1[2] & 0xFF);
        data <<= 32;
        data |= bitset<160>(v1[1]);
        data <<= 32;
        data |= bitset<160>(v1[0]);

        size = size_in;
        cout << data << endl;
    }

    uint16_t read(uint16_t len) {
        if(len > size) {
            throw runtime_error("Error reading len size " + to_string(len));
        }
        uint16_t res = (uint16_t) (data & bitset<160>((((uint16_t) 1) << len) - 1)).to_ulong();
        data >>= len;
        size -= len;
        return res;
    }


};

int main(int argc, char** argv) {
    int counter = 0;
    int start_hour;
    unordered_map<uint16_t, pair<uint16_t, vector<uint32_t>>> even_light_packets;
    char c;
    vector<char> buf;
    cout << "Enter start time in hour: " << endl;
    cin >> start_hour;
    uint32_t start_hour_in_sec = (start_hour * 3600);
    cout << "Start time in sec: " << hex << start_hour_in_sec << endl;
    ofstream light_fout(argv[1]);
    ofstream temp_fout(argv[2]);
    map<int, int> light_data_map; 
    map<int, int> temp_data_map; 

    bool temp_init = false;

    while(cin >> c) {
        buf.push_back(c);

        if(buf.size() == 24) {

            vector<uint32_t> v(3, 0);
            for(auto c : buf) {
                shift_left(v, 4);
                v[0] |= get_val(c);
            }
            buf.clear();

            v[2] &= 0x0000FFFF;
            print_v(v);

            if((v[0] & 0x7FF) == 0x7FF) {
                // is beacon
            }
            else {
                uint16_t temp_or_light = (v[2] >> 15) & 1;
                uint16_t packet_num = (v[2] >> 12) & 0x7;
                uint16_t chip_id = (v[2] >> 8) & 0xF;
                uint16_t xo_day_time_in_min;
                uint32_t xo_day_time_in_sec;
                if(!temp_or_light) {
                    // re-initialize hint
                    if(!temp_init) {
                        temp_init = true;
                        last_full_time = 0;
                        last_hint = 0;
                    }
                    // is temp
                    cout << "Temp packet: " << packet_num << " CHIP_ID: " << chip_id << endl;
                    xo_day_time_in_min = ((v[2] & 0xFF) << 3) | (v[1] >> 29);
                    cout << "xo_day_time_in_min: " << xo_day_time_in_min << endl;
                    xo_day_time_in_sec = find_full_timestamp(xo_day_time_in_min, 
                                                             start_hour_in_sec);
                    cout << "xo_day_time_in_sec: " << dec << xo_day_time_in_sec << endl;

                    temp_unit tu(v);

                    try {
                    
                        while(1) {
                            uint16_t data = tu.read(7);
                            if(data == 0) {
                                break;
                            }
                            data |= 0b10000000;
                            double raw_data = pow(2, (data / 16.0));
                            cout << hex << xo_day_time_in_sec << " " << (uint32_t) raw_data << endl;
                            temp_data_map[xo_day_time_in_sec] = raw_data;

                            xo_day_time_in_sec -= LNT_INTERVAL[3];
                        }
                    }
                    catch(...) {}
                }
                else {
                    // is light
                    if(packet_num % 2 == 0) {
                        auto it = even_light_packets.find(chip_id);
                        if(it != even_light_packets.end()) {
                            cout << "Light packet {" << chip_id << ", " 
                                 << it->second.first << "} not matched. "
                                 << "Discarded. " << endl;
                            even_light_packets.erase(chip_id);
                        }
                        even_light_packets.insert({chip_id, {packet_num, v}});
                        cout << "Light packet: " << packet_num << " CHIP_ID: " 
                             << chip_id << endl;
                        cout << "Waiting for second packet." << endl;
                    }
                    else {
                        cout << "Light packet: " << packet_num << " CHIP_ID: " 
                             << chip_id << endl;
                        light_unit lu;
                        auto it = even_light_packets.find(chip_id);
                        if(it == even_light_packets.end() 
                                || it->second.first != packet_num - 1) {
                            cout << "Last packet " << packet_num - 1 << " not found" << endl;
                            lu = light_unit(vector<uint32_t>{3, 0}, v, 72);
                        }
                        else {
                            lu = light_unit(it->second.second, v, 144);
                        }
                        even_light_packets.erase(chip_id);

                        uint16_t final_ref_data;
                        try {
                            xo_day_time_in_min = lu.read(11);
                            xo_day_time_in_sec = find_full_timestamp(xo_day_time_in_min, 
                                                                     start_hour_in_sec);
                            cout << "xo_day_time_in_sec: " << dec << xo_day_time_in_sec  << " " << xo_day_time_in_min << endl;
                            final_ref_data = lu.read(11);
                            cout << final_ref_data << endl;
                            light_data_map[xo_day_time_in_sec] = final_ref_data;
                            while(1) {
                                uint16_t l1_mode = lu.read(2);
                                uint16_t l1_len = lu.read(3);
                                if(l1_len == 0) { break; }
                                cout << "l1_mode: " << l1_mode << " ";
                                cout << "l1_len: " << l1_len << endl;

                                for(int i = 0; i < l1_len; i++) {
                                    uint16_t l2_mode = lu.read(2);
                                    uint16_t l2_len = lu.read(6 - l2_mode);
                                    cout << "l2_mode: " << l2_mode << " ";
                                    cout << "l2_len: " << l2_len << endl;

                                    for(int j = 0; j < l2_len; j++) {
                                        const uint16_t LEN_MODE[4] = {4, 6, 9, 11};
                                        uint16_t diff = lu.read(LEN_MODE[l2_mode]);
                                        cout << diff << endl;
                                        if(l2_mode != 3) {
                                            diff = extend(diff, LEN_MODE[l2_mode]);
                                            final_ref_data += diff;
                                        }
                                        else {
                                            if(diff - final_ref_data > (1 << 9) || diff < (1 << 9)) {
                                                diff = extend(diff, LEN_MODE[l2_mode]);
                                                final_ref_data += diff;
                                            }
                                            else {
                                                final_ref_data = diff;
                                            }
                                        }

                                        if(xo_day_time_in_sec > LNT_INTERVAL[l1_mode]) {
                                            xo_day_time_in_sec -= LNT_INTERVAL[l1_mode]; 
                                        }
                                        else {
                                            xo_day_time_in_sec = XO_MAX_DAY_TIME_IN_SEC 
                                                                 + xo_day_time_in_sec 
                                                                 - LNT_INTERVAL[l1_mode];
                                        }
                                        cout << dec << xo_day_time_in_sec 
                                             << " " << final_ref_data << endl;
                                        light_data_map[xo_day_time_in_sec] = final_ref_data;
                                    }
                                }
                            }

                        }
                        catch(runtime_error& e) {
                            cout << e.what() << endl;
                        }
                    }
                }
            }
            cout << endl;
            cout << endl;
        }

    }

    for(auto it = light_data_map.begin(); it != light_data_map.end(); it++) {
        light_fout << it->first << "," << pow(2, it->second / 32.0) << endl;
    }

    for(auto it = temp_data_map.begin(); it != temp_data_map.end(); it++) {
        temp_fout << it->first << "," << it->second << endl;
    }
}
