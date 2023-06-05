//
//  FXSwizzle.m
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#import "FXSwizzle.h"
#import "FXLogger.h"
#import <objc/runtime.h>

@implementation FXSwizzle

+ (void)fx_methodSwizzlingWithClass:(Class)cls
                             oriSEL:(SEL)oriSEL
                        swizzledSEL:(SEL)swizzledSEL {
    if (!cls) FXLog(@"传入的交换类不能为空");
    
    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    if (!oriMethod) {
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd) {
            FXLog(@"方法未实现");
        }));
    }

    BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}

@end
