#pragma once
#include <iostream>

class Callback {
public:
    Callback() {
        std::cout << "C++: Callback constructor" << std::endl;
    }
    
    virtual ~Callback() {
        std::cout << "C++: Callback destructor" << std::endl;
    }
    
    // Pure virtual method to be implemented by derived classes
    virtual void execute() = 0;
};

class Caller {
private:
    Callback* currentCallback;

public:
    Caller() : currentCallback(nullptr) {
        std::cout << "C++: Caller constructor" << std::endl;
    }
    
    ~Caller() {
        std::cout << "C++: Caller destructor" << std::endl;
        resetCallback();
    }
    
    void setCallback(Callback* callback) {
        std::cout << "C++: Setting callback" << std::endl;
        currentCallback = callback;
    }
    
    void resetCallback() {
        std::cout << "C++: Resetting callback" << std::endl;
        currentCallback = nullptr;
    }
    
    void call() {
        if (currentCallback) {
            std::cout << "C++: Calling callback" << std::endl;
            currentCallback->execute();
        } else {
            std::cout << "C++: No callback set" << std::endl;
        }
    }
};