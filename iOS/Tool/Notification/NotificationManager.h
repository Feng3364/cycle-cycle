//
//  NotificationManager.h
//  OCDemo
//
//  Created by Felix on 2023/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, NotificationLogLevel) {
    NotificationLogLevelForNone      = 0,
    NotificationLogLevelForObservers = 1 << 0,
    NotificationLogLevelForNames     = 1 << 1,
    NotificationLogLevelForAll       = 0xFFFFFFFF,
};

#define AddObserver(aName, anObject, aCallback) [[NotificationManager sharedManager] addObserver:[NSString stringWithFormat:@"%p", self] name:aName object:anObject observeCallback:aCallback];
#define PostObserver(aName, anObject, aParam)   [[NotificationManager sharedManager] postNotificationName:aName object:anObject userInfo:aParam];
#define RemoveObserver()                        [[NotificationManager sharedManager] removeObserver:[NSString stringWithFormat:@"%p", self]];
#define RemoveObserverByName(aName, anObject)   [[NotificationManager sharedManager] removeObserver:[NSString stringWithFormat:@"%p", self] name:aName object:anObject];

typedef void (^ObserveCallback)(NSNotification *noti);
typedef void (^VoidCallback)(void);

@interface NotificationManager : NSObject

@property (nonatomic, assign) NotificationLogLevel logLevel;

// 单例
+ (instancetype)sharedManager;

/*
 * 添加通知（与removeObserver相对应）
 *
 * @param anObserver 订阅对象地址
 * @param aName 通知名称
 * @param anObject 消息发送者
 * @param aCallback 订阅回调
 **/
- (void)addObserver:(NSString *)anObserver
                     name:(NSNotificationName)aName
                   object:(nullable NSString *)anObject
          observeCallback:(ObserveCallback)aCallback;

// 发送通知
- (void)postNotification:(NSNotificationName)aName;

// 发送【指定消息发送者】的通知
- (void)postNotificationName:(NSNotificationName)aName
                      object:(nullable NSString *)anObject;

// 发送【指定消息发送者+带参数】的通知
- (void)postNotificationName:(NSNotificationName)aName
                      object:(nullable NSString *)anObject
                    userInfo:(nullable NSDictionary *)aUserInfo;

/*
 * 移除通知（与addObserver相对应）
 *
 * @param anObserver 订阅对象地址
 **/
- (void)removeObserver:(NSString *)anObserver;

/*
 * 移除通知（与addObserver相对应）
 *
 * @param anObserver 订阅对象地址
 * @param aName 通知名称
 * @param anObject 消息发送者
 **/
- (void)removeObserver:(NSString *)anObserver
                  name:(NSNotificationName)aName
                object:(NSString *)anObject;

@end

NS_ASSUME_NONNULL_END
