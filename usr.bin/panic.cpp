#include <iostream>
#include <string>
#include <unistd.h>
// written again by llms

using namespace std;

int main(int argc, char* argv[]) {
    cout << "\033[41m\033[37m";
    cout << "\033[2J\033[H";
    
    cout << "\n\n\n";
    cout << "                    KERNEL PANIC!\n\n";
    
    if (argc > 1) {
        cout << "Reason: " << argv[1] << "\n";
    } else {
        cout << "Reason: Unknown error\n";
    }
    
    cout << "\n\n";
    cout << "\033[0m";
    
    return 0;
}

