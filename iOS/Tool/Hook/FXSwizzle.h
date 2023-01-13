//
//  FXSwizzle.h
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXSwizzle : NSObject

/// 交换指定类的实例方法
+ (void)fx_methodSwizzlingWithClass:(Class)cls
                             oriSEL:(SEL)oriSEL
                        swizzledSEL:(SEL)swizzledSEL;

@end

NS_ASSUME_NONNULL_END
