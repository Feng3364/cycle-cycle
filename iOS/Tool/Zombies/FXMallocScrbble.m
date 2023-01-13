//
//  FXMallocScrbble.m
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#import "FXMallocScrbble.h"
#import "fishhook.h"
#import "malloc/malloc.h"

void *(*orig_malloc)(size_t __size);
void (*orig_free)(void * p);

void *_FXMalloc_(size_t __size) {
    void *p = orig_malloc(__size);
    memset(p, 0xAA, __size);
    return p;
}

void _FXFree_(void * p) {
    size_t size = malloc_size(p);
    memset(p, 0x55, size);
    orig_free(p);
}

@implementation FXMallocScrbble

+ (void)load {
    rebind_symbols((struct rebinding[2]){{"malloc", _FXMalloc_, (void *)&orig_malloc}, {"free", _FXFree_, (void *)&orig_free}}, 2);
}

@end
