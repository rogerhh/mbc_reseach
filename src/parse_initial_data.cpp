#include <iostream>
#include <cmath>
#include <iomanip>
#include <fstream>
#include <string>

using namespace std;

void find_and_replace(string& source, const string&, const string&);

int main(int argc, char** argv)
{
	if(argc != 3)
	{
		cout << "Usage: [filename] [interval (seconds)] \n";
		return 0;
	}
	string in_filename = string(argv[1]);
	int interval = stoi(string(argv[2]));
	ifstream ifs(in_filename);
	if(!ifs.is_open())
	{
		cout << "Error opening file: " << in_filename << endl;
		return 0;
	}
	string out_filename, date, time, value;
	ofstream ofs;
	int logger_num;
	ifs.ignore(20, ':');
	ifs >> logger_num;
	getline(ifs, date);
	bool start = false;
	int count = 0;
	while(ifs.ignore(10, ','))
	{
		getline(ifs, date, ' ');
		getline(ifs, time, ',');
		getline(ifs, value);
		if(!start && time == "05:00:00 AM")
		{
			start = true;
			count = 0;
			find_and_replace(date, "/", "-");
			out_filename = date + "_data_table_logger_" + to_string(logger_num);
			ofs = ofstream("../../data/" + out_filename + ".csv");
			if(!ofs.is_open())
			{
				cout << "Error opening file: ../../data/" << out_filename << ".csv" << endl;
				return 0;
			}
			ofs << "\"" << out_filename << "\"\n"
				<< "\"Seconds past 5:00:00 AM\",\"Intensity, Lux\"," 
				<< "\"log10(Intensity+1)\"" << endl;
		} else if(start && time == "09:00:00 PM")
		{
			start = false;
			ofs.close();
		}

		if(start)
		{
			ofs << count << "," << stod(value) << "," << log10(stod(value) + 1) <<"\n";	
			count += interval;
			//cout << value << "\n";
		}
	}
	return 0;
}

void find_and_replace(string& source, const string& find, const string& replace)
{
    for(string::size_type i = 0; (i = source.find(find, i)) != string::npos;)
    {
        source.replace(i, find.length(), replace);
        i += replace.length();
    }
}
