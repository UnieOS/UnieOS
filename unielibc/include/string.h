#ifndef UNIELIBC_STRING_H
#define UNIELIBC_STRING_H
// written by llms
// caution

typedef unsigned long size_t;

size_t strlen(const char *s);
void *memcpy(void *dest, const void *src, size_t n);
long write(int fd, const void *buf, size_t count);

#endif
