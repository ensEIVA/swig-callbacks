%module(directors="1") myPackage
%include "std_string.i"

// Import individual interface files
// SWIG will process these files as part of the master module
%include "dataReader.i"
%include "dataReaderListener.i"