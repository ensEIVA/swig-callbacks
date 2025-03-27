%module hello

%{
#include "hello.h"
#include <functional>
#include <memory>
#include <string>
#include <node.h>
#include <v8.h>

// Global persistent callback storage
v8::Persistent<v8::Function>* g_jsCallback = nullptr;

void runJSCallback() {

    if (!g_jsCallback) {
        return;
    }

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);
    
    v8::Local<v8::Context> context = isolate->GetCurrentContext();
    v8::Local<v8::Function> cb = v8::Local<v8::Function>::New(isolate, *g_jsCallback);
    
    if (cb.IsEmpty()) {
        return;
    }

    v8::TryCatch try_catch(isolate);
    
    cb->Call(context, context->Global(), 0, nullptr);
    
    if (try_catch.HasCaught()) {
        v8::String::Utf8Value exception(isolate, try_catch.Exception());
    }
}

void runJSCallbackArg(int arg) {
    if (!g_jsCallback) {
        return;
    }

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);
    
    v8::Local<v8::Context> context = isolate->GetCurrentContext();
    v8::Local<v8::Function> cb = v8::Local<v8::Function>::New(isolate, *g_jsCallback);
    
    if (cb.IsEmpty()) {
        return;
    }

    v8::TryCatch try_catch(isolate);
    
    // Create an argument to pass
    v8::Local<v8::Value> argv[1];
    argv[0] = v8::Integer::New(isolate, arg);
    
    cb->Call(context, context->Global(), 1, argv);

    if (try_catch.HasCaught()) {
        v8::String::Utf8Value exception(isolate, try_catch.Exception());
        fprintf(stderr, "JavaScript exception: %s\n", *exception);
    }
}
%}

// Custom SWIG typemap to handle JavaScript callbacks
%typemap(in) std::function<void()> {

    if (args.Length() == 0 || !args[0]->IsFunction()) {
        SWIG_exception_fail(SWIG_TypeError, "Expected a JavaScript function");
    }

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);
    
    // Free any previous callback
    // if (g_jsCallback) {
    //     std::cout << "SWIG typemap: Cleaning previous callback..." << std::endl;
    //     g_jsCallback->Reset();
    //     delete g_jsCallback;
    // }
    
    // Store the new callback
    g_jsCallback = new v8::Persistent<v8::Function>(isolate, v8::Local<v8::Function>::Cast(args[0]));
    
    // Set the C++ callback to our wrapper function
    $1 = runJSCallback;
}

%typemap(in) std::function<void(int)> {
    if (args.Length() == 0 || !args[0]->IsFunction()) {
        SWIG_exception_fail(SWIG_TypeError, "Expected a JavaScript function");
    }

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);

    g_jsCallback = new v8::Persistent<v8::Function>(isolate, v8::Local<v8::Function>::Cast(args[0]));
    
    $1 = runJSCallbackArg;
}

// %typemap(freearg) std::function<void()> {
//     std::cout << "SWIG typemap: Freeing callback..." << std::endl;
//     if (g_jsCallback) {
//         g_jsCallback->Reset();
//         delete g_jsCallback;
//         g_jsCallback = nullptr;
//     }
// }


// Standard SWIG includes
%include "std_string.i"
%include "hello.h"