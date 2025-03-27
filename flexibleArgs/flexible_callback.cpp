#pragma once
#include <functional>
#include <memory>
#include <string>
#include <iostream>
#include <chrono>
#include <thread>

class FlexibleCallback
{
public:
    // Store a type-erased callback that can take any arguments
    std::function<void(...)> callback;

    // Set callback with any callable
    template <typename Func>
    void setCallback(Func func)
    {
        // Convert to a std::function that can take any arguments
        callback = [func](auto &&...args)
        {
            // Perfect forwarding of arguments
            func(std::forward<decltype(args)>(args)...);
        };
    }

    // Invoke the stored callback with any arguments
    template <typename... Args>
    void invokeCallback(Args &&...args)
    {
        if (callback)
        {
            // Forward the arguments to the stored callback
            callback(std::forward<Args>(args)...);
        }
    }
};

// Example usage class
class Hello
{
public:
    FlexibleCallback flexCallback;

    void Greet(const std::string &name)
    {
        std::cout << "Hello, " << name << "!" << std::endl;
    }

    void FireCallbacks(int count, int sleep)
    {
        for (int i = 0; i < count; i++)
        {
            // Can invoke with any arguments
            flexCallback.invokeCallback();            // zero args
            flexCallback.invokeCallback(42);          // one int arg
            flexCallback.invokeCallback("test", 123); // string and int
        }
    }
};