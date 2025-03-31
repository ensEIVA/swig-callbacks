%{
#include "dataReader.h"
#include "dataReaderListener.h"
#include <v8.h>
#include <map>
#include <memory>

// Store callbacks in a map keyed by listener instance
std::map<void*, std::shared_ptr<v8::Persistent<v8::Function>>> g_callbackMap;

void runJSCallbackArg(DataReader* reader, void* listenerPtr) {
    // Find the callback for this listener instance
    auto it = g_callbackMap.find(listenerPtr);
    if (it == g_callbackMap.end() || !it->second) {
        return;
    }

    auto& callback = it->second;
    
    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);
    
    v8::Local<v8::Context> context = isolate->GetCurrentContext();
    v8::Local<v8::Function> cb = v8::Local<v8::Function>::New(isolate, *callback);
    
    if (cb.IsEmpty()) {
        return;
    }

    v8::TryCatch try_catch(isolate);

    // Call the JavaScript function
    // Note: We could pass the reader as an argument if needed
    cb->Call(context, context->Global(), 0, nullptr);

    if (try_catch.HasCaught()) {
        v8::String::Utf8Value exception(isolate, try_catch.Exception());
        fprintf(stderr, "JavaScript exception: %s\n", *exception);
    }
}

// Helper function to register a callback for a specific listener instance
void registerCallback(void* listenerPtr, v8::Local<v8::Function> callback) {
    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    
    // Create a persistent handle to the callback function
    auto persistent = std::make_shared<v8::Persistent<v8::Function>>(
        isolate, callback);
    
    // Store in our map
    g_callbackMap[listenerPtr] = persistent;
}

// Helper function to unregister a callback
void unregisterCallback(void* listenerPtr) {
    auto it = g_callbackMap.find(listenerPtr);
    if (it != g_callbackMap.end()) {
        it->second->Reset();
        g_callbackMap.erase(it);
    }
}
%}

// Include the original headers
%include "dataReaderListener.h"
%include "dataReader.h"

// Custom SWIG typemap to handle JavaScript callbacks
%typemap(in) std::function<void(DataReader*)> {
    if (args.Length() == 0 || !args[0]->IsFunction()) {
        SWIG_exception_fail(SWIG_TypeError, "Expected a JavaScript function");
    }

    // Get the 'this' pointer from the info
    void* listenerPtr = nullptr;
    int res = SWIG_ConvertPtr(args.Holder(), &listenerPtr, SWIGTYPE_p_JSCallbackDataReaderListener, 0);
    if (!SWIG_IsOK(res)) {
        SWIG_exception_fail(SWIG_ERROR, "Could not get listener pointer");
    }
    
    // Register the callback for this listener instance
    registerCallback(listenerPtr, v8::Local<v8::Function>::Cast(args[0]));
    
    // Create a lambda that will call the right callback
    $1 = [listenerPtr](DataReader* reader) {
        runJSCallbackArg(reader, listenerPtr);
    };
}

// Add a destructor handler to clean up callbacks
%feature("destructor", "unregisterCallback($self);") JSCallbackDataReaderListener;

// Add our extension functions
%inline %{
    #include <functional>
    #include "dataReader.h"
    #include "dataReaderListener.h"

    // Simple proxy listener for JavaScript callbacks
    class JSCallbackDataReaderListener : public DataReaderListener {
    private:
        std::function<void(DataReader*)> m_callback;
    public:
        JSCallbackDataReaderListener() {}
        
        virtual ~JSCallbackDataReaderListener() {
            // Cleanup happens in the destructor handler
        }
    
        // Override the virtual method
        virtual void on_data_available(DataReader* reader) override {
            // Call the base implementation
            DataReaderListener::on_data_available(reader);
            
            // Call the JavaScript callback if set
            if (m_callback) {
                m_callback(reader);
            }
        }
        
        // Method to set the callback
        void SetCallback_on_data_available(std::function<void(DataReader*)> callback) {
            m_callback = callback;
        }    
    };
%}