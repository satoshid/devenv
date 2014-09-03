#include "print_driver_impl.h"
#include "hello.h"

int main()
{
    PrintDriverImpl pd_impl;
    Hello hello(pd_impl);

    hello.print("World!");

    return 0;
}
