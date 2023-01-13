//
//  _FXZombie_.m
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#import "_FXZombie_.h"
#import "FXLogger.h"

@implementation _FXZombie_

- (id)forwardingTargetForSelector:(SEL)aSelector {
    FXLog(@"[%@ %@]:向已经dealloc的对象发送了消息", [NSStringFromClass(self.class) componentsSeparatedByString:@"_FXZombie_"].lastObject, NSStringFromSelector(aSelector));
    // 结束当前线程
    abort();
}

@end
