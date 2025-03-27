#pragma once

class DataReaderListener;
class DataReader
{
public:
    /**
     * @brief Constructor
     */
    DataReader()
    {
    }

    /**
     * @brief Destructor
     */
    virtual ~DataReader()
    {
    }

    void simulateDataAvailable(DataReaderListener *listener);
};