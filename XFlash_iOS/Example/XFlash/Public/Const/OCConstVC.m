//
//  OCConstVC.m
//  XFlash_Example
//
//  Created by Felix on 2023/7/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import "OCConstVC.h"
#import <XFlash/XFlash-Swift.h>

@interface OCConstVC ()

@end

@implementation OCConstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"********************屏幕尺寸********************");
    NSLog(@"屏幕坐标:%@", NSStringFromCGRect(XFlash.bounds));
    NSLog(@"屏幕宽:%f", XFlash.screenWidth);
    NSLog(@"屏幕高:%f", XFlash.screenHeight);
    NSLog(@"状态栏高度:%f", XFlash.statusBarHeight);
    NSLog(@"导航栏高度:%f", XFlash.navBarHeight);
    NSLog(@"顶部导航栏高度:%f", XFlash.topHeight);
    NSLog(@"底部安全区域高度:%f", XFlash.bottomHeight);
    NSLog(@"tabBar高度:%f", XFlash.tabBarHeight);
    NSLog(@"不带tabBar且有导航栏的页面高度:%f", XFlash.mainHeight);
    NSLog(@"带tabBar且有导航栏的页面高度:%f", XFlash.mainTabBarHeight);
    
    NSLog(@"********************应用信息********************");
    NSLog(@"应用名:%@", XFlash.displayName);
    NSLog(@"应用标识:%@", XFlash.bundleID);
    NSLog(@"应用build:%@", XFlash.buildNumber);
    NSLog(@"应用version:%@", XFlash.versionNumber);
    NSLog(@"是否刘海屏:%d", XFlash.iPhoneX);
    NSLog(@"应用单例:%@", XFlash.application);
    NSLog(@"主窗口:%@", XFlash.keyWindow);
    
    NSLog(@"********************设备信息********************");
    NSLog(@"设备名称:%@", XFlash.deviceName);
    NSLog(@"系统版本:%@", XFlash.systemVersion);
    NSLog(@"设备方向:%ld", (long)XFlash.deviceOrientation);
    NSLog(@"设备是否水平:%d", XFlash.isLandscape);
}

@end
