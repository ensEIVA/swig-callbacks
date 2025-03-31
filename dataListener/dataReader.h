#pragma once
#include <string>

class DataReaderListener;
class DataReader
{
private:
    std::string message = "Hello, World!";
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
    std::string getMessage()
    {
        return message;
    }
};