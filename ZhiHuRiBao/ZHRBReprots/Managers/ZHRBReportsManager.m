//
//  ZHRBReportsManager.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/21.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsManager.h"

@interface ZHRBReportsManager()


@end

@implementation ZHRBReportsManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName{
    return @"news/latest";
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}

- (NSString *)serviceType{
    return kZHRBService;
}

//- (NSDictionary *)reformParams:(NSDictionary *)params{
//    NSMutableDictionary *apiParams = [NSMutableDictionary dictionaryWithDictionary:params];
//    return apiParams;
//}

#pragma mark - OMApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    return YES;
}


@end
