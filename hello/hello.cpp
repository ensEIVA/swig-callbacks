#include "hello.h"
#include <iostream>
#include <chrono>
#include <thread>

Hello::Hello()
{
    m_callback = []()
    {
        std::cout << "Default callback" << std::endl;
    };
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
void Hello::SetCallback(std::function<void()> callback)
{
    m_callback = callback;
}

void Hello::SetCallbackWithArg(std::function<void(int)> callback)
{
    m_callbackWithArg = callback;
}

void Hello::RunCallback()
{
    // Call both callbacks if they are set
    if (m_callback)
    {
        m_callback();
    }
    if (m_callbackWithArg)
    {
        m_callbackWithArg(3);
    }
}
void Hello::Greet(const std::string name)
{
    std::cout << "Hello, " << name << "!" << std::endl;
}
