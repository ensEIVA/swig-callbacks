{
  "targets": [
    {
      "target_name": "hello",
      "sources": [
        "hello.cpp",
        "hello_wrap.cxx"
      ],
      "include_dirs": [
        "<!(node -e \"require('node-addon-api').include_dir\")",
        "include"
      ],
      "cflags!": ["-fno-exceptions"],
      "cflags_cc!": ["-fno-exceptions"],
      "defines": ["NAPI_DISABLE_CPP_EXCEPTIONS"],
      "conditions": [
        ["OS=='win'", {
          "msvs_settings": {
            "VCCLCompilerTool": {
              "ExceptionHandling": 1
            }
          }
        }]
      ]
    },
    {
      "target_name": "flex",
      "sources": [
        "flexible_callback.cpp",
        "flexible_callback_wrap.cxx"
      ],
      "include_dirs": [
        "<!(node -e \"require('node-addon-api').include_dir\")",
        "include"
      ],
      "cflags!": ["-fno-exceptions"],
      "cflags_cc!": ["-fno-exceptions"],
      "defines": ["NAPI_DISABLE_CPP_EXCEPTIONS"],
      "conditions": [
        ["OS=='win'", {
          "msvs_settings": {
            "VCCLCompilerTool": {
              "ExceptionHandling": 1
            }
          }
        }]
      ]
    }
  ]
}

