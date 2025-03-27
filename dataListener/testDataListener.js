const pkg = require('./build/Release/myPackage');

console.log(pkg);

class MyDataListener extends pkg.DataReaderListener {
    constructor() {
        super();
    }
    on_data_available(reader) {
        console.log('Data received:', reader);
        super.on_data_available(reader);
    }
}

const myDataListener = new MyDataListener();
const dataReader = new pkg.DataReader();
dataReader.simulateDataAvailable(myDataListener);