#include <iostream>
#include <sqlite3.h>
#include <cstring>
#include <string.h>
#include <vector>

#include "mex.h"
#include "matrix.h"
#include "../../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int serial_num = *mxGetPr(prhs[0]);
    char* start_time_cstr = mxArrayToString(prhs[1]);
    char* end_time_cstr = mxArrayToString(prhs[2]);

    vector<DataPoint> v;

    get_datapoints_in_range(v, serial_num, string(start_time_cstr), string(end_time_cstr));

    mxArray* mx1 = mxCreateDoubleMatrix(1, v.size(), mxREAL);
    mxArray* mx2 = mxCreateDoubleMatrix(1, v.size(), mxREAL);

    vector<long long> vtime(v.size());
    vector<double> vlight(v.size());

    for(int i = 0; i < v.size(); i++)
    {
        DataPoint* datapoint_ptr = &(v[i]);
        vtime[i] = v[i].time;
        vlight[i] = (*datapoint_ptr)[DataPoint::LIGHT_INTENSITY];
        // cout << vtime[i] << " " << vlight[i] << "\n";
    }
    copy(vtime.begin(), vtime.end(), mxGetPr(mx1));
    plhs[0] = mx1;

    copy(vlight.begin(), vlight.end(), mxGetPr(mx2));
    plhs[1] = mx2;

    return;
}
