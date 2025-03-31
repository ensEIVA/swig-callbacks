const addon = require("./build/Release/Callback");

class CustomCallback extends addon.Callback {
  constructor() {
    super();
    console.log("JS: CustomCallback constructor");
  }
  
  run() {
    console.log("JS: CustomCallback run method called");
  }
}

console.log("JS: Creating Caller");
const caller = new addon.Caller();
const customCallback = new CustomCallback();

caller.call(customCallback);

