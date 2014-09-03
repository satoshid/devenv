#ifndef PRINT_DRIVER_IMPL_H_
#define PRINT_DRIVER_IMPL_H_

#include "print_driver.h"

class PrintDriverImpl : public PrintDriver
{
public:
    PrintDriverImpl();
    virtual ~PrintDriverImpl();

    virtual void doPrint(const char* str) const;
};

#endif // PRINT_DRIVER_IMPL_H_
