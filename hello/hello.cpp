#include "hello.h"
#include <iostream>
#include <chrono>
#include <thread>

Hello::Hello()
{
    m_callbackWithArg = [](int arg)
    {
        std::cout << "Default callback with arg: " << arg << std::endl;
    };
}
void Hello::FireCallbacks(int count, int sleep)
{
    for (int i = 0; i < count; i++)
    {
        if (m_callback)
        {
            RunCallback();
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(sleep));
    }
}

void Hello::SetCallbackWithArg(std::function<void(int)> callback)
{
    m_callbackWithArg = callback;
}

void Hello::RunCallback()
{
    m_callbackWithArg(42); // Example argument
}

