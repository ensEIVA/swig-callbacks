const reader = require('./build/Release/myPackage');

console.log(reader);

// Create a data reader
const dataReader = new reader.DataReader();
console.log(dataReader.getMessage());

// Create a JavaScript listener
const jsListener = new reader.JSCallbackDataReaderListener();
const testCallback = (r) => {
    console.log(r.getMessage() + '--------JS callback executed!');
};
jsListener.SetCallback_on_data_available(() => testCallback(dataReader));

const jsListenerBis = new reader.JSCallbackDataReaderListener();
const testCallbackBis = (r) => {
    console.log(r.getMessage() + '--------bis executed!');
};
jsListenerBis.SetCallback_on_data_available(() => testCallbackBis(dataReader));

// Use the listener with the data reader
dataReader.simulateDataAvailable(jsListener);
dataReader.simulateDataAvailable(jsListenerBis);
