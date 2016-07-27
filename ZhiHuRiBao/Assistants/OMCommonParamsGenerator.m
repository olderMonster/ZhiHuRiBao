//
//  PDCommonParamsGenerator.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMCommonParamsGenerator.h"
#import "OMAppContext.h"
@implementation OMCommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary{
//    PDAppContext *context = [PDAppContext sharedInstance];
//    return @{@"app":context.appName,
//             @"macid":context.macid,
//            };
    
    return @{
//             @"__version":@"1.0.6.1112",
//             @"__plat":@"ios",
             };
}

+ (NSDictionary *)commonParamsDictionaryForLog{
    OMAppContext *context = [OMAppContext sharedInstance];
    return @{
             @"app":context.appName,
             @"macid":context.macid,
             };
}

@end
