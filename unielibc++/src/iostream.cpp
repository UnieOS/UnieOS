#include "iostream"
#include "internal_unistd.h"
// written by llms
// caution

namespace std {
    ostream cout;

    ostream& ostream::operator<<(const char* s) {
        unsigned long len = 0;
        while (s[len] != '\0') {
            len++;
        }
        write(1, s, len);
        return *this;
    }

    ostream& ostream::operator<<(const string& s) {
        write(1, s.c_str(), s.size());
        return *this;
    }

    ostream& ostream::operator<<(ostream& (*manip)(ostream&)) {
        return manip(*this);
    }

    ostream& endl(ostream& os) {
        os << "\n";
        return os;
    }
}

