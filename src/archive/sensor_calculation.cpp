#include <iostream>
#include <cmath>
#include <exception>
#include <iomanip>

#define PI 3.14159

using namespace std;

int main() 
{
	double range, area;
	int configuration;
	char c;
	do
	{
		cout << "Range of sensors (meters): " << endl;
		cin >> range;
		cout << "Configuration [3, 4, or 6]: " << endl;
		cin >> configuration;
		cout << "Area (hectares): ";
		cin >> area;

		double effective_area = 0;

		switch (configuration) {
			case 3:
				effective_area = 3 * 0.5 * pow(range, 2) * sin(PI * 2 / 3);
				break;

			case 4:
				effective_area = 2 * pow(range, 2);
				break;

			case 6:
				effective_area = 6 * 0.5 * pow(range, 2) * sin(PI / 3);
				break;

			default:
				throw runtime_error("Invalid Configuration!");
		}

		cout << endl << endl << "Effective Area (square meters): " << fixed << setprecision(2) << effective_area << endl
			 << "Sensors needed to cover " << (int) (area * pow(10, 4)) << " square meters: " << (int) ceil(area * pow(10, 4) / effective_area)
			 << endl << endl << "Continue? (Y/N)" << endl;
		cin >> c;
	} while(c != 'N' && c != 'n');
}
