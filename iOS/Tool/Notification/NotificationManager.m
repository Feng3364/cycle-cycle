//
//  NotificationManager.m
//  OCDemo
//
//  Created by Felix on 2023/1/25.
//

#import "NotificationManager.h"

@interface NotificationManager ()
//@{
//    @"订阅者内存地址1": @[
//        @{@"name": @"通知名1", @"object": @"通知者1", @"index": @"1"},
//        @{@"name": @"通知名2", @"object": @"通知者2", @"index": @"2"}
//    ],
//    @"订阅者内存地址2": @[
//        @{@"name": @"通知名3", @"object": @"通知者3", @"index": @"3"},
//        @{@"name": @"通知名4", @"object": @"通知者4", @"index": @"4"}
//    ]
//}
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *observers;
//@{
//    @"通知名1": @[
//        @{@"通知者1": @"回调1"},
//        @{@"通知者2": @"回调2"}
//    ],
//    @"通知名2": @[
//        @{@"通知者3": @"回调3"},
//        @{@"通知者4": @"回调4"}
//    ],
//}
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *byIndexDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *byObjectDict;
@end

@implementation NotificationManager

#pragma mark - Life Cycle

+ (instancetype)sharedManager {
    static NotificationManager *manager = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NotificationManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.observers = @{}.mutableCopy;
        self.byIndexDict = @{}.mutableCopy;
        self.byObjectDict = @{}.mutableCopy;
        self.logLevel = NotificationLogLevelForNone;
    }
    return self;
}

#pragma mark - Add

- (void)addObserver:(NSString *)anObserver name:(NSNotificationName)aName object:(NSString *)anObject observeCallback:(ObserveCallback)aCallback {
    // 订阅标记符
    NSString *result = [self addObserver:aName object:anObject observeCallback:aCallback];
    
    NSDictionary *observerDict;
    if (!anObject) {
        observerDict = @{@"name": aName, @"index": result};
    } else {
        observerDict = @{@"name": aName, @"object": anObject, @"index": result};
    }
    
    // 关联【内存地址-通知】
    NSMutableArray *curObserver = [self.observers valueForKey:anObserver];
    if (!curObserver) {
        curObserver = @[observerDict].mutableCopy;
        [self.observers addEntriesFromDictionary:@{anObserver: curObserver}];
    } else {
        [curObserver addObject:observerDict];
    }
    
    // 打印
    NSString *info = [NSString stringWithFormat:@"添加订阅后的observers：%@", self.observers];
    [self logObservers:info];
}

- (NSString *)addObserver:(NSNotificationName)aName object:(NSString *)anObject observeCallback:(ObserveCallback)aCallback {
    return !anObject ?
    [self addIndexObserver:aName observeCallback:aCallback] :
    [self addObjectObserver:aName object:anObject observeCallback:aCallback];
}

- (NSString *)addIndexObserver:(NSNotificationName)aName observeCallback:(ObserveCallback)aCallback {
    NSMutableArray *nameArr = [self.byIndexDict valueForKey:aName];
    
    // 创造新信息
    NSString *indexStr = [NSString stringWithFormat:@"%zd", nameArr.count];
    NSMutableDictionary *newDict = @{indexStr: aCallback}.mutableCopy;
    
    if (!nameArr) {
        nameArr = @[newDict].mutableCopy;
        [self.byIndexDict addEntriesFromDictionary:@{aName: nameArr}.mutableCopy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveIndexNotification:)
                                                     name:aName
                                                   object:nil];
    } else {
        [nameArr addObject:newDict];
    }
    
    NSString *info = [NSString stringWithFormat:@"添加后订阅的index通知：%@", self.byIndexDict];
    [self logNames:info];
    return indexStr;
}

- (NSString *)addObjectObserver:(NSNotificationName)aName object:(NSString *)anObject observeCallback:(ObserveCallback)aCallback {
    NSMutableArray *nameArr = [self.byObjectDict valueForKey:aName];
    NSString *indexStr = [NSString stringWithFormat:@"%zd", nameArr.count];
    NSMutableDictionary *newDict = @{anObject: aCallback, indexStr: indexStr}.mutableCopy;
    if (!nameArr) {
        // 初次创建name
        nameArr = @[newDict].mutableCopy;
        [self.byObjectDict addEntriesFromDictionary:@{aName: nameArr}.mutableCopy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveObjectNotification:)
                                                     name:aName
                                                   object:anObject];
    } else {
        // 添加新的object-回调
        [nameArr addObject:newDict];
        
        // 是否包含【同一接收者】（决定了是否要订阅）
        BOOL isContainObject = NO;
        for (NSDictionary *curDict in nameArr) {
            if ([curDict.allKeys containsObject:anObject]) {
                isContainObject = YES;
                break;
            }
        }
        
        if (!isContainObject) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveObjectNotification:)
                                                         name:aName
                                                       object:anObject];
        }
    }
    
    NSString *info = [NSString stringWithFormat:@"添加后订阅的object通知：%@", self.byObjectDict];
    [self logNames:info];
    return indexStr;
}

#pragma mark - Post

- (void)postNotification:(NSNotificationName)aName {
    [self postNotificationName:aName
                        object:NULL];
}

- (void)postNotificationName:(NSNotificationName)aName object:(NSString *)anObject {
    [self postNotificationName:aName
                        object:anObject
                      userInfo:NULL];
}

- (void)postNotificationName:(NSNotificationName)aName object:(NSString *)anObject userInfo:(NSDictionary *)aUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName
                                                        object:anObject
                                                      userInfo:aUserInfo];
}

#pragma mark - Remove

- (void)removeObserver:(NSString *)anObserver {
    NSMutableArray *curObserver = [self.observers valueForKey:anObserver];

    for (NSDictionary *dict in curObserver) {
        NSString *name = [dict valueForKey:@"name"];
        NSString *object = [dict valueForKey:@"object"];
        NSString *indexStr = [dict valueForKey:@"index"];
        if (!object) {
            [self removeIndexObserver:name indexStr:indexStr];
        } else {
            [self removeObjectObserver:name object:object indexStr:indexStr];
        }
    }

    [self.observers removeObjectForKey:anObserver];

    NSString *info = [NSString stringWithFormat:@"移除订阅后的observers：%@", self.observers];
    [self logObservers:info];
}

- (void)removeObserver:(NSString *)anObserver name:(NSNotificationName)aName object:(NSString *)anObject {
    NSMutableArray *curObserver = [self.observers valueForKey:anObserver];

    for (NSDictionary *dict in curObserver) {
        NSString *name = [dict valueForKey:@"name"];
        NSString *object = [dict valueForKey:@"object"];
        NSString *indexStr = [dict valueForKey:@"index"];
        if (![name isEqualToString:aName]) {
            continue;
        }
        
        if (object == NULL && anObject == NULL) {
            [self removeIndexObserver:name indexStr:indexStr];
        }
        if ([object isEqualToString:anObject]) {
            [self removeObjectObserver:name object:object indexStr:indexStr];
        }
    }

    [self.observers removeObjectForKey:anObserver];

    NSString *info = [NSString stringWithFormat:@"移除订阅后的observers：%@", self.observers];
    [self logObservers:info];
}

// private
- (void)removeIndexObserver:(NSNotificationName)aName indexStr:(NSString *)indexStr {
    NSMutableArray *nameArr = [self.byIndexDict valueForKey:aName];
    for (NSMutableDictionary *dict in nameArr) {
        if ([dict.allKeys containsObject:indexStr]) {
            [nameArr removeObject:dict];
        }
    }
    
    if (nameArr.count == 0) {
        [self.byIndexDict removeObjectForKey:aName];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:aName
                                                      object:nil];
    }
    
    NSString *info = [NSString stringWithFormat:@"移除后订阅的index通知：%@", self.byIndexDict];
    [self logNames:info];
}
// private
- (void)removeObjectObserver:(NSNotificationName)aName object:(NSString *)anObject indexStr:(NSString *)indexStr {
    NSMutableArray *nameArr = [self.byObjectDict valueForKey:aName];
    NSArray *temp = nameArr.copy;
    for (NSMutableDictionary *dict in temp) {
        NSArray *keys = dict.allKeys;
        if ([keys containsObject:anObject] && [keys containsObject:indexStr]) {
            [nameArr removeObject:dict];
        }
    }
    
    if (nameArr.count == 0) {
        [self.byObjectDict removeObjectForKey:aName];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:aName
                                                      object:anObject];
    }
    
    NSString *info = [NSString stringWithFormat:@"移除后订阅的object通知：%@", self.byObjectDict];
    [self logNames:info];
}

#pragma mark - Private

- (void)receiveIndexNotification:(NSNotification *)notification {
    [self logNames:@"接收index通知"];
    id name = [notification valueForKey:@"name"];
    NSMutableArray *nameArr = [self.byIndexDict valueForKey:name];
    for (NSMutableDictionary *dict in nameArr) {
        ObserveCallback callback = dict.allValues.firstObject;
        if (callback) {
            callback(notification);
        }
    }
}

- (void)receiveObjectNotification:(NSNotification *)notification {
    [self logNames:@"接收object通知"];
    id name = [notification valueForKey:@"name"];
    id object = [notification valueForKey:@"object"];
    if (object) {
        NSMutableArray *nameArr = [self.byObjectDict valueForKey:name];
        for (NSMutableDictionary *dict in nameArr) {
            ObserveCallback callback = [dict valueForKey:object];
            if (callback) {
                callback(notification);
            }
        }
    }
}

#pragma mark - Print

- (void)logObservers:(NSString *)info {
    if (self.logLevel & NotificationLogLevelForObservers) {
        NSLog(@"%@", info);
    }
}

- (void)logNames:(NSString *)info {
    if (self.logLevel & NotificationLogLevelForNames) {
        NSLog(@"%@", info);
    }
}

@end
