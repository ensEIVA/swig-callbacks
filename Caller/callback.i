%module Callback

%{
#include "callback.h"
%}

// Enable director feature for the Callback class
%feature("director") Callback;

// Include standard SWIG JavaScript typemaps
%include "std_string.i"

// Include the headers
%include "callback.h"