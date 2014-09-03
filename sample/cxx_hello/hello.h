#ifndef HELLO_H_
#define HELLO_H_

class PrintDriver;

class Hello
{
public:
    Hello(PrintDriver& print_driver);

    void print(const char* who) const;

private:
    PrintDriver& print_driver_;
};

#endif // HELLO_H_
