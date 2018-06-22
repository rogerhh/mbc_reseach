#ifndef DATASET_HPP
#define DATASET_HPP

#include "DataPoint.hpp"

#include <string>
#include <vector>

namespace MBC
{

class Dataset
{

// A data stucture for data points of a single day

public:
    const int serial_num;
    const std::string day;
    
    DataPoint* datapoints;

    std::string note;

    Dataset(const std::string& day_in, double serial_num_in, const std::string& note_in);

    ~Dataset();
    
    // throws a runtime_error if the data point does not exist
    double& operator[](int index);

    // static constant expressions
    static constexpr int SIZE_OF_DATAPOINTS  = 24 * 60 * 60;
    static constexpr int SIZE_OF_DATA_FIELDS = 8;

    static constexpr int ACTUAL_LONGTITUDE            = 0;
    static constexpr int ACTUAL_LATITUDE              = 1;
    static constexpr int CALCULATED_LONGTITUDE        = 2;
    static constexpr int CALCULATED_LATITUDE          = 3;
    static constexpr int ACTUAL_SUNRISE_TIME          = 4;
    static constexpr int ACTUAL_SUNSET_TIME           = 5;
    static constexpr int CALCULATED_SUNRISE_TIME      = 6;
    static constexpr int CALCULATED_SUNSET_TIME       = 7;
    // static constant expressions

private:
    // -1000 indicates that the value is unavailable
    std::vector<double> data = std::vector<double>(SIZE_OF_DATA_FIELDS, -1000);
};

std::ostream& operator<<(std::ostream os, Dataset& dataset);

} // namespace MBC

#endif
