//
//  OCPopupView.m
//  XFlash_Example
//
//  Created by Felix on 2023/7/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import "OCPopupView.h"

@implementation OCPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
    }
    return self;
}

- (UIView *)supplyCustomPopupView {
    return self;
}

- (void)layoutWith:(UIView *)superV {
    CGFloat maxX = CGRectGetMaxX(superV.frame);
    CGFloat maxY = CGRectGetMaxY(superV.frame);
    self.frame = CGRectMake((maxX - 300) / 2, (maxY - 300) / 2, 300, 300);
}

@end
