#include <iostream>
#include <cmath>
#include <fstream>
#include <vector>
#include <iomanip>

using namespace std;

int main(int argc, char** argv)
{
	if(argc < 3)
	{
		cout << "Usage: [out_file] [Filename]..." << endl;
		return 0;
	}
	ifstream ifs;
	vector<vector<double>> data;
	for(int i = 2; i < argc; i++)
	{
		ifs.open(string(argv[i]));
		if(!ifs.is_open())
		{
			cout << "Error opening file: " << argv[i] << endl;
			return 0;
		}
		ifs.ignore(256);
		ifs.ignore(256);
		data.push_back(vector<double>());
		string time, val, logVal;
		while(getline(ifs, time, ',') && 
			  getline(ifs, val, ',') && 
			  getline(ifs, logVal)) 
		{
			data[i - 2].push_back(stod(val));
		}
		ifs.close();
	}
	double maxLux = 100;
	string out_filename = string(argv[1]);
	ofstream ofs(out_filename);
	if(!ofs.is_open())
	{
		cout << "Error opening file: " << out_filename << endl;
		return 0;
	}
	ofs << setprecision(2) << fixed;
	ofs << setw(5) << "Lux,\t\t";
	for(int i = 0; i < data.size(); i++)
	{
		ofs << setw(5) << "day " << i << "," << "\t\t";
	}
	ofs << endl;
	for(double luxLevel = 1; luxLevel < maxLux; luxLevel++)
	{
		ofs << setw(5) << luxLevel << ",\t\t";
		for(int i = 0; i < data.size(); i++)
		{
			for(int j = 0; j < data[i].size(); j++)	
			{
				if(data[i][j] >= luxLevel)
				{
					ofs << setw(6) /*<< i << " "*/ << j * 10; 
					break;
				}
				else if(j == data[i].size() - 1)
				{
					ofs << "No data available ";
				}
			}
			if(i != data.size() - 1)
			{
				ofs << ",\t\t";
			}
		}
		ofs << endl;
	}

    cout << "Writing to " << out_filename << endl;
	return 0;
}
