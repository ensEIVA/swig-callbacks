#pragma once
#include <functional>
#include <memory>
#include <string>

class Hello
{
public:
    Hello();

    void Greet(std::string name);
    void SetCallback(std::function<void()> callback);
    void SetCallbackWithArg(std::function<void(int)> callback);
    void RunCallback();
    void FireCallbacks(int count, int sleep);

private:
    std::function<void()> m_callback;
    std::function<void(int)> m_callbackWithArg;
};
;
