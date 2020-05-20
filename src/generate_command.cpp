#include <iostream>
#include <vector>
#include <bitset>

using namespace std;

int main(int argc, char** argv) {
    vector<uint32_t> v;
    for(int i = 0; i < 6; i++) {
        v.push_back(atoi(argv[i + 1]));
        cout << bitset<11>(v.back()) << " ";
    }
    cout << endl;
    uint32_t res = ((v[0] & 0x1) << 31) | ((v[1] & 0x7FF) << 20) | ((v[2] & 0x1F) << 15) | ((v[3] & 0x7F) << 8) | ((v[4] & 0x7) << 5) | ((v[5] & 0x1) << 4);
    cout << bitset<32>(res) << " " << hex << res << endl;
    return 0;
}
