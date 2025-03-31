%{
#include "dataReader.h"
#include "dataReaderListener.h"
#include <v8.h>
    
// Global persistent callback storage
v8::Persistent<v8::Function>* g_jsCallback = nullptr;

void runJSCallbackArg(DataReader* reader) {
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
        fprintf(stderr, "JavaScript exception: %s\n", *exception);
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

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    v8::HandleScope handle_scope(isolate);

    g_jsCallback = new v8::Persistent<v8::Function>(isolate, v8::Local<v8::Function>::Cast(args[0]));
    
    $1 = runJSCallbackArg;
}

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
        JSCallbackDataReaderListener()  {};
    
        // Override the virtual method
        virtual void on_data_available(DataReader* reader) override {
            if (m_callback) {
                DataReaderListener::on_data_available(reader);
                m_callback(reader);
            } else {
                DataReaderListener::on_data_available(reader);
            }
        }
        
        // Static methods to manage callbacks
        void SetCallback_on_data_available(std::function<void(DataReader*)> callback) {
            m_callback = callback;
        }    
    };
%}

