#pragma once
#include <iostream>
class DataReader;

class DataReaderListener
{
public:
    /**
     * @brief Constructor
     */
    DataReaderListener()
    {
        std::cout << "DataReaderListener constructor" << std::endl;
    }

    /**
     * @brief Destructor
     */
    virtual ~DataReaderListener()
    {
    }

    /**
     * Virtual function to be implemented by the user containing the actions to be performed when new Data Messages are received.
     *
     * @param reader DataReader
     */
    virtual void on_data_available(
        DataReader *reader)
    {
        (void)reader;
        std::cout << "c++ on_data_avail" << std::endl;

    }
};
