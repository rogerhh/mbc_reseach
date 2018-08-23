#include <iostream>

#include "unit_test_framework.h"
#include "../src/DataPoint.hpp"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

TEST(matrix_number_of_rows)
{
    vector<vector<DataPoint>> v;
    vector<int> serial_v;
    int res = select_datapoints(v, serial_v, "SN = 20369359 OR SN = 20369364");
    ASSERT_EQUAL(v.size(), 2);
    ASSERT_EQUAL(serial_v.size(), 2);
}

TEST(serial_num_info)
{
    vector<vector<DataPoint>> v;
    vector<int> serial_v;
    int res = select_datapoints(v, serial_v, "SN = 20369359 OR SN = 20369364");
    if(serial_v[0], 20369359)
    {
        ASSERT_EQUAL(serial_v[1], 20369364);
    }
    else
    {
        ASSERT_EQUAL(serial_v[0], 20369364);
        ASSERT_EQUAL(serial_v[1], 20369359);
    }
}

TEST(retrieve_data)
{
    vector<vector<DataPoint>> v;
    vector<int> serial_v;
    int res = select_datapoints(v, serial_v, "SECONDS_AFTER_EPOCH >= 1530014400 AND SECONDS_AFTER_EPOCH < 1530014460 AND SN = 20369361");
    ASSERT_EQUAL(res, 6);
    ASSERT_EQUAL(v[0][0].serial_num, 20369361);
    ASSERT_EQUAL(v[0][0].time, 1530014400);
    ASSERT_EQUAL(v[0][0].data[DataPoint::LATITUDE], 42.297778);
    ASSERT_EQUAL(v[0][0].data[DataPoint::LONGITUDE], -83.724722);
    ASSERT_EQUAL(v[0][0].data[DataPoint::LIGHT_INTENSITY], 8294.4);
    ASSERT_EQUAL(v[0][0].data[DataPoint::TEMPERATURE], 18.36);

    ASSERT_EQUAL(v[0][1].serial_num, 20369361);
    ASSERT_EQUAL(v[0][1].time, 1530014410);
    ASSERT_EQUAL(v[0][1].data[DataPoint::LATITUDE], 42.297778);
    ASSERT_EQUAL(v[0][1].data[DataPoint::LONGITUDE], -83.724722);
    ASSERT_EQUAL(v[0][1].data[DataPoint::LIGHT_INTENSITY], 6348.8);
    ASSERT_EQUAL(v[0][1].data[DataPoint::TEMPERATURE], 18.36);

    ASSERT_EQUAL(v[0][2].serial_num, 20369361);
    ASSERT_EQUAL(v[0][2].time, 1530014420);
    ASSERT_EQUAL(v[0][2].data[DataPoint::LATITUDE], 42.297778);
    ASSERT_EQUAL(v[0][2].data[DataPoint::LONGITUDE], -83.724722);
    ASSERT_EQUAL(v[0][2].data[DataPoint::LIGHT_INTENSITY], 7395.84);
    ASSERT_EQUAL(v[0][2].data[DataPoint::TEMPERATURE], 18.36);

    ASSERT_EQUAL(v[0][3].serial_num, 20369361);
    ASSERT_EQUAL(v[0][3].time, 1530014430);
    ASSERT_EQUAL(v[0][3].data[DataPoint::LATITUDE], 42.297778);
    ASSERT_EQUAL(v[0][3].data[DataPoint::LONGITUDE], -83.724722);
    ASSERT_EQUAL(v[0][3].data[DataPoint::LIGHT_INTENSITY], 6584.32);
    ASSERT_EQUAL(v[0][3].data[DataPoint::TEMPERATURE], 18.36);

    ASSERT_EQUAL(v[0][4].serial_num, 20369361);
    ASSERT_EQUAL(v[0][4].time, 1530014440);
    ASSERT_EQUAL(v[0][4].data[DataPoint::LATITUDE], 42.297778);
    ASSERT_EQUAL(v[0][4].data[DataPoint::LONGITUDE], -83.724722);
    ASSERT_EQUAL(v[0][4].data[DataPoint::LIGHT_INTENSITY], 7009.28);
    ASSERT_EQUAL(v[0][4].data[DataPoint::TEMPERATURE], 18.36);

    ASSERT_EQUAL(v[0][5].serial_num, 20369361);
    ASSERT_EQUAL(v[0][5].time, 1530014450);
    ASSERT_EQUAL(v[0][5].data[DataPoint::LATITUDE], 42.297778);
    ASSERT_EQUAL(v[0][5].data[DataPoint::LONGITUDE], -83.724722);
    ASSERT_EQUAL(v[0][5].data[DataPoint::LIGHT_INTENSITY], 7536.64);
    ASSERT_EQUAL(v[0][5].data[DataPoint::TEMPERATURE], 18.4);
}

TEST_MAIN();
