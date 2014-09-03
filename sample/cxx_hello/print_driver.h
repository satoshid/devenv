#ifndef PRINT_DRIVER_H_
#define PRINT_DRIVER_H_

class PrintDriver
{
public:
    virtual ~PrintDriver() {}

    virtual void doPrint(const char* str) const = 0;
};

#endif // PRINT_DRIVER_H_
