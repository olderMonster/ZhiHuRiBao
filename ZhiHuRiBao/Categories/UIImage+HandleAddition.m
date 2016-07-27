//
//  UIImage+HandleAddition.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "UIImage+HandleAddition.h"

@implementation UIImage (HandleAddition)
- (UIImage *)scalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
