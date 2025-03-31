// callback.js
const pkg = require("./build/Release/callback");

class CustomCallback extends pkg.Callback {
  constructor() {
    super();
    console.log("JS: CustomCallback constructor");
  }
  
  run() {
    console.log("JS: Executing CUSTOM JavaScript callback");
  }
}

console.log("JS: Creating Caller");
const caller = new pkg.Caller();
const customCallback = new CustomCallback();

// Pass the entire callback object, not just the method
caller.setCallback(customCallback);
caller.call();
caller.resetCallback();