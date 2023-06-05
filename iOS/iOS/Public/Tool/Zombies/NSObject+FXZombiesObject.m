//
//  NSObject+FXZombiesObject.m
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#import "NSObject+FXZombiesObject.h"
#import "FXSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (FXZombiesObject)

+ (void)load {
    [FXSwizzle fx_methodSwizzlingWithClass:[self class]
                                    oriSEL:NSSelectorFromString(@"dealloc")
                               swizzledSEL:NSSelectorFromString(@"__FXDealloc_zombie")];
}

- (void)__FXDealloc_zombie {
    const char *className = object_getClassName(self);
    char *zombieClassName = NULL;
    asprintf(&zombieClassName, "_FXZombie_%s", className);
    Class zombieClass = objc_getClass(zombieClassName);
    if (zombieClass == Nil) {
        zombieClass = objc_duplicateClass(objc_getClass("_FXZombie_"), zombieClassName, 0);
    }
    // BuildPhases将当前文件标记成MRC——-fno-objc-arc
    objc_destructInstance(self);
    object_setClass(self, zombieClass);
    if (zombieClassName != NULL) {
        free(zombieClassName);
    }
}

@end
