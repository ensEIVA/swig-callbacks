const pkg = require('../build/Release/hello');

const obj = new pkg.Hello();

const emilsCallback = () => {
    console.log('--------Emil callback executed!');
};

const emilsCallback2 = (a) => {
    console.log('--------Emil callback executed!', a);
};

const cb = emilsCallback2(10);
let b = 2
obj.SetCallback(emilsCallback);
obj.SetCallbackWithArg(() => emilsCallback2(2));

obj.FireCallbacks(10, 500);

