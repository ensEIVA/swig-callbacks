{
    "targets": [
        {
            "target_name": "callback",
            "sources": [
                "callback.cpp",
                "callback_wrap.cxx"
            ],
            "include_dirs": [
                "<!(node -e \"require('node-addon-api')\")"
            ],
            "cflags!": ["-fno-exceptions"],
            "cflags_cc!": ["-fno-exceptions"],
            "defines": [
                "NAPI_DISABLE_CPP_EXCEPTIONS"
            ]
        }
    ]
}