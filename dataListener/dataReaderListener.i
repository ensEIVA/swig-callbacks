%{
#include "dataReaderListener.h"
%}

%include "dataReaderListener.h"

// Custom SWIG typemap to handle JavaScript callbacks
%typemap(in) v8::Local<v8::Function> jsCallback {
    if (!$input->IsFunction()) {
        SWIG_exception_fail(SWIG_TypeError, "Expected a JavaScript function");
    }
    $1 = v8::Local<v8::Function>::Cast($input);
}

// Add our extension functions
%inline %{
    #include "dataReader.h"
    #include "dataReaderListener.h"
    #include <v8.h>

    // Improved listener for JavaScript callbacks
    class JSCallbackDataReaderListener : public DataReaderListener {
    private:
        v8::Isolate* m_isolate;
        v8::Persistent<v8::Function> m_callback_on_data_available;

    public:
        JSCallbackDataReaderListener() : m_isolate(nullptr) {}
        
        virtual ~JSCallbackDataReaderListener() {
            if (!m_callback_on_data_available.IsEmpty()) {
                m_callback_on_data_available.Reset();
            }
        }
    
        // Override the virtual method
        virtual void on_data_available(DataReader* reader) override {
            // Call the base implementation
            DataReaderListener::on_data_available(reader);
            
            // Call the JavaScript callback if set
            if (!m_callback_on_data_available.IsEmpty() && m_isolate) {
                v8::HandleScope handle_scope(m_isolate);
                v8::Local<v8::Context> context = m_isolate->GetCurrentContext();
                v8::Local<v8::Function> callback = v8::Local<v8::Function>::New(m_isolate, m_callback_on_data_available);
                
                v8::TryCatch try_catch(m_isolate);
                
                // Call the JavaScript function
                // You could pass reader as argument if needed
                callback->Call(context, context->Global(), 0, nullptr);
                
                if (try_catch.HasCaught()) {
                    v8::String::Utf8Value exception(m_isolate, try_catch.Exception());
                    fprintf(stderr, "JavaScript callback exception: %s\n", *exception);
                }
            }
        }
        
        // Method to set the callback - now takes a V8 function directly
        void SetCallback_on_data_available(v8::Local<v8::Function> jsCallback) {
            // Clear any existing callback
            if (!m_callback_on_data_available.IsEmpty()) {
                m_callback_on_data_available.Reset();
            }
            
            // Store the new callback
            m_isolate = v8::Isolate::GetCurrent();
            m_callback_on_data_available.Reset(m_isolate, jsCallback);
        }
    };
%}