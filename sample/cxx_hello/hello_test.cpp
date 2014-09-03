#include "print_driver_mock.h"
#include "hello.h"

TEST(HelloTest, HelloWorld)
{
    PrintDriverMock pd_mock;
    EXPECT_CALL(pd_mock, doPrint(::testing::StrEq("Hello, World!")))
        .Times(1);

    Hello hello(pd_mock);
    hello.print("World!");
}

TEST(HelloTest, Empty)
{
    PrintDriverMock pd_mock;
    EXPECT_CALL(pd_mock, doPrint(::testing::StrEq("Hello, ")))
        .Times(1);

    Hello hello(pd_mock);
    hello.print("");
}

TEST(HelloTest, Null)
{
    PrintDriverMock pd_mock;
    EXPECT_CALL(pd_mock, doPrint(::testing::StrEq("Hello, ")))
        .Times(1);

    Hello hello(pd_mock);
    hello.print(0);
}

int main(int argc, char** argv)
{
    ::testing::InitGoogleMock(&argc, argv);
    return RUN_ALL_TESTS();
}
