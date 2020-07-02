#include <fstream>
#include <iostream>
#include <queue>
#include <map>
#include <bitset>
#include <iomanip>

using namespace std;

struct Node {
    bool is_leaf = true;
    int mode = 0;   // 0 = -32 to 31 (6 bits), 1 = 9 bits, 2 = 11 bits
    int diff = 0;
    int count = 0;
    int depth = 0;
    int code = 0;

    Node(int mode_in, int diff_in, int count_in) : mode(mode_in), diff(diff_in), count(count_in) {}

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
    os << c.len << " ";
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
        if(node->mode == 0) {
            res[node->diff] = Code(node->depth, node->code);
        }
        else if(node->mode == 1) {
            res[0x1FF] = Code(node->depth, node->code);
        }
        else if(node->mode == 2) {
            res[0x7FF] = Code(node->depth, node->code);
        }
        return;
    }

    node->left->code = (node->code << 1) + 1;
    node->right->code = (node->code << 1);
    node->left->depth = node->right->depth = node->depth + 1;

    get_code(res, node->left);
    get_code(res, node->right);
}

int main(int argc, char** argv) {
    // argv contains 3 numbers 
    string ppath = getenv("PROJECT_DIR");
    ifstream code_diff_fin(ppath + "/data/src/compression_sim/code_diff.txt");

    priority_queue<Node*, vector<Node*>, comp> pq;

    // read in code diff
    int diff, count, code_cnt = 0;
    int count_9b = 0, count_11b = 0;
    double sum = 0;
    map<int, double> freq_map;
    while(code_diff_fin >> diff >> count) {
        sum += count;
        if(diff < 32 && diff >= -32) {
            pq.push(new Node(0, diff, count));
            freq_map[diff] = count;
        }
        else if(diff < 256 && diff >= -256) {
            count_9b += count;
            freq_map[0x1FF] += count;
        }
        else {
            count_11b += count;
            freq_map[0x7FF] += count;
        }
    }
    pq.push(new Node(1, 0, count_9b));
    pq.push(new Node(2, 0, count_11b));

    code_cnt = pq.size();

    // keep finding lowest two and merge
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

    ofstream fout(ppath + "/data/src/compression_sim/huffman_tree.txt");

    for(auto p : m) {
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
    
    cout << "Expected length per data point = " << exp_sum << endl;
}
