#include <fstream>
#include <iostream>
#include <bitset>
#include <vector>
#include <stdint.h>
#include <string>
#include <map>
#include <set>

#include "/home/rogerhh/Dropbox/m3_monarch/pre_v20e/software/mbc_code/huffman_encodings_v5_2_1.h"

#define CODE_CACHE_MAX_REMAINDER 272
#define TEMP_CACHE_MAX_REMAINDER 64

using namespace std;

int chip_id;
map<int, map<int, int>> light_huffman_tree;
uint16_t light_val = 0;

void read_light_huffman_tree() {
    for(int i = 1; i <= 12; i++) {
        light_huffman_tree.insert({i, map<int, int>{}});
    }
    for(int i = 0; i < 67; i++) {
        light_huffman_tree[code_lengths[i]].insert({diff_codes[i], i});
    }
    /*
    cout << "light tree" << endl;
    for(auto p : light_huffman_tree) {
        cout << p.first << ": ";
        for(auto k : p.second) {
            cout << k.first << " ";
        }
        cout << endl;
    }
    cout << endl;
    */
}

struct LightUnit {
    bitset<272> data;
    int size = 0;
    int packet_number = 0;
    static map<time_t, double> light_data;

    void read_packet(string packet) {
        size += 68;
        uint32_t temp = stoul(packet.substr(3, 1), 0, 16);
        data <<= 4;
        data |= bitset<272>(temp);
        temp = stoul(packet.substr(4, 8), 0, 16);
        data <<= 32;
        data |= bitset<272>(temp);
        temp = stoul(packet.substr(12, 8), 0, 16);
        data <<= 32;
        data |= bitset<272>(temp);

        cout << "data = " << data << endl;
    }

    int read(int len) {
        if(size < len) {
            return -1;
        }
        uint16_t res;
        size -= len;
        res = ((data >> size) & bitset<272>((1 << len) - 1)).to_ulong();
        return res;
    }

    int read_next() {
        uint16_t temp = 0;
        int len = 0;
        while(1) {
            int b = read(1);
            if(b == -1) {
                return -1;
            }
            len++;
            if(len > 12) {
                return -1;
            }
            temp = (temp << 1) | b;
            // cout << "temp = " << temp << endl;
            auto it = light_huffman_tree[len].find(temp);
            if(it != light_huffman_tree[len].end()) {
                // cout << "code = " << temp << endl;
                return it->second;
            }
        }
    }

    int last_day_state = -1;

    void process_unit() {
        // first read header
        bool has_header = false;
        int idx, day_state, timestamp;
        while(1) {
            if(!has_header) {
                uint32_t header = read(26);
                idx = header & 0x7F;
                day_state = (header >> 7) & 0x3;
                timestamp = (header >> 9) & 0x1FFFF;

                cout << idx << " " << day_state << " " << timestamp << endl;
                has_header = true;

                // reset data at new day_state, this needs to be fixed in the new version
                if(day_state != last_day_state) {
                    light_val = 0;
                }
            }
            int code = read_next();
            if(code == -1) {
                break;
            }
            cout << "idx = " << code << endl;

            if(code < 64) {
                light_val += (code - 32);
            }
            else if(code == 64) {
                int16_t diff = read(9);
                cout << "diff = " << bitset<9>(diff) << endl;
                if(bitset<9>(diff)[8]) {
                    diff -= 2 * (1 << 8);
                }
                light_val += diff;
            }
            else if(code == 65) {
                uint16_t diff = read(11);
                cout << "diff = " << bitset<11>(diff) << endl;
                if(bitset<11>(diff)[10]) {
                    diff -= 2 * (1 << 10);
                }
                light_val += diff;
            }
            else if(code == 66) {
                has_header = false;
            }
            cout << "data = " << light_val << endl;
        }
        cout << endl;
    }

    void clear() {
        data = bitset<272>(0);
        size = 0;
    }
    // 0000 0000 0111 1011 0 00 0 0000
    
};

struct TempUnit {
    bitset<80> data;
};

int main(int argc, char** argv) {
    if(argc != 2) {
        cerr << "Usage: ./decoder_v5_2_1.exe [CHIP_ID]" << endl;
        exit(1);
    }
    read_light_huffman_tree();
    chip_id = atoi(argv[1]);
    string packet;
    LightUnit lu;
    cout << (stoul("b0", 0, 16) >> 2) << endl;
    while(cin >> packet) {
        packet = packet.substr(4, 20);
        cout << packet << endl;
        // check chip id
        int id = (stoul(packet.substr(0, 2), 0, 16) >> 2) & 0x1F;
        if(id != chip_id) {
            cerr << "Wrong chip id" << endl;
            continue;
        }
        if(stoul(packet.substr(0, 1), 0, 16) & 0x8) {
            // is light
            int packet_num = stoul(packet.substr(0, 3), 0, 16) & 0x3F;
            cout << packet_num << endl;

            if(packet_num != lu.packet_number) {
                // packet num doesn't match, process current unit
                cout << "packet number doesn't match" << endl;
                lu.process_unit();
            }

            if(packet_num == lu.packet_number || packet_num % 4 == 0) {
                // set next packet num
                lu.packet_number = (packet_num + 1) & 0x3F;
                lu.read_packet(packet);

                cout << packet_num << endl;
                if(packet_num % 4 == 3) {
                    cout << "here2" << endl;
                    lu.process_unit();
                }
            }
        }
    }
}
