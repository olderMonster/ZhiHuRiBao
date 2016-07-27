//
//  PDRequestGenerator.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//  request生成器

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "OMServiceFactory.h"
#import "OMSignatureGenerator.h"
#import "OMCommonParamsGenerator.h"
#import "NSDictionary+PDNetworkingMethods.h"
#import "NSURLRequest+PDNetworkingMethods.h"
#import "OMNetworkingConfiguration.h"
@interface OMRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

- (NSURLRequest *)generatePOSTRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

- (NSURLRequest *)generateRestfulGETRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

- (NSURLRequest *)generateRestfulPOSTRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
