const example = require('./build/Release/myPackage');

// Create a data reader
const dataReader = new example.DataReader();
console.log(dataReader.getMessage());

// Create a JavaScript listener
const jsListener1 = new example.JSCallbackDataReaderListener();
const testCallback1 = (reader) => {
    console.log(reader.getMessage() + '--------jsListener1 callback executed!');
};
jsListener1.SetCallback_on_data_available(() => testCallback1(dataReader));

const jsListener2 = new example.JSCallbackDataReaderListener();
const testCallback2 = (reader) => {
    console.log(reader.getMessage() + '--------jsListener2 callback executed!');
};
jsListener2.SetCallback_on_data_available(() => testCallback2(dataReader));

// Use the listener with the data reader
dataReader.simulateDataAvailable(jsListener1);
dataReader.simulateDataAvailable(jsListener2);
