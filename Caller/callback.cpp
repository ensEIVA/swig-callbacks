#include "callback.h"
#include <iostream>

void Caller::call(Callback* cb) {
  if (cb) {
    std::cout << "C++ Caller::call: invoking run()..." << std::endl;
    cb->run(); // This will call the JS version if cb points to a JS object
    std::cout << "C++ Caller::call: run() finished." << std::endl;
  } else {
    std::cout << "C++ Caller::call: callback object is null." << std::endl;
  }
}