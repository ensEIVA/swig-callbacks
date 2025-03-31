const addon = require('../build/Release/hello');

const obj = new addon.Hello();

const jsCallback = (a) => {
    console.log('--------js callback executed!', a);
};
obj.SetCallbackWithArg(() => jsCallback(2));
obj.FireCallbacks(10, 500);

