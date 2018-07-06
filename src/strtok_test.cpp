#include <string.h>
#include <cstring>
#include <iostream>

int main()
{

    std::string str = "1,,1,2,3,511,,,46,0.2,,,0.224,,81,";
    size_t start_pos = 0, end_pos;
    end_pos = str.find(",");
    while(end_pos != std::string::npos)
    {
        if(start_pos == end_pos)
        {
            std::cout << "\n";
        }
        std::cout << str.substr(start_pos, end_pos - start_pos) << "\n";
        start_pos = end_pos + 1;
        end_pos = str.find(",", start_pos);
    }
    return 0;
}
