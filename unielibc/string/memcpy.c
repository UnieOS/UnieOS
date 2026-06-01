#include "string.h"
// written by llms
// caution

void *memcpy(void *dest, const void *src, size_t n) {
    char *d = (char *)dest;
    const char *s = (const char *)src;

    while (n >= sizeof(unsigned long)) {
        *(unsigned long *)d = *(const unsigned long *)s;
        d += sizeof(unsigned long);
        s += sizeof(unsigned long);
        n -= sizeof(unsigned long);
    }

    while (n > 0) {
        *d = *s;
        d++;
        s++;
        n--;
    }

    return dest;
}

