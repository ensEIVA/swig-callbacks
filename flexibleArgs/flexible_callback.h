#pragma once
#include <functional>
#include <memory>
#include <string>
#include <iostream>
#include <tuple>
#include <utility>
#include <chrono>
#include <thread>

class FlexibleCallback
{
public:
    // Base template for storing and invoking callbacks
    template <typename... Args>
    class CallbackWrapper
    {
    public:
        using CallbackType = std::function<void(Args...)>;

        CallbackWrapper() = default;

        explicit CallbackWrapper(CallbackType callback)
            : m_callback(std::move(callback)) {}

        void invoke(Args... args)
        {
            if (m_callback)
            {
                m_callback(std::forward<Args>(args)...);
            }
        }

        bool hasCallback() const
        {
            return static_cast<bool>(m_callback);
        }

    private:
        CallbackType m_callback;
    };

    // Type-erased callback base class
    class CallbackBase
    {
    public:
        virtual ~CallbackBase() = default;
        virtual void invoke() = 0;
    };

    // Templated callback implementation
    template <typename... Args>
    class TypedCallback : public CallbackBase
    {
    public:
        TypedCallback(std::function<void(Args...)> callback, Args... args)
            : m_callback(std::move(callback)),
              m_args(std::make_tuple(std::forward<Args>(args)...)) {}

        void invoke() override
        {
            std::apply(m_callback, m_args);
        }

    private:
        std::function<void(Args...)> m_callback;
        std::tuple<Args...> m_args;
    };

    // Method to set a callback with any number of arguments
    template <typename... Args>
    void setCallback(std::function<void(Args...)> callback);

    // Invoke the stored callback
    void invokeCallback()
    {
        if (m_typeErasedCallback)
        {
            m_typeErasedCallback->invoke();
        }
    }

private:
    // Type-erased callback storage
    std::unique_ptr<CallbackBase> m_typeErasedCallback;
};

// Example class using the flexible callback
class Hello
{
public:
    FlexibleCallback callback;

    void Greet(const std::string &name)
    {
        std::cout << "Hello, " << name << "!" << std::endl;
    }

    void FireCallbacks(int count, int sleep)
    {
        for (int i = 0; i < count; i++)
        {
            callback.invokeCallback();
            std::this_thread::sleep_for(std::chrono::milliseconds(sleep));
        }
    }
};