//
//  PDSignatureGenerator.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//  签名生成器

#import <Foundation/Foundation.h>

@interface OMSignatureGenerator : NSObject

+ (NSString *)signGetWithSigParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVerison:(NSString *)apiVersion
                        privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVerison:(NSString *)apiVersion privateKey:(NSString *)privateKey;

+ (NSString *)signPostWithAllParams:(NSDictionary *)allParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (NSString *)signRestfulPostWithApiParams:(id)allParams commonParams:(NSDictionary *)commonParams methodName:(NSString *) methodName apiVerison:(NSString *)apiVersion privateKey:(NSString *)privateKey;

@end
