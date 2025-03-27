%{
#include "dataReader.h"
#include "dataReaderListener.h"
#include <v8.h>
%}

// Include necessary SWIG helpers
%include "std_string.i"

// Inline proxy mechanism
%inline %{
    class JavaScriptDataReaderListenerWrapper : public DataReaderListener {
    private:
        v8::Persistent<v8::Object> jsObject;
        v8::Isolate* isolate;
    
    public:
        JavaScriptDataReaderListenerWrapper(v8::Isolate* _isolate, v8::Local<v8::Object> jsListenerObj) 
            : isolate(_isolate) {
            // Store the JavaScript listener object
            jsObject.Reset(isolate, jsListenerObj);
        }
    
        ~JavaScriptDataReaderListenerWrapper() {
            jsObject.Reset();
        }
    
        // Override the virtual method to dispatch to JavaScript
        virtual void on_data_available(DataReader* reader) override {
            v8::Isolate::Scope isolateScope(isolate);
            v8::HandleScope handleScope(isolate);
    
            // Get the persistent object
            v8::Local<v8::Object> localObj = v8::Local<v8::Object>::New(isolate, jsObject);
            
            // Find the on_data_available method
            v8::Local<v8::Context> context = isolate->GetCurrentContext();
            v8::Local<v8::Value> methodVal = localObj->Get(context, 
                v8::String::NewFromUtf8(isolate, "on_data_available").ToLocalChecked()
            ).ToLocalChecked();
    
            // Check if it's a function
            if (methodVal->IsFunction()) {
                v8::Local<v8::Function> callback = v8::Local<v8::Function>::Cast(methodVal);
    
                // Prepare arguments
                const int argc = 1;
                v8::Local<v8::Value> argv[argc] = { 
                    SWIG_NewPointerObj(isolate, reader, SWIGTYPE_p_DataReader, 0)
                };
    
                // Invoke the callback
                v8::TryCatch tryCatch(isolate);
                callback->Call(context, localObj, argc, argv);
    
                // Handle potential exceptions
                if (tryCatch.HasCaught()) {
                    v8::String::Utf8Value exception(isolate, tryCatch.Exception());
                    printf("JavaScript exception: %s\n", *exception);
                }
            }
        }
    };
    %}

// Wrap the original classes
%include "dataReader.h"
%include "dataReaderListener.h"