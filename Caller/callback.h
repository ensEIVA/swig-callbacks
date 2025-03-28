/* File : callback.h */

#include <cstdio>
#include <iostream>

class Callback {
public:
	virtual ~Callback() { std::cout << "Callback::~Callback()" << std:: endl; }
	virtual void run() { std::cout << "c++ Callback::run()" << std::endl; }
};


class Caller {
private:
	Callback *_callback;
public:
	Caller(): _callback(0) {}
	~Caller() { delCallback(); }
	void delCallback() { delete _callback; _callback = 0; }
    void setCallback(Callback *cb) 
    { 
        std::cout << "Caller::setCallback()" << std::endl;
        if (cb) {
            std::cout << "Callback address: " << cb << std::endl;
            cb->run();
        } else {
            std::cout << "Callback is null" << std::endl;
        }
        delCallback(); 
        _callback = cb; 
    }
	void resetCallback() { _callback = 0; }
	void call() {  _callback->run(); }
};