//
//  PDSignatureGenerator.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMSignatureGenerator.h"

@implementation OMSignatureGenerator

+ (NSString *)signGetWithSigParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVerison:(NSString *)apiVersion
                        privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey{
    return @"signature";
}


+ (NSString *)signPostWithAllParams:(NSDictionary *)allParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey{
    return @"signature";
}

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVerison:(NSString *)apiVersion privateKey:(NSString *)privateKey;{
    return @"signature";
}

+ (NSString *)signRestfulPostWithApiParams:(id)allParams commonParams:(NSDictionary *)commonParams methodName:(NSString *) methodName apiVerison:(NSString *)apiVersion privateKey:(NSString *)privateKey{
    return @"signature";
}

@end
