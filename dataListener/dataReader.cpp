#include <chrono>
#include <thread>

#include "dataReader.h"
#include "dataReaderListener.h"

void DataReader::simulateDataAvailable(DataReaderListener *listener)
{
    for (int i = 0; i < 10; i++)
    {
        listener->on_data_available(this);
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }
}