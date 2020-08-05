#include <fstream>
#include <iostream>
#include <queue>
#include <map>
#include <bitset>
#include <iomanip>

using namespace std;

struct Node {
    bool is_leaf = true;
    int diff = 0;
    int count = 0;
    int depth = 0;
    int code = 0;

    Node(int diff_in, int count_in) : diff(diff_in), count(count_in) {}

    Node(Node* left_in, Node* right_in) : left(left_in), right(right_in) {
        is_leaf = false;
        count = left->count + right->count;
    }

    Node* left = nullptr;
    Node* right = nullptr;
};

struct comp {
    bool operator()(const Node* left, const Node* right) const {
        return left->count > right->count;
    }
};

struct Code {
    int len = 0;
    int code = 0;

    Code() {}
    Code(int len_in, int code_in) : len(len_in), code(code_in) {}
};

ostream& operator<<(ostream& os, const Code& c) {
    os << c.len << " " << c.code << " ";
    for(int i = c.len - 1; i >= 0; i--) {
        os << ((c.code >> i) & 1);
    }
    return os;
}

void get_code(map<int, Code>& res, Node* node) {
    if(!node) {
        return;
    }
    if(node->is_leaf) {
        res[node->diff] = Code(node->depth, node->code);
        return;
    }

    node->left->code = (node->code << 1);
    node->right->code = (node->code << 1) + 1;
    node->left->depth = node->right->depth = node->depth + 1;

    get_code(res, node->left);
    get_code(res, node->right);
}

map<int, Code> process_light() {
    string ppath = getenv("PROJECT_DIR");
    ifstream code_fin(ppath + "/data/src/compression_sim/light_histogram.txt");

    priority_queue<Node*, vector<Node*>, comp> pq;
    map<int, double> freq_map;

    // read in histogram
    int code, count;
    double sum = 0;
    while(code_fin >> code >> count) {
        sum += count;
        pq.push(new Node(code, count));
        freq_map[code] = count;
    }

    while(pq.size() > 1) {
        Node* node1 = pq.top();
        pq.pop();
        Node* node2 = pq.top();
        pq.pop();

        Node* new_node = new Node(node1, node2);
        pq.push(new_node);
    }

    map<int, Code> m;
    get_code(m, pq.top());

    ofstream fout(ppath + "/data/src/compression_sim/light_huffman_tree_v3.txt");

    for(auto& p : m) {
        if(p.second.code == 0) {
            p.second.code = 1;
            p.second.len++;
        }
        fout << p.first << " " << p.second << endl;
    }

    // calculate average
    double exp_sum = 0;
    for(auto p : freq_map) {
        if(p.first == 0x1FF) {
            exp_sum += p.second * (m[0x1FF].len + 9) / sum;
        }
        else if(p.first == 0x7FF) {
            exp_sum += p.second * (m[0x7FF].len + 11) / sum;
        }
        else {
            exp_sum += p.second * m[p.first].len / sum;
        }
    }

    cout << "Expected length per light data point = " << exp_sum << endl;

    return m;


}

map<int, Code> process_temp() {
    string ppath = getenv("PROJECT_DIR");
    ifstream code_fin(ppath + "/data/src/compression_sim/temp_histogram.txt");

    priority_queue<Node*, vector<Node*>, comp> pq;
    map<int, double> freq_map;

    // read in histogram
    int code, count;
    double sum = 0;
    while(code_fin >> code >> count) {
        sum += count;
        pq.push(new Node(code, count));
        freq_map[code] = count;
    }

    while(pq.size() > 1) {
        Node* node1 = pq.top();
        pq.pop();
        Node* node2 = pq.top();
        pq.pop();

        Node* new_node = new Node(node1, node2);
        pq.push(new_node);
    }

    map<int, Code> m;
    get_code(m, pq.top());

    ofstream fout(ppath + "/data/src/compression_sim/temp_huffman_tree_v3.txt");

    for(auto& p : m) {
        if(p.second.code == 0) {
            p.second.code = 1;
            p.second.len++;
        }
        fout << p.first << " " << p.second << endl;
    }

    // calculate average
    double exp_sum = 0;
    for(auto p : freq_map) {
        if(p.first == 0x7F) {
            exp_sum += p.second * (m[0x7F].len + 7) / sum;
        }
        else {
            exp_sum += p.second * m[p.first].len / sum;
        }
    }

    cout << "Expected length per temp data point = " << exp_sum << endl;

    return m;


}

int main(int argc, char** argv) {
    auto m = process_light();

    string ppath = getenv("PROJECT_DIR");
    ofstream header_fout(ppath + "/data/src/compression_sim/huffman_encodings_v3.h");
    header_fout << "#ifndef HUFFMAN_ENCODINGS_H\n#define HUFFMAN_ENCODINGS_H\n\nuint16_t light_diff_codes[67]={";

    int i = 0;
    for(auto p : m) {
        header_fout << p.second.code;
        if(i != 66) {
            header_fout << ",";
        }
        i++;
    }
    header_fout << "};\nuint8_t light_code_lengths[67]={";
    i = 0;
    for(auto p : m) {
        header_fout << p.second.len;
        if(i != 66) {
            header_fout << ",";
        }
        i++;
    }
    
    m = process_temp();

    header_fout << "};\n\nuint16_t temp_diff_codes[5]={";

    i = 0;
    for(auto p : m) {
        header_fout << p.second.code;
        if(i != 4) {
            header_fout << ",";
        }
        i++;
    }
    header_fout << "};\nuint8_t temp_code_lengths[5]={";
    i = 0;
    for(auto p : m) {
        header_fout << p.second.len;
        if(i != 4) {
            header_fout << ",";
        }
        i++;
    }

    header_fout << "};\n\n#endif";
}
