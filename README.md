# swig-callbacks
Investigate the possibility to use callback with SWIG

1. Downloaded SWIG from Download SWIG
2. Extract
3. Check if installed correctly, in cmd try ```swig --help```. You might need to incldue it in PATH

4. Create swig binding of c++ to javascript (node.js) ``` swig.exe -c++ -javascript -node .\master.i ```

5.  Might need to install node-addon-api first: ```npm i node-addon-api```.
6. Binding information inside binding.gyp file ```node-gyp rebuild```

7. Running example using node package ```node .\test.js``` 

