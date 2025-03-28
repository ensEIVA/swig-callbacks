const pkg = require('./build/Release/callback');

// Base Callback class (equivalent to C++ base class)
class NormalCallback extends pkg.Callback {
    constructor() {
        super();
        console.log("JS: NormalCallback constructor");
    }

    execute() {
        console.log("JS: Executing normal callback");
    }
}

// Custom JavaScript-implemented callback
class CustomCallback extends pkg.Callback {
    constructor() {
        super();
        console.log("JS: CustomCallback constructor");
    }

    execute() {
        console.log("JS: Executing custom JavaScript callback");
    }
}

// Main execution
function runCallbackDemo() {
    console.log("JS: Creating Caller");
    const caller = new pkg.Caller();

    // console.log("\nJS: Demonstrating Normal Callback");
    // const normalCallback = new NormalCallback();
    // caller.setCallback(normalCallback);
    // caller.call();
    // caller.resetCallback();

    console.log("\nJS: Demonstrating Custom Callback");
    const customCallback = new CustomCallback();
    caller.setCallback(customCallback);
    caller.call();
    caller.resetCallback();
}

// Run the demo
runCallbackDemo();
console.log("\nJS: Callback demonstration complete");