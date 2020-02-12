#include <cmath>
#include <iostream>
#include <bitset>
#include <fstream>
#include <cassert>

#define FLOAT_LEN 16

using namespace std;

const uint16_t LOG_CONST_ARR[5] = {0b1011010100000100,
                                   0b1001100000110111,
                                   0b1000101110010101,
                                   0b1000010110101010,
                                   0b1000001011001101};

typedef uint32_t* uint128_t;

void long_int_assign(uint128_t dest, uint128_t src) {
    for(int i = 0; i < 4; i++) {
        dest[i] = src[i];
    }
}

void long_int_add(uint128_t lhs, uint128_t rhs, uint128_t res) {
    uint32_t carry_in = 0;
    uint32_t temp_res[4] = {0, 0, 0, 0};
    for(int i = 0; i < 4; i++) {
        uint64_t temp = carry_in + lhs[i] + rhs[i]; 
        carry_in = temp >> 32;
        temp_res[i] = temp & 0xFFFFFFFF;
    }
}

void long_int_mult(uint128_t lhs, uint16_t rhs, uint128_t res) {
    uint32_t carry_in = 0;
    uint32_t temp_res[4] = {0, 0, 0, 0};
    for(int i = 0; i < 4; i++) {
        uint64_t temp = ((uint64_t) lhs[i] * rhs) + carry_in;
        // cout << lhs[i] << " " << rhs << " temp = " << bitset<64>(temp) << endl;
        carry_in = temp >> 32;
        temp_res[i] = temp & 0xFFFFFFFF;
    }
    long_int_assign(res, temp_res);
}

bool long_int_lte(uint128_t lhs, uint128_t rhs) {
    for(int i = 0; i < 4; i++) {
        if(lhs[3 - i] < rhs[3 - i])
            return true;
        else if(lhs[3 - i] > rhs[3 - i])
            return false;
    }
    return false;
}

ostream& operator<<(ostream& os, uint128_t in) {
    for(int i = 0; i < 4; i++) {
        os << bitset<32>(in[3 - i]);
    }
    return os;
}

uint16_t func_log2(uint64_t input) {

    if(input == 0) { return 0xFFFF; }
    
    uint32_t temp_result[4] = {0, 0, 0, 0}, input_storage[4] = {0, 0, 0, 0};
    input_storage[0] = input & 0xFFFFFFFF;
    input_storage[1] = input >> 32;
    uint16_t out = 0;
    /*
    cout << input << endl;
    cout << bitset<64>(input) << endl;
    */
    for(int16_t i = 63; i >= 0; i--) {
        if(input & ((uint64_t) 1 << i)) {
            temp_result[0] = (1 << i) & 0xFFFFFFFF;
            temp_result[1] = i >= 32? (1 << (i - 32)) : 0;
            cout << "i = " << i << endl;
            out = i * (1 << 5);
            cout << bitset<32>(1 << i) << " " << bitset<11>(out) << endl;
            break;
        }
    }

    cout << "first temp result = " << temp_result << endl;

    for(int i = 0; i < 5; i++) {
        uint32_t new_result[4];
        long_int_mult(temp_result, LOG_CONST_ARR[i], new_result);
        long_int_mult(input_storage, (1 << 15), input_storage);
        // cout << "input = \t\t" << input_storage << "\nnew result = \t\t" << new_result << "\ntemp_result = \t\t" <<  temp_result << endl;

        if(long_int_lte(new_result, input_storage)) {
            long_int_assign(temp_result, new_result);
            // cout << 1 << endl;
            out |= (1 << (4 - i));
        }
        else {
            long_int_mult(temp_result, (1 << 15), temp_result);
            // cout << 0;
        }
    }
    
    /*
    cout << "out = " << bitset<11>(out & 0xFFF) << endl;;
    cout << "2^out = " << pow(2, (((double) out) / pow(2, 5))) << endl;
    */

    return out;
// if(input == 0) { return 0xFFFF; } uint64_t temp_result = 0;
    // uint16_t out = 0;
    // cout << input << endl;
    // cout << bitset<64>(input) << endl;
    // for(int16_t i = 63; i >= 0; i--) {
    //     if(input & ((uint64_t) 1 << i)) {
    //         temp_result = (uint64_t) 1 << i;
    //         cout << "i = " << i << endl;
    //         out = i * (1 << 5);
    //         cout << bitset<32>(1 << i) << " " << bitset<32>(temp_result) << " " << bitset<11>(out) << endl;
    //         break;
    //     }
    // }

    // cout << "break: " <<  temp_result << " " << input << endl;
    // 
    // for(int i = 0; i < 5; i++) {
    //     uint64_t last_result = temp_result;
    //     temp_result = ((temp_result * LOG_CONST_ARR[i]));
    //     cout << (double) (temp_result) << " " << (double) (input << FLOAT_LEN) << " " << bitset<11>(out) <<  endl;
    //     cout << (double) (temp_result / pow(2, FLOAT_LEN)) << " " << (double) input << " " << bitset<11>(out) <<  endl;
    //     cout << bitset<64>(temp_result) << endl;
    //     if((input << FLOAT_LEN) >= temp_result) {
    //         // temp_result = temp_result >> FLOAT_LEN;
    //         cout << 1 << endl;
    //         out |= (1 << (4 - i));
    //     }
    //     else {
    //         cout << 0 << endl;
    //         temp_result = last_result;
    //     }
    //     cout << (double) (temp_result) << " " << (double) (input << FLOAT_LEN) << " " << bitset<11>(out) <<  endl;
    //     cout << (double) (temp_result / pow(2, FLOAT_LEN)) << " " << (double) input << " " << bitset<11>(out) <<  endl;
    //     cout << endl;
    // }

    // cout << "out = " << bitset<11>(out & 0xFFF) << endl;;
    // cout << "2^out = " << pow(2, (((double) out) / pow(2, 5))) << endl;
    // return out;
}

int main() {
    ofstream fout("log2.csv");
    double lower = 1, upper = 2;
    cout << func_log2(pow(2, 32) - 1) << " " << pow(2, 32) << endl; 
    cout << func_log2(271623352525783) << endl;
    while(upper <= pow(2, 48)) {
         int size = upper > pow(2, 32)? 1000 : 100;
         double step = (upper - lower) / size;
         for(int i = 0; i < size; i++) {
             uint64_t x = lower + i * step;
             uint32_t res = func_log2(x);
             fout << x << "," << ((double) res / pow(2, 5)) << "," << log2(x) << "," << pow(2, ((double) res) / pow(2, 5)) << endl;
         }
         lower *= 2;
         upper *= 2;
    }
} 
