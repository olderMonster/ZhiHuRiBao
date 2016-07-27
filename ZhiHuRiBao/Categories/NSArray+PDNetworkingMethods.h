//
//  NSArray+PDNetworkingMethods.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PDNetworkingMethods)

//将数组中的内容俺按字母排序后转成字符串
- (NSString *)PD_paramsString;

- (NSString *)PD_jsonString;

@end
