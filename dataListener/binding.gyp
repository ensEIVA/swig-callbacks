{
  "targets": [
    {
      "target_name": "myPackage",
      "sources": [
        "dataReader.cpp",
        "myPackage_wrap.cxx"
      ],
      "include_dirs": [
        "<!(node -e \"require('node-addon-api').include_dir\")"
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

