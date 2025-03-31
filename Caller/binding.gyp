{
    "targets": [
        {
            "target_name": "Callback",
            "sources": [ "callback_wrap.cxx", "callback.cpp" ],
            "include_dirs": [
                "<!(node -e \"require('node-addon-api')\")",
                '.'
            ],
            "cflags!": ["-fno-exceptions"],
            "cflags_cc!": ["-fno-exceptions"],
            "defines": [
                "NAPI_DISABLE_CPP_EXCEPTIONS"
            ]
        }
    ]
}