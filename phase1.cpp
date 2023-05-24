#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>  // Included for atoi()
#include <iostream>
#include <string> // for string class


using namespace std;


void readAndStoreNumbers(const std::string& filename, string** arrays)
{
    std::ifstream file(filename.c_str());
    if (!file.is_open()) {
        std::cout << "Failed to open file: " << filename << std::endl;
        return;
    }
    
    std::string line;
    int arrayIndex = 0;
    int elementIndex = 0;
    
    while (std::getline(file, line)) {
        std::istringstream iss(line);
        std::string hexNumber;
        
        while (iss >> hexNumber && arrayIndex < 4) {
            // Convert hexadecimal string to integer
            //int number = std::strtol(hexNumber.c_str(), NULL, 16);
            
            string number = hexNumber;
            cout << number << endl;
            // Store number in the current array
            arrays[arrayIndex][elementIndex] = number;
            
            // Move to the next element in the array
            elementIndex++;
            
            // If the current array is full, move to the next array
            if (elementIndex == 256) {
                arrayIndex++;
                elementIndex = 0;
            }
        }
    }
    
    file.close();
}

int main()
{
    // Allocate memory for the four arrays on the heap
    string** arrays = new string*[4];
    for (int i = 0; i < 4; i++) {
        arrays[i] = new string[256];
    }
    
    // Read and store the numbers from the file
    readAndStoreNumbers("tables.dat", arrays);
    
    // Print the stored numbers for verification
    for (int i = 0; i < 4; i++) {
        std::cout << "Array " << i << ":" << std::endl;
        for (int j = 0; j < 256; j++) {
            std::cout << arrays[i][j] << " ";
        }
        std::cout << std::endl;
    }
    
    // Deallocate the memory for the arrays
    for (int i = 0; i < 4; i++) {
        delete[] arrays[i];
    }
    delete[] arrays;
    
    return 0;
}