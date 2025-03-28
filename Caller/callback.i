%module callback

%{
#include "callback.h"
%}

// Enable directors for polymorphic behavior
%feature("director") Callback;

// Include the header
%include "callback.h"