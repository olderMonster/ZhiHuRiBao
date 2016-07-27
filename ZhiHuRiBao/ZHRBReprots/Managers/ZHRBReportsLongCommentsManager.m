//
//  ZHRBReportsLongCommentsManager.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/26.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsLongCommentsManager.h"

@implementation ZHRBReportsLongCommentsManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName{
    
    NSString *url = [NSString stringWithFormat:@"story/%@/long-comments",self.reportsId];
    return url;
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
