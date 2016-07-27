//
//  NSArray+PDNetworkingMethods.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "NSArray+PDNetworkingMethods.h"

@implementation NSArray (PDNetworkingMethods)

- (NSString *)PD_paramsString{
    NSMutableString *paramsString = [[NSMutableString alloc]init];
    
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    [sortedParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (paramsString.length == 0) {
            [paramsString appendFormat:@"%@",obj];
        }else{
            [paramsString appendFormat:@"&%@",obj];
        }
    }];
    return paramsString;
}

//数组转json
- (NSString *)PD_jsonString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
