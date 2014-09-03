#include "print_driver_impl.h"
#include <iostream>

PrintDriverImpl::PrintDriverImpl()
{}

PrintDriverImpl::~PrintDriverImpl()
{}

void PrintDriverImpl::doPrint(const char* str) const
{
    std::cout << str << std::endl;
}
