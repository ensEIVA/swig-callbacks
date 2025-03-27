%module(directors="1") myPackage


// Import individual interface files
// SWIG will process these files as part of the master module
%include "dataReader.i"
%include "dataReaderListee.i"