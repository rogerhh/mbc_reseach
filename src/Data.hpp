#ifndef DATA_HPP
#define DATA_HPP

#include "DataPoint.hpp"
#include "Dataset.hpp"

#include <string>

namespace MBC
{

class Data
{
public:
    static const std::string DEST_FILE;

    void read_file(const std::string& in_filename)
};

} // namespace MBC

#endif
