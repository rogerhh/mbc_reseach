#include <iostream>
#include "TutorialConfig.hpp"
#include "TutorialConfig2.hpp"
#ifdef USE_TESTLIB1
    #include "TestLib.hpp"
#else
    #include "TestLib2.hpp"
#endif

int main()
{
    std::cout << "constant_0 = " << Tutorial_constant_0
              << "\nconstant_1 = " << Tutorial_constant_1 << "\n"
              << xx;
    printstuff();
    return 0;
}
