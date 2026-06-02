#ifndef UNIELIBCXX_INTERNAL_UNISTD_H
#define UNIELIBCXX_INTERNAL_UNISTD_H
// written by llms
// caution

extern "C" {
    long write(int fd, const void *buf, unsigned long count);
}

#endif

