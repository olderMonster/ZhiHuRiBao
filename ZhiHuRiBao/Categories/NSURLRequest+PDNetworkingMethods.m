//
//  NSURLRequest+PDNetworkingMethods.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "NSURLRequest+PDNetworkingMethods.h"
#import <objc/runtime.h>
static void *AIFNetworkingRequestParams;
@implementation NSURLRequest (PDNetworkingMethods)
//利用runtime动态添加属性
- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &AIFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, &AIFNetworkingRequestParams);
}

@end
