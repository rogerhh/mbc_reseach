#include "Dataset.hpp"

#include <iostream>
#include <string>
#include <stdexcept>

namespace MBC
{

Dataset::Dataset(const std::string& day_in, double serial_num_in, const std::string& note_in = "")
    : serial_num(serial_num_in), day(day_in), note(note_in)
{
    datapoints = new DataPoint[SIZE_OF_DATA_FIELDS];
}

double& Dataset::operator[](int index)
{
    if(data[index] == -1000)
    {
        std::string msg = "Error retrieving data from SN"
                           + std::to_string(serial_num) + " "
                           + day + " data["
                           + std::to_string(index) + "]\n";
        throw std::runtime_error(msg);
    }
    return data[index];
}

Dataset::~Dataset()
{
    delete[] datapoints;
}

std::ostream& operator<<(std::ostream& os, Dataset& dataset)
{
    os << dataset.serial_num << "    " << dataset.day << "\n" << dataset.note << "\n";
    for(int i = 0; i < Dataset::SIZE_OF_DATA_FIELDS; i++)
    {
        try
        {
            os << dataset[i] << " ";
        }
        catch(std::runtime_error& e)
        {
            os << "N/A" << " ";
        }
    }
    os << "\n";
    for(int i = 0; i < Dataset::SIZE_OF_DATAPOINTS; i++)
    {
        os << dataset.datapoints[i];
    }
    return os;
}

} // namespace MBC
