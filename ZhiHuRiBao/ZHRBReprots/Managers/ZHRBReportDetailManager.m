//
//  ZHRBReportDetailManager.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportDetailManager.h"

@implementation ZHRBReportDetailManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName{
    return [NSString stringWithFormat:@"news/%@",self.reportsId];
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}

- (NSString *)serviceType{
    return kZHRBService;
}


#pragma mark - OMApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    if (self.reportsId == nil) {
        return NO;
    }
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    
    return YES;
}


@end
