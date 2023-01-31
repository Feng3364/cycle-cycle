//
//  AliveThread.h
//  OCDemo
//
//  Created by Felix on 2023/1/21.
//

#import <Foundation/Foundation.h>

typedef void (^AliveThreadTask)(void);
@interface AliveThread : NSObject

/// 在当前子线程执行一个任务
- (void)executeTask:(AliveThreadTask)task;

/// 结束线程
- (void)stop;

@end
