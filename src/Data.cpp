#include "Data.hpp"

#include <iostream>
#include <fstream>

namespace MBC
{

const std::string Dataset::DEST_FILE = "~/research/data/all_data.txt";

void Data::read_file(const std::string& in_filename)
{
    ifstream fin(in_filename);
    if(!fin.is_open())
    {
        std::cout << "Error opening file: " << in_filename << endl;
        throw 0;
    }
}

} // namespace MBC
