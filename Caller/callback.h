// callback.h
#pragma once

class Callback {
public:
  virtual ~Callback() {}
  virtual void run() = 0; // Pure virtual function to be overridden
};

class Caller {
public:
    void call(Callback* cb);
};