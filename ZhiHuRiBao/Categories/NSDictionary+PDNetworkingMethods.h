//
//  NSDictionary+PDNetworkingMethods.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PDNetworkingMethods)

- (NSString *)PD_urlParamsStringSignature:(BOOL)isForSignatire;

- (NSString *)PD_jsonString;

- (NSArray *)PD_transformedUrlParamsArraySignature:(BOOL)isForSignatire;

@end
