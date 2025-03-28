#include "callback.h"

// This file is typically needed to provide any non-inline method implementations
// In this case, most methods are already defined in the header, 
// but we'll include this for completeness and potential future extensions

// If you need any additional implementation details for Caller or Callback
// You can add them here. For now, it can remain minimal.

// Example of a potential concrete implementation of Callback
class DefaultCallback : public Callback {
public:
    DefaultCallback() {
        std::cout << "C++: DefaultCallback constructor" << std::endl;
    }

    void execute() override {
        std::cout << "C++: Executing default callback implementation" << std::endl;
    }
};