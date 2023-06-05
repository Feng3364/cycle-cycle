//
//  AliveThread.m
//  OCDemo
//
//  Created by Felix on 2023/1/21.
//

#import "AliveThread.h"

@interface LiveThread : NSThread
@end
@implementation LiveThread

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface AliveThread ()

@property (nonatomic,strong) LiveThread *liveThread;
@property (nonatomic, assign) BOOL stopped;

@end

@implementation AliveThread

- (instancetype)init {
    if (self = [super init]) {
        self.stopped = NO;
        
        __weak typeof(self) weakSelf = self;
        self.liveThread = [[LiveThread alloc] initWithBlock:^{
            NSLog(@"------常驻线程开启-------");
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"------常驻线程结束------");
        }];
        [self.liveThread start];
    }
    return self;
}


- (void)executeTask:(AliveThreadTask)task {
    if (!self.liveThread || !task) return;
    
    [self performSelector:@selector(realizeTask:) onThread:self.liveThread withObject:task waitUntilDone:NO];
}

- (void)realizeTask:(AliveThreadTask)task {
    task();
}

- (void)stop {
    if (!self.liveThread) return;
    [self performSelector:@selector(liveThreadStop) onThread:self.liveThread withObject:nil waitUntilDone:YES];
}


- (void)liveThreadStop{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.liveThread = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self stop];
}

@end
