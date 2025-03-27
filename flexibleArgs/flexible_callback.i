%module flexiblehello

%{
#include "flexible_callback.h"
#include <node.h>
#include <v8.h>

// Global callback storage
class GlobalCallbackManager {
public:
    static v8::Persistent<v8::Function>* currentCallback;

    static void invokeJSCallback() {
        if (!currentCallback) return;

        v8::Isolate* isolate = v8::Isolate::GetCurrent();
        v8::HandleScope handle_scope(isolate);
        
        v8::Local<v8::Context> context = isolate->GetCurrentContext();
        v8::Local<v8::Function> cb = v8::Local<v8::Function>::New(isolate, *currentCallback);
        
        if (cb.IsEmpty()) return;

        v8::TryCatch try_catch(isolate);
        
        // Call with no arguments
        cb->Call(context, context->Global(), 0, nullptr);

        if (try_catch.HasCaught()) {
            v8::String::Utf8Value exception(isolate, try_catch.Exception());
            fprintf(stderr, "JavaScript exception: %s\n", *exception);
        }
    }
};

// Initialize static member
v8::Persistent<v8::Function>* GlobalCallbackManager::currentCallback = nullptr;
%}

%typemap(in) std::function<void()> {
    if (!args[0]->IsFunction()) {
        SWIG_exception_fail(SWIG_TypeError, "Expected a JavaScript function");
    }

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);

    // Clean up any previous callback
    if (GlobalCallbackManager::currentCallback) {
        delete GlobalCallbackManager::currentCallback;
    }

    // Store the new callback
    GlobalCallbackManager::currentCallback = new v8::Persistent<v8::Function>(
        isolate, v8::Local<v8::Function>::Cast(args[0])
    );
    
    // Set the callback to the C++ function that will invoke the JS callback
    $1 = GlobalCallbackManager::invokeJSCallback;
}

%typemap(freearg) std::function<void()> {
    if (GlobalCallbackManager::currentCallback) {
        delete GlobalCallbackManager::currentCallback;
        GlobalCallbackManager::currentCallback = nullptr;
    }
}