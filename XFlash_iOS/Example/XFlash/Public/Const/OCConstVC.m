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
    
    NSLog(@"应用名:%@", XFlash.displayName);
    NSLog(@"唯一标识:%@", XFlash.bundleID);
    
    NSLog(@"屏幕尺寸:%@", NSStringFromCGRect(XFlash.bounds));
    NSLog(@"屏幕宽:%f", XFlash.screenWidth);
    NSLog(@"屏幕宽:%f", XFlash.screenHeight);
}

@end
