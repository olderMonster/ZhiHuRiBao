//
//  UIView+HandleAddition.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HandleAddition)

@property (nonatomic)CGFloat centerY;
@property (nonatomic)CGFloat height;

- (void)drawFilletLeft:(BOOL)isLeftFillet right:(BOOL)isRightFillet;
- (void)showBadgeValue:(NSString *)strBadgeValue;
@end
