#include "string"
// written by llms
// caution

namespace std {
    string::string(const char* s) : _data(s), _size(0) {
        while (s[_size] != '\0') {
            _size++;
        }
    }

    const char* string::c_str() const {
        return _data;
    }

    unsigned long string::size() const {
        return _size;
    }
}

