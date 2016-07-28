//
//  ZHRBLaunchManager.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/27.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBLaunchManager.h"
#import <UIKit/UIKit.h>
@implementation ZHRBLaunchManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        
    }
    return self;
}


#pragma mark -- OMApiManager
- (NSString *)methodName{
    return @"start-image/1080*1776";
}

- (NSString *)serviceType{
    return kZHRBService;
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}


#pragma mark - OMApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    return YES;
}


@end
