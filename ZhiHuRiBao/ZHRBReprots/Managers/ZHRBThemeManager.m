//
//  ZHRBThemeManager.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/28.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBThemeManager.h"

@implementation ZHRBThemeManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName{
    
    return @"themes";
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}

- (NSString *)serviceType{
    return kZHRBService;
}


#pragma mark - OMApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    return YES;
}


@end
