#ifndef PRINT_DRIVER_MOCK_H_
#define PRINT_DRIVER_MOCK_H_

#include "gmock/gmock.h"
#include "print_driver.h"

class PrintDriverMock : public PrintDriver
{
public:
    MOCK_CONST_METHOD1(doPrint, void(const char* str));
};

#endif // PRINT_DRIVER_MOCK_H_
