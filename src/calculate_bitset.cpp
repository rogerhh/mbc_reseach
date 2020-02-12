#include <cmath>
#include <iostream>
#include <bitset>

using namespace std;

#define FLOAT_LEN 24

int main(int argc, char** argv) {
    uint32_t out = 0;
    double input = pow(2, atof(argv[1]));
    cout << input << endl;
    input *= pow(2, FLOAT_LEN);
    cout << input << endl;
    for(int i = 31; i >= 0; i--) {
        if(input >= pow(2, i)) {
            input -= pow(2, i);
            out |= (1 << i);
        }
    }
    std::bitset<32> x(out);
    cout << out << endl;
    cout << x << endl;
    cout << log2((double) out / pow(2, FLOAT_LEN)) << endl;
    return 0;
}
