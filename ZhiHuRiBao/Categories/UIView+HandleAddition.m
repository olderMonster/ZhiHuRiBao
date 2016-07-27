//
//  UIView+HandleAddition.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "UIView+HandleAddition.h"

@implementation UIView (HandleAddition)

- (void)drawFilletLeft:(BOOL)isLeftFillet right:(BOOL)isRightFillet{
    if (!(isLeftFillet && isRightFillet)) {
        UIBezierPath *maskPath;
        if (isLeftFillet) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.frame.size.height * 0.5, self.frame.size.height * 0.5)];
        }
        if (isRightFillet) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.frame.size.height * 0.5, self.frame.size.height * 0.5)];
        }
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }

}


- (void)showBadgeValue:(NSString *)strBadgeValue
{
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
    item.badgeValue = strBadgeValue;
    NSArray *array = [[NSArray alloc] initWithObjects:item, nil];
    tabBar.items = array;
//    [item release];
//    [array release];
    //寻找
    for (UIView *viewTab in tabBar.subviews) {
        for (UIView *subview in viewTab.subviews) {
            NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
            if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
                [strClassName isEqualToString:@"_UIBadgeView"]) {
                //从原视图上移除
                [subview removeFromSuperview];
                //
                [self addSubview:subview];
                subview.frame = CGRectMake(self.frame.size.width-subview.frame.size.width, 0,
                                           subview.frame.size.width, subview.frame.size.height);
//                [tabBar release];
//                return subview;
            }
        }
    }
//    [tabBar release];
//    return nil;
}


- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)ce:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


@end
