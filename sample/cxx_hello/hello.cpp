#include "hello.h"
#include "print_driver.h"
#include <string>

Hello::Hello(PrintDriver& print_driver)
    : print_driver_(print_driver)
{}

void Hello::print(const char* who) const
{
    std::string str("Hello, ");

    if (who) {
        str += who;
    }

    print_driver_.doPrint(str.c_str());

    return;
}
