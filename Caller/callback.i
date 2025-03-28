%module(directors="1") callback
%{
#include "callback.h"
%}

// Ensure director feature is explicitly applied
%feature("director") Callback;

// Include the header
%include "callback.h"