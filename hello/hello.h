#pragma once
#include <functional>
#include <memory>
#include <string>

class Hello
{
public:
    Hello();
    void SetCallbackWithArg(std::function<void(int)> callback);
    void RunCallback();
    void FireCallbacks(int count, int sleep);

private:
    std::function<void(int)> m_callbackWithArg;
};

